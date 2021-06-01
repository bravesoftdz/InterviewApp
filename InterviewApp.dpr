program InterviewApp;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  TimerUnit in 'TimerUnit.pas',
  TimerEditUnit in 'TimerEditUnit.pas' {TimerEdit},
  DataUnit in 'DataUnit.pas',
  ApiJsonParseUnit in 'ApiJsonParseUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Interview App';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
