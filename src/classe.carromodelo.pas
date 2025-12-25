unit classe.carromodelo;

interface

uses
  System.Classes,
  System.SysUtils,
  classe.carro,
  FireDAC.Comp.Client;

type
  TCarroModelo = class
    private
      fid: Integer;
      fcarro: TCarro;
      fdescricaomodelo: string;
      fanolancamento: integer;
    public
      property id: Integer read fid write fid;
      property carro: TCarro read fcarro write fcarro;
      property descricaomodelo: string read fdescricaomodelo write fdescricaomodelo;
      property anolancamento: Integer read fanolancamento write fanolancamento;

      function inserircarromodelo(out pErro: string;
        out pId: integer): Boolean;
      function existecarromodelo(out pErro: string): Boolean;
  end;

implementation

uses uDM;

{ TCarroModelo }

function TCarroModelo.inserircarromodelo(out pErro: string; out pId: integer): Boolean;
var
  vSql: string;
begin
  DM.ConectarDatabase;
  DM.FDConnection.StartTransaction;

  vSql := ' INSERT INTO public.carromodelo(idcarro, descricaomodelo, anolancamento) ' +
          ' VALUES (:idcarro, :descricaomodelo, :anolancamento) ' +
          ' RETURNING id ';

  Result := DM.InserirDadosBD(vSql, [carro.id, descricaomodelo, anolancamento], pErro, pId);
  Id := pId;

  if pErro <> '' then
  begin
    if DM.FDConnection.InTransaction then
      DM.FDConnection.Rollback;
    Exit;
  end;

  if DM.FDConnection.InTransaction then
    DM.FDConnection.Commit;
end;

function TCarroModelo.existecarromodelo(out pErro: string): Boolean;
var
  vSql: string;
begin
  Result := True;
  DM.ConectarDatabase;
  vSql := 'select idcarro from public.carromodelo where descricaomodelo = :descricaomodelo '+
    ' and anolancamento = :anolancamento ';
  DM.ExecutarSQL(vSql, [descricaomodelo, anolancamento], pErro);
  if DM.FDQuery.RecordCount > 0 then
  begin
    pErro := 'Carro modelo já existe!';
    Exit;
  end;
  Result := False;
end;

end.
