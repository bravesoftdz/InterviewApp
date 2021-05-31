unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.WinXPanels, Vcl.ComCtrls, Vcl.Buttons, TimerUnit, Unit2,
  System.Notification, DataUnit, ApiJsonParse, Gifimg, IdHttp, IdSSLOpenSSL;

type
  TForm1 = class(TForm)
    pnlMenu: TPanel;
    imgPnlMenu: TImage;
    pnlTimer: TPanel;
    imgTimer: TImage;
    lblMenuTimer: TLabel;
    pnlParent: TPanel;
    pgcParent: TPageControl;
    pnlApi: TPanel;
    imgApi: TImage;
    lblApi: TLabel;
    tabTimer: TTabSheet;
    tabApi: TTabSheet;
    lblSearch: TLabel;
    btnStart: TSpeedButton;
    btnStop: TSpeedButton;
    lblTimer: TLabel;
    ntfTimerTerminatedNotification: TNotificationCenter;
    cbSearchParams: TComboBox;
    edValue: TEdit;
    btnSearch: TSpeedButton;
    pnlInfo: TPanel;
    imgFlag: TImage;
    Label1: TLabel;
    lblCountry: TLabel;
    Label2: TLabel;
    lblPopulation: TLabel;
    Label3: TLabel;
    lblCapital: TLabel;
    Label4: TLabel;
    lblRegion: TLabel;
    Label5: TLabel;
    lblArea: TLabel;
    listTimezones: TListBox;
    Label6: TLabel;
    Label7: TLabel;
    listCurrencies: TListBox;
    Label8: TLabel;
    listLanguages: TListBox;
    Label9: TLabel;
    lblSubRegion: TLabel;
    procedure pnlTimerMouseEnter(Sender: TObject);
    procedure pnlTimerMouseLeave(Sender: TObject);
    procedure pnlTimerClick(Sender: TObject);
    procedure pnlApiClick(Sender: TObject);
    procedure pnlApiMouseEnter(Sender: TObject);
    procedure pnlApiMouseLeave(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblTimerClick(Sender: TObject);
    procedure lblTimerMouseEnter(Sender: TObject);
    procedure lblTimerMouseLeave(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edValueKeyPress(Sender: TObject; var Key: Char);
  public
    procedure TimerTerminatedHandler;
    procedure TimeChangedHandler(sec, min, hour : ShortInt);
  end;

var
  Form1 : TForm1;
  timer : TMyTimer;
  secs, mins, hours : ShortInt;
implementation

{$R *.dfm}

// Timer Procedures ///////

// Handles incoming invokes from timerUnit and timerEdit
procedure TForm1.TimeChangedHandler(sec, min, hour : ShortInt);
var
  strSec, strMin : string;
begin
// Save Values here
  secs := sec;
  mins := min;
  hours := hour;

// Adding 0 when value is lower then 10
  if sec < 10 then
  begin
    strSec := '0' + IntToStr(sec);
  end
  else
    strSec := IntToStr(sec);
  if min < 10 then
  begin
    strMin := '0' + IntToStr(min);
  end
  else
    strMin := IntToStr(min);

   lblTimer.Caption := IntToStr(hour) + ':' + strMin + ':' + strSec;
end;

// When timer is terminated creating Windows notification and sending
procedure TForm1.TimerTerminatedHandler;
var
  MyNotification: TNotification;
begin
  MyNotification := ntfTimerTerminatedNotification.CreateNotification;
  try
    MyNotification.Name := 'Timer';
    MyNotification.Title := 'Time is up!';

    ntfTimerTerminatedNotification.PresentNotification(MyNotification);
  finally
    MyNotification.Free;
  end;

end;


procedure TForm1.btnStartClick(Sender: TObject);
begin
  timer.Start(secs, mins, hours);
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  timer.Stop;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  timer := TMytimer.Create(TimeChangedHandler, TimerTerminatedHandler);
  // Start values for timer
  secs := 30;
  mins := 2;
  hours := 0;

  lblTimer.Caption := IntToStr(hours) + ':0' + IntToStr(mins) + ':' + IntToStr(secs);
end;

// Opening TimerEdit form
procedure TForm1.lblTimerClick(Sender: TObject);
var
  form : TTimerEdit;
begin
  if not timer.IsRunning then
  begin
    form := TTimerEdit.Create(self);
    form.Show;
    form.seSecs.Value := secs;
    form.seMins.Value := mins;
    form.seHours.Value := hours;
    // Passing event handler that will process changing values in TimerEdit form
    form.OnTimeChanged := TimeChangedHandler;
  end;
end;
// Timer procedures ///////

// Api procedures ///////

// When hit enter on edValue(editbox to enter country name)
procedure TForm1.edValueKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnSearchClick(Sender);
  end;
end;

procedure TForm1.btnSearchClick(Sender: TObject);
var
  api : ApiCountries;
  item : TItemDTO;
  i, count: Integer;

  ms : TMemoryStream;
  img : TPngImage;

  http : TIdHttp;
begin
  api := ApiCountries.Create;
  item := api.GetCountryByName(edValue.Text);

  if item = nil then begin
    ShowMessage('Something went wrong!');
    exit;
  end;

  // Clear lists
  listCurrencies.Items.Clear;
  listLanguages.Items.Clear;
  listTimezones.Items.Clear;

  // Fill all received data
  lblCountry.Caption := item.Name;
  lblCapital.Caption := item.Capital;
  lblArea.Caption := System.Double.ToString(item.Area) + 'm�';
  lblRegion.Caption := item.Region;
  lblSubRegion.Caption := item.Subregion;
  lblPopulation.Caption := IntToStr(item.Population);

  count := Length(item.Currencies);

  for i := 0 to count - 1 do begin
    listCurrencies.Items.Add(
    item.Currencies[i].Name + ' / ' +
    item.Currencies[i].Code + ' / ' +
    item.Currencies[i].Symbol)
  end;

  count := Length(item.Languages);

  for i := 0 to count - 1 do begin
    listLanguages.Items.Add(item.Languages[i].Name);
  end;

  count := item.TimezonesArrayCount;

  for i := 0 to count - 1 do begin
    listTimezones.Items.Add(item.Timezones[i])
  end;

  // Load image Doesnt work yet
  ms := TMemoryStream.Create;
  img := TPngImage.Create;
  http := TIdHTTP.Create(nil);

  try
    http.Get(item.Flag, ms);
    ms.Seek(0, soFromBeginning);
    img.LoadFromStream(ms);
    imgFlag.Picture.Assign(img);
  finally
    FreeAndNil(img);
    FreeAndNil(ms);
  end;

end;

// Api procedures ///////

// Animations ///////
procedure TForm1.lblTimerMouseEnter(Sender: TObject);
begin
  lblTimer.Font.Color := $00FFFF8A;
end;

procedure TForm1.lblTimerMouseLeave(Sender: TObject);
begin
  lblTimer.Font.Color := clBlack;
end;

procedure TForm1.pnlApiClick(Sender: TObject);
begin
  tabApi.Visible := true;
  tabTimer.Visible := false;
end;

procedure TForm1.pnlTimerClick(Sender: TObject);
begin
  tabTimer.Visible := true;
  tabApi.Visible := false;
end;

procedure TForm1.pnlApiMouseEnter(Sender: TObject);
begin
   pnlApi.ParentBackground := false;
end;

procedure TForm1.pnlApiMouseLeave(Sender: TObject);
begin
  pnlApi.ParentBackground := true;
end;

procedure TForm1.pnlTimerMouseEnter(Sender: TObject);
begin
  pnlTimer.ParentBackground := false;
end;

procedure TForm1.pnlTimerMouseLeave(Sender: TObject);
begin
  pnlTimer.ParentBackground := true;
end;
// Animations ///////
end.
