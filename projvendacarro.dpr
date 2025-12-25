program projvendacarro;

uses
  Vcl.Forms,
  classe.carro in 'src\classe.carro.pas',
  classe.carromodelo in 'src\classe.carromodelo.pas',
  uDM in 'src\uDM.pas' {DataModule2: TDataModule},
  uprincipal in 'src\uprincipal.pas' {Form1},
  classe.cliente in 'src\classe.cliente.pas',
  classe.venda in 'src\classe.venda.pas',
  uLib in 'src\uLib.pas',
  classe.executadora in 'src\classe.executadora.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule2, DM);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
