// Class describes TimerEdit => 'messagebox' to choose time in timer

unit TimerEditUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.Buttons, TimerUnit;

type
  TTimerEdit = class(TForm)
    seHours: TSpinEdit;
    lblHour: TLabel;
    lblMins: TLabel;
    seMins: TSpinEdit;
    lblSecs: TLabel;
    seSecs: TSpinEdit;
    lblChar1: TLabel;
    lblChar2: TLabel;
    btnDone: TSpeedButton;
    procedure btnCloseClick(Sender: TObject);
    procedure seHoursChange(Sender: TObject);
    procedure seMinsChange(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnDoneClick(Sender: TObject);
  private
    onTimeChangedEvent : TTimeChangedEvent;
  public
    property OnTimeChanged : TTimeChangedEvent write onTimeChangedEvent;
  end;

var
  TimerEdit: TTimerEdit;

implementation

{$R *.dfm}

procedure TTimerEdit.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

// Drag form
procedure TTimerEdit.btnDoneClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TTimerEdit.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = $F012;
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

// Checks only lower value
procedure TTimerEdit.seHoursChange(Sender: TObject);
var
  edit : TSpinEdit;
begin
  edit := TSpinEdit(Sender);

  if edit.Value < 0 then
    edit.Value := 0;

  if edit.Value > 127 then
    edit.Value := 127;

// Notify timer that value has changed
  if Assigned(onTimeChangedEvent) then
    onTimeChangedEvent(seSecs.Value, seMins.Value, seHours.Value);

end;

// Checks upper value and reffers to seHoursChange to check lower value
procedure TTimerEdit.seMinsChange(Sender: TObject);
var
  edit : TSpinEdit;
begin
  edit := TSpinEdit(Sender);

  if edit.Value > 59 then
    edit.Value := 59;

// Check lower value and notify
  Self.seHoursChange(Sender);
end;

end.
