program InterviewApp;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  TimerUnit in 'TimerUnit.pas',
  Unit2 in 'Unit2.pas' {TimerEdit},
  DataUnit in 'DataUnit.pas',
  ApiJsonParse in 'ApiJsonParse.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Interview App';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
