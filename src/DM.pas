unit DM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TDataModule2 = class(TDataModule)
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function InserirDadosBD(pComando: string; out pErro: string): Boolean;
    function ExecutarSQL(pComando: string; out pErro: string): Boolean;
  end;

var
  DataModule2: TDataModule2;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule2 }

function TDataModule2.ExecutarSQL(pComando: string; out pErro: string): Boolean;
begin
  try
    FDQuery.Close;
    FDQuery.SQL.Text := pComando;
    FDQuery.Open;
  except
    on E: Exception do
    begin
      pErro := 'Erro na execução do SQL: ' + E.Message;
      Result := False;
      raise;
    end;
  end;
end;

function TDataModule2.InserirDadosBD(pComando: string; out pErro: string): Boolean;
begin
  try
    FDQuery.Close;
    FDQuery.SQL.Text := pComando;
    FDQuery.ExecSQL;
  except
    on E: Exception do
    begin
      pErro := 'Erro na execução do SQL: ' + E.Message;
      Result := False;
      raise;
    end;
  end;
end;

end.
