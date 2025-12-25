unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, System.Variants;

type
  TDataModule2 = class(TDataModule)
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ConectarDatabase;
    function InserirDadosBD(pSql: string; const AParams: array of Variant; out pErro: string; out pId: Integer): Boolean;
    function ExecutarSQL(pSql: string; const AParams: array of Variant; out pErro: string): Boolean;

  end;

var
  DM: TDataModule2;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule2 }

procedure TDataModule2.ConectarDatabase;
var
  vPath: string;
begin
  if not FDConnection.Connected then
  begin
    vPath := ExtractFilePath(ParamStr(0));
    FDPhysPgDriverLink.VendorLib := vPath+'\dlls\libpq.dll';
    FDConnection.Open;
  end;
end;

function TDataModule2.InserirDadosBD(pSql: string; const AParams: array of Variant; out pErro: string; out pId: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  try
    FDQuery.Close;
    FDQuery.SQL.Text := pSql;

    if High(AParams) >= 0 then
    begin
      for i := Low(AParams) to High(AParams) do
      begin
        if i < FDQuery.Params.Count then
        begin
          if (VarType(AParams[i]) = varDate) then
          begin
            FDQuery.Params[i].DataType := ftDate;
            FDQuery.Params[i].AsDate   := AParams[i];
          end
          else
            FDQuery.Params[i].Value := AParams[i];
        end;
      end;
    end;

    FDQuery.Open;

    if not FDQuery.IsEmpty then
      pId := FDQuery.FieldByName('id').AsInteger
    else
      pId := 0;

    Result := True;
  except
    on E: Exception do
    begin
      pErro := 'Erro na execução do SQL: ' + E.Message;
      Result := False;
    end;
  end;
end;

function TDataModule2.ExecutarSQL(pSql: string; const AParams: array of Variant; out pErro: string): Boolean;
var
  i: Integer;
begin
  try
    Result := False;
    FDQuery.Close;
    FDQuery.SQL.Text := pSql;
    if High(AParams) >= 0 then
    begin
      for i := Low(AParams) to High(AParams) do
      begin
        if i < FDQuery.Params.Count then
          FDQuery.Params[i].Value := AParams[i];
      end;
    end;
    FDQuery.Open;
    Result := True;
  except
    on E: Exception do
    begin
      pErro := 'Erro na execução do SQL: ' + E.Message;
      Result := False;
    end;
  end;
end;


end.
