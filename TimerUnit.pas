// Class describes Timer and async method(class) to count ticks

unit TimerUnit;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, Classes,
     System.Variants, System.DateUtils;

  type
    TTimeChangedEvent = procedure(sec, min, hour : ShortInt) of object;

  type
    TTerminatedEvent = procedure of object;

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
      procedure Stop;
      procedure TerminatedHandler;
   end;
  implementation

{$REGION 'Implementation of MyTimer'}

constructor TMyTimer.Create( timeChangedEventHandler : TTimeChangedEvent;
terminatedEventHandler : TTerminatedEvent);
begin
// Save handlers to invoke later
  onTimeChanged := timeChangedEventHandler;
  onTerminated := terminatedEventHandler;
end;

procedure TMyTimer.Start(sec, min, hour : ShortInt);
begin

if not running then
  begin
    myThread := TMyThread.Create(sec, min, hour, onTimeChanged, TerminatedHandler);
    myThread.Priority := tpHighest;
    running := true;
  end;

end;

procedure TMyTimer.Stop;
begin
  if Assigned(myThread) then begin
    myThread.Terminate;
    running := false;
  end;
end;

// Invokes next handler
procedure TMyTimer.TerminatedHandler;
begin
  running := false;

  if Assigned(onTerminated) then
    myThread.Synchronize(onTerminated);
end;

{$ENDREGION}

{$REGION 'Implementation of MyThread'}

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
var
  nextTick : Int64;
begin
  // Declaring where timer begins
  nextTick := DateTimeToMilliseconds(Now);

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

    // Here we wait from previous tick + 1second, so it works correctly
    nextTick := nextTick + 1000;

    while DateTimeToMilliseconds(Now) < nextTick do
    begin
      Sleep(nextTick - DateTimeToMilliseconds(Now));
    end;

  end;
end;

{$ENDREGION}

end.
