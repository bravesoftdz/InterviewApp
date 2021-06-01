unit DataUnit;

interface

uses
  System.Generics.Collections;

type

  TLanguagesDTO = class
  private
    FName: string;
  published
    property Name: string read FName write FName;
  end;

  TCurrenciesDTO = class
  private
    FCode: string;
    FName: string;
    FSymbol: string;
  published
    property Code: string read FCode write FCode;
    property Name: string read FName write FName;
    property Symbol: string read FSymbol write FSymbol;
  end;

  TItemDTO = class
  private
    FArea: double;
    FCapital: string;

    FFlag: string;
    FName: string;
    FPopulation: Integer;
    FRegion: string;
    FSubregion: string;

    // Timezones, proper way to declare and use Arrays
    // but... its time requiring so i've made public fields of arrays
    FTimezones: array of string;
    function GetTimezonesArray(index : Integer) : string;
    function GetTimezonesArrayCount : Integer;
    procedure SetTimezonesArray(index : Integer; const value : string);
    procedure SetTimezonesArrayCount(value : Integer);

  public
    // Not correct, but ok.
    // In Delphi u cant use array as property... soo...
    Languages: array of TLanguagesDTO;
    Currencies: array of TCurrenciesDTO;

    property Area: double read FArea write FArea;
    property Capital: string read FCapital write FCapital;
    property Flag: string read FFlag write FFlag;
    property Name: string read FName write FName;
    property Population: Integer read FPopulation write FPopulation;
    property Region: string read FRegion write FRegion;
    property Subregion: string read FSubregion write FSubregion;

    // Correct way to work with Arrays!
    property Timezones[Index : integer]: string read GetTimezonesArray write SetTimezonesArray;
    property TimezonesArrayCount : integer read GetTimezonesArrayCount write SetTimezonesArrayCount;
  public
  end;

  TRootDTO = class
  private
    FItemsArray: array of TItemDTO;

    function GetItemArray(index : Integer) : TItemDTO;
    function GetItemArrayCount : Integer;
    procedure SetItemArray(index : Integer; const value : TItemDTO);
    procedure SetItemArrayCount(value : Integer);
  public
    property Items[Index : Integer]: TItemDTO read GetItemArray write SetItemArray;
    property ItemsCount: Integer read GetItemArrayCount write SetItemArrayCount;
  end;

implementation

// Arrays Get/Set methodes For Timezones
function TItemDTO.GetTimezonesArray(index : Integer): string;
begin
  Result := FTimezones[index];
end;

function TItemDTO.GetTimezonesArrayCount : Integer;
begin
  Result := Length(FTimezones);
end;

procedure TItemDTO.SetTimezonesArray(index : Integer; const value : string);
begin
  FTimezones[index] := value;
end;

procedure TItemDTO.SetTimezonesArrayCount(value : Integer);
begin
  SetLength(FTimezones, value);
end;

// Arrays Get/Set methodes For Items of Root
function TRootDTO.GetItemArray(index : Integer) : TItemDTO;
begin
  Result := FItemsArray[index];
end;

function TRootDTO.GetItemArrayCount : Integer;
begin
  Result := Length(FItemsArray);
end;

procedure TRootDTO.SetItemArray(index : Integer; const value : TItemDTO);
begin
  FItemsArray[index] := value;
end;

procedure TRootDTO.SetItemArrayCount(value : Integer); begin
  SetLength(FItemsArray, value);
end;

end.
