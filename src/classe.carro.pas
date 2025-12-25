unit classe.carro;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TCarro = class
    private
      fid: Integer;
      fdescricaocarro: string;
    public
      property id: Integer read fid write fid;
      property descricaocarro: string read fdescricaocarro write fdescricaocarro;

      function inserircarro(out pErro: string;
        out pId: integer): Boolean;
      function existecarro(out pErro: string): Boolean;

      class var instCarro: TCarro;
      class function CreateInstance: TCarro;
      class procedure FinalizeInstance;

  end;

implementation

uses uDM;

{ TCarro }

class function TCarro.CreateInstance: TCarro;
begin
  if instCarro = nil then
    instCarro := TCarro.Create;
  Result := instCarro;
end;

class procedure TCarro.FinalizeInstance;
begin
  FreeAndNil(instCarro);
end;

function TCarro.inserircarro(out pErro: string; out pId: integer): Boolean;
var
  vSql: string;
begin
  DM.ConectarDatabase;
  DM.FDConnection.StartTransaction;

  vSql := 'INSERT INTO public.carro(descricaocarro) '
    + ' VALUES (:descricaocarro) '
    + ' RETURNING id';

  Result := DM.InserirDadosBD(vSql, [descricaocarro], pErro, pId);
  id := pId;

  if pErro <> '' then
  begin
    if DM.FDConnection.InTransaction then
      DM.FDConnection.Rollback;
    Exit;
  end;

  if DM.FDConnection.InTransaction then
    DM.FDConnection.Commit;
end;

function TCarro.existecarro(out pErro: string): Boolean;
var
  vSql: string;
begin
  DM.ConectarDatabase;
  Result := True;
  vSql := 'select id from public.carro where descricaocarro = :descricaocarro ';
  DM.ExecutarSQL(vSql, [descricaocarro], pErro);
  if DM.FDQuery.RecordCount > 0 then
  begin
    id := DM.FDQuery.FieldByName('id').AsInteger;
    Exit;
  end;
  Result := False;
end;

end.
