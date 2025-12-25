unit classe.cliente;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client;

type
  TCliente = class
    private
      fid: Integer;
      fnomecliente: string;
      fcpf: string;
    public
      property id: Integer read fid write fid;
      property nomecliente: string read fnomecliente write fnomecliente;
      property cpf: string read fcpf write fcpf;

      constructor Create;
      destructor Destroy; override;

      function inserircliente(pCliente: TCliente; out pErro: string;
        out pId: integer): Boolean;
      function inserirclientenovo(out pErro: string; out pId: integer): Boolean;

      class var instCliente: TCliente;
      class function CreateInstance: TCliente;
      class procedure FinalizeInstance;
  end;

implementation

uses uDM, uLib;

{ TCliente }

constructor TCliente.Create;
begin
  id := 0;
end;

destructor TCliente.Destroy;
begin
  //
  inherited;
end;

class function TCliente.CreateInstance: TCliente;
begin
  if instCliente = nil then
    instCliente := TCliente.Create;
    instCliente.id := 0;
  Result := instCliente;
end;

class procedure TCliente.FinalizeInstance;
begin
  FreeAndNil(instCliente);
end;


function TCliente.inserircliente(pCliente: TCliente;
  out pErro: string; out pId: integer): Boolean;
var
  vSql: string;
begin
  if not ValidarCPF(pCliente.cpf) then
  begin
    pErro := 'CPF inválido!';
    Exit;
  end;

  DM.ConectarDatabase;
  DM.FDConnection.StartTransaction;

  vSql := 'INSERT INTO public.cliente(nomecliente, cpf) '
    + 'VALUES (:nomecliente, :cpf) RETURNING id';

  Result := DM.InserirDadosBD(vSql, [nomecliente, cpf], pErro, pId);

  if pErro <> '' then
  begin
    if DM.FDConnection.InTransaction then
      DM.FDConnection.Rollback;
    Exit;
  end;

  if DM.FDConnection.InTransaction then
    DM.FDConnection.Commit;
end;

function TCliente.inserirclientenovo(out pErro: string; out pId: integer): Boolean;
var
  vSql: string;
begin
  if not ValidarCPF(cpf) then
  begin
    pErro := 'CPF inválido!';
    Exit;
  end;

  DM.ConectarDatabase;
  DM.FDConnection.StartTransaction;

  vSql := 'INSERT INTO public.cliente (nomecliente, cpf) ' +
          'VALUES (:nome, :cpf) RETURNING id';

  Result := DM.InserirDadosBD(vSql, [nomecliente, cpf], pErro, pId);
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

end.
