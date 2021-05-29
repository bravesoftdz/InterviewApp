unit TimerUnit;

interface

uses Classes, System.SysUtils;

  type
    TTimeChangedEvent = procedure(sec, min, hour : ShortInt);

  type
    TTerminatedEvent = procedure;

  type
    TMyThread = class(TThread)
  private
    var s, m, h : ShortInt;
    onTimeChanged : TTimeChangedEvent;
    onTerminated : TTerminatedEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(sec, min, hour : ShortInt;
    timeChangedEventHandler : TTimeChangedEvent;
    terminatedEventHandler : TTerminatedEvent);
  end;
  // These 2 classes are pretty same, class MyTimer will be needed later while adding new functions of timer
  type
    TMyTimer = class
    private
      onTimeChanged : TTimeChangedEvent;
      onTerminated : TTerminatedEvent;
      myThread : TMyThread;
      running : boolean;
    public
      constructor Create( timeChangedEventHandler : TTimeChangedEvent;
      terminatedEventHandler : TTerminatedEvent);
      property IsRunning : boolean read running;
      procedure Start(sec, min, hour : ShortInt);
      procedure Stop();
   end;

  implementation

// Implementation of MyTimer //
constructor TMyTimer.Create( timeChangedEventHandler : TTimeChangedEvent;
terminatedEventHandler : TTerminatedEvent);
begin
  onTimeChanged := timeChangedEventHandler;
  onTerminated := terminatedEventHandler;
end;

procedure TMyTimer.Start(sec, min, hour : ShortInt);
begin

if not running then
  begin
    myThread := TMyThread.Create(sec, min, hour, onTimeChanged, onTerminated);
    myThread.Priority := tpHighest;
    running := true;
  end;

end;

procedure TMyTimer.Stop();
begin
  myThread.Terminate;
  running := false;
end;

// Implementation of MyThread //
constructor TMyThread.Create(sec, min, hour : ShortInt;
timeChangedEventHandler : TTimeChangedEvent;
terminatedEventHandler : TTerminatedEvent);
begin
  inherited Create(false);
  s := sec;
  m := min;
  h := hour;
  onTimeChanged := timeChangedEventHandler;
  onTerminated := terminatedEventHandler;
end;

// Runs loop and every +-1000 miliseconds and decrements values
procedure TMyThread.Execute;
begin
  while True do
  begin
    if Terminated then break;

    // Decrement values, if its 0:0:0 then invoke event onTerminate
    s := s - 1;
    if s < 0 then
    begin
      m := m - 1;
      if m < 0 then
      begin
        h := h - 1;
        if h < 0 then
          begin
            // Values are -1:-1:-1
             if Assigned(onTerminated) then
                onTerminated();
            break;
          end;
        m := 59;
      end;
      s := 59
    end;

    // Notify decrement/time changing
    if Assigned(onTimeChanged)then
      onTimeChanged(s,m,h);

    // Definitely worst way to program timer

    Sleep(1000);
  end;
end;

end.
