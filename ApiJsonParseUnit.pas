// Class describes Parsing json data(from api) to object and getting flag image from api

unit ApiJsonParseUnit;

interface
  uses DataUnit, System.Net.HttpClient, System.Json,
   System.Classes, Vcl.Graphics, Vcl.Imaging.jpeg, SysUtils;

  type
    ApiCountries = class
      private
        // Class with all properties we need from json file
        FRoot : TRootDTO;
        function ParseJsonToObject(value : TJSonValue) : TRootDTO;
      public
        property Root : TRootDTO read Froot write Froot;
        function GetCountryByParameter(typeParam, param : string) : TItemDTO;
        function GetFlagImage(code : string) : TJPEGImage;
    end;

implementation

function ApiCountries.GetCountryByParameter(typeParam, param : string) : TItemDTO;
var

  query: String;
  http: THttpClient;
  httpResponse: IHttpResponse;
  response : string;
  status : integer;
  jsonValue : TJSonValue;

begin

  if Length(param)=0 then begin
    Result := nil;
    exit;
  end;

  query := 'https://restcountries.eu/rest/v2/' + typeParam +  '/' + param;

  http := THTTPClient.Create;

  try
    HttpResponse := http.Get(query);
    response := HttpResponse.ContentAsString;
    http.Free;
  except
    Result := nil;
    exit;
  end;

  jsonValue := TJSonObject.ParseJSONValue(response);

  // If there is no response value
  if Length(response) = 0 then begin
    Result := nil;
    exit;
  end;

  // If error
  if jsonValue.TryGetValue<integer>('status', status) then begin
    if (status >= 400) or (status < 500) then begin
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

// If u give ISO-code as paramater => u get only 1 country back
// If u give country name as param => i get array of countries (also capital)
  if value is TJSONArray then begin
    rootArray := value as TJSONArray;
  end
  else begin
    rootArray := TJSONArray.Create;
    rootArray.AddElement(value);
  end;

  root := TRootDTO.Create;
  root.ItemsCount := rootArray.Count;

  i := 0;
  for rootElement in rootArray do begin
    item := TItemDTO.Create;

    // Get primary values
    item.Name := rootElement.GetValue<string>('name');
    item.Capital := rootElement.GetValue<string>('capital');
    item.Region := rootElement.GetValue<string>('region');
    item.Subregion := rootElement.GetValue<string>('subregion');
    item.Population := rootElement.GetValue<integer>('population');

    // Sometimes is area null so we check first if its not null
    if not (rootElement.GetValue<TJSONValue>('area')  is TJSONNull) then begin
      item.Area := rootElement.GetValue<double>('area');
    end
    else item.Area := 0;

    item.Flag := (rootElement.GetValue<TJSONValue>('altSpellings') as TJSONArray).Items[0].GetValue<string>();

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

// Flag Dowloading from another api bc restcountries api gives svg file as flag
// and its quite complicated to work with it in delphi
function ApiCountries.GetFlagImage(code: string) : TJPEGImage;
var
  http : THTTPClient;
  httpResponse: IHttpResponse;
  query : string;
  ms : TMemoryStream;
  img : TJPEGImage;
begin

  if Length(code) <> 2 then begin
    Result := nil;
    exit;
  end;

  query := 'https://flagcdn.com/w2560/' + LowerCase(code) + '.jpg';

  http := THTTPClient.Create;
  ms := TMemoryStream.Create;

  try
    httpResponse := http.Get(query, ms);
    ms.Position := 0;

    img := TJPEGImage.Create;
    // Loading image from memorystream
    img.LoadFromStream(ms);

    http.Free;
  except
    Result := nil;
    exit;
  end;

  Result := img;
end;

end.
