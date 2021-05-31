unit ApiJsonParse;

interface
  uses DataUnit, System.Net.HttpClient, System.Json;

  type
    ApiCountries = class
      private
        // Class with all properties we need from json file
        FRoot : TRootDTO;
        function ParseJsonToObject(value : TJSonValue) : TRootDTO;
      public
        property Root : TRootDTO read Froot write Froot;
        function GetCountryByName(name : string) : TItemDTO;
    end;

implementation

function ApiCountries.GetCountryByName(name : string) : TItemDTO;
var

  query: String;
  httpClient: THttpClient;
  httpResponse: IHttpResponse;
  response : string;
  status : integer;
  jsonValue : TJSonValue;

begin

  if Length(name)=0 then begin
    Result := nil;
    exit;
  end;


  query := 'https://restcountries.eu/rest/v2/name/' + name;

  httpClient := THTTPClient.Create;

  try
    HttpResponse := HttpClient.Get(query);
    response := HttpResponse.ContentAsString;
    HttpClient.Free;
  except
    Result := nil;
    exit;
  end;

  jsonValue := TJSonObject.ParseJSONValue(response);

  if jsonValue.TryGetValue<integer>('status', status) then begin
    if status = 404 then begin
      Result := nil;
      exit;
    end;
  end;

  Result := ParseJsonToObject(jsonValue).Items[0];
end;

function ApiCountries.ParseJsonToObject(value : TJSonValue) : TRootDTO;
var
  rootElement, arrayElementItem: TJSonValue;
  rootArray, arrayElement: TJSONArray;

  root : TRootDTO;
  item : TItemDTO;

  currency : TCurrenciesDTO;
  language : TLanguagesDTO;

  i, j : integer;
begin
  rootArray := value as TJSONArray;

  root := TRootDTO.Create;
  root.ItemsCount := rootArray.Count;

  i := 0;
  for rootElement in rootArray do begin
    item := TItemDTO.Create;

    // Get primary values
    item.Name := rootElement.GetValue<string>('name');
    item.Capital := rootElement.GetValue<string>('capital');
    item.Area := rootElement.GetValue<double>('area');
    item.Flag := rootElement.GetValue<string>('flag');
    item.Region := rootElement.GetValue<string>('region');
    item.Subregion := rootElement.GetValue<string>('subregion');
    item.Population := rootElement.GetValue<integer>('population');

    // Array of currencies
    arrayElement := rootElement.GetValue<TJSONValue>('currencies') as TJSONArray;
    SetLength(item.Currencies, arrayElement.Count);

    j := 0;
    for arrayElementItem in arrayElement do begin
      currency := TCurrenciesDTO.Create;

      currency.Name := arrayElementItem.GetValue<string>('name');
      currency.Code := arrayElementItem.GetValue<string>('code');
      currency.Symbol := arrayElementItem.GetValue<string>('symbol');

      item.Currencies[j] := currency;
      j := j + 1;
    end;

    // Array of Languages
    arrayElement := rootElement.GetValue<TJSONValue>('languages') as TJSONArray;
    SetLength(item.Languages, arrayElement.Count);

    j := 0;
    for arrayElementItem in arrayElement do begin
      language := TLanguagesDTO.Create;

      language.Name := arrayElementItem.GetValue<string>('name');

      item.Languages[j] := language;
      j := j + 1;
    end;

    // Array of Timezones: (proper way, see comments in DataUnit)
    arrayElement := rootElement.GetValue<TJSONValue>('timezones') as TJSONArray;
    item.TimezonesArrayCount := arrayElement.Count;

    j := 0;
    for arrayElementItem in arrayElement do begin
      item.Timezones[j] := arrayElementItem.GetValue<string>();
      j := j + 1;
    end;

    root.Items[i] := item;
    i := i + 1;
  end;

  Result := root;
end;

end.
