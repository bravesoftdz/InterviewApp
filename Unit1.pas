unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.WinXPanels, Vcl.ComCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    pnlMenu: TPanel;
    imgPnlMenu: TImage;
    pnlTimer: TPanel;
    imgTimer: TImage;
    lblTimer: TLabel;
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
    procedure pnlTimerMouseEnter(Sender: TObject);
    procedure pnlTimerMouseLeave(Sender: TObject);
    procedure pnlTimerClick(Sender: TObject);
    procedure pnlApiClick(Sender: TObject);
    procedure pnlApiMouseEnter(Sender: TObject);
    procedure pnlApiMouseLeave(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  Form1 : TForm1;
  bruh : integer;
implementation

{$R *.dfm}

procedure TimeChangedHandler(m: integer);
begin
  ShowMessage('time');
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  bruh := 4;
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
