unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.WinXPanels, Vcl.ComCtrls, Vcl.Buttons, TimerUnit;

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
    Label1: TLabel;
    btnStart: TSpeedButton;
    btnStop: TSpeedButton;
    lblTimer: TLabel;
    procedure pnlTimerMouseEnter(Sender: TObject);
    procedure pnlTimerMouseLeave(Sender: TObject);
    procedure pnlTimerClick(Sender: TObject);
    procedure pnlApiClick(Sender: TObject);
    procedure pnlApiMouseEnter(Sender: TObject);
    procedure pnlApiMouseLeave(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1 : TForm1;
  timer : TMyTimer;

implementation

{$R *.dfm}

procedure TimeChangedHandler(sec, min, hour : ShortInt);
var
strSec, strMin : string;
begin
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

   Form1.lblTimer.Caption := IntToStr(hour) + ':' + strMin + ':' + strSec;
end;

procedure TimerTerminatedHandler();
begin
  ShowMessage('TERMINATED');
end;

procedure TForm1.btnStartClick(Sender: TObject);
begin
  timer.Start(20,2,0);
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  timer.Stop;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  timer := TMytimer.Create(TimeChangedHandler, TimerTerminatedHandler);
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

end.
