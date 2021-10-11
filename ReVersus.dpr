program ReVersus;

uses
  Forms,
  Main in 'Main.pas' {mForm},
  OpenGL in 'OpenGL.pas',
  Geometry in 'Geometry.pas',
  Textures in 'Textures.pas',
  Reversi in 'Reversi.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TmForm, mForm);
  Application.Run;
end.
