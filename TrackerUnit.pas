unit TrackerUnit;

interface
uses
  Classes, SysUtils, Controls, Graphics;

type

  { TMyTracker }

  TMyTracker = class(TGraphicControl)
  private
    FmouseDown :Boolean;
    FMaxX      :Integer;
  protected
    function Constrain(aValue, aMin, aMax:Integer):Integer; //always inclusive.
  public
    procedure MouseDown(Button :TMouseButton; Shift :TShiftState; X, Y :Integer);override;
    procedure MouseMove(Shift :TShiftState; X, Y :Integer);                      override;
    procedure MouseUp(Button :TMouseButton; Shift :TShiftState; X, Y :Integer);  override;
    procedure Paint;                                                             override;
    constructor Create(aOwner :TComponent);                                      override;

    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
  end;


implementation

uses math;

{ TMyTracker }

function TMyTracker.Constrain(aValue, aMin, aMax :Integer) :Integer;
begin
  Result := Max(aMin, Min(aMax, aValue));
end;

procedure TMyTracker.MouseDown(Button :TMouseButton; Shift :TShiftState; X, Y :Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  FMouseDown := True;
end;

procedure TMyTracker.MouseMove(Shift :TShiftState; X, Y :Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if FMouseDown then begin
    FMaxX       := Constrain(X, 1, Width-1);
    Invalidate;
  end;
end;

procedure TMyTracker.MouseUp(Button :TMouseButton; Shift :TShiftState; X, Y :Integer);
begin
  FMouseDown := False;
  FMaxX      := Constrain(X, 1, Width-1);
  Invalidate;
end;

procedure TMyTracker.Paint;
begin
  inherited Paint;
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color   := clGreen;
  Canvas.Rectangle(ClientRect);
  Canvas.Brush.Color := clSkyBlue;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Style   := psClear;
  Canvas.Rectangle(1, 1, FMaxX, Height-1);
  Canvas.Pen.Style   := psSolid;
end;

constructor TMyTracker.Create(aOwner :TComponent);
begin
  inherited Create(aOwner);
  FMaxX := Width div 2;
end;

end.
