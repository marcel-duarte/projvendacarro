unit classe.executadora;

interface

uses
  Vcl.Dialogs,
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  // exclusivo sistema
  classe.cliente,
  classe.carro,
  classe.carromodelo;

type
  TFazTudo = class
    public
    fListaCliente: TObjectList<TCliente>;
    fListaCarroModelo: TObjectList<TCarroModelo>;

    constructor Create;
    destructor Destroy; override;

    function Insere5Clientes: Boolean;
    function Insere5ModelosCarros: Boolean;
    function InsereCliente(pNomeCliente, pCpf: string;
      out pErro: String): Boolean;
    function InsereModeloCarro(pDescricaoCarro, pDescricaoModelo: string;
      pAnoLancamento: Integer; out pErro: String): Boolean;
  end;

implementation

{ TFazTudo }

constructor TFazTudo.Create;
begin
  fListaCliente := TObjectList<TCliente>.Create;
  fListaCarroModelo := TObjectList<TCarroModelo>.Create;
end;

destructor TFazTudo.Destroy;
begin
  fListaCliente.Free;
  fListaCarroModelo.Free;
  inherited;
end;

function TFazTudo.Insere5Clientes: Boolean;
var
  vCliente: TCliente;
  vErro: string;
  vId: Integer;
begin
  if not InsereCliente('MARCO AURELIO SILVA', '90934037027', vErro) then
    raise Exception.Create('Erro na inclusão de cliente: '+ vErro);

  if not InsereCliente('ARNALDO SOUZA NOGUEIRA', '09659293020', vErro) then
    raise Exception.Create('Erro na inclusão de cliente: '+ vErro);

  if not InsereCliente('FRANCISCO AMADEU', '09659887086', vErro) then
    raise Exception.Create('Erro na inclusão de cliente: '+ vErro);

  if not InsereCliente('CARLOS TADEU', '03179155094', vErro) then
    raise Exception.Create('Erro na inclusão de cliente: '+ vErro);

  if not InsereCliente('MARIA CLARA ALBUQUERQUE', '06103969000', vErro) then
    raise Exception.Create('Erro na inclusão de cliente: '+ vErro);

end;

function TFazTudo.Insere5ModelosCarros: Boolean;
var
  vCarro: TCarro;
  vCarroModelo: TCarroModelo;
  vErro: string;
  vId: Integer;
begin
  //// INCLUI MODELOS //////////////////////

  if not InsereModeloCarro('MAREA', 'MAREA SX', 2010, vErro) then
    raise Exception.Create('Erro na inclusão de modelo carro: '+ vErro);

  if not InsereModeloCarro('MAREA', 'MAREA ELX', 2011, vErro) then
    raise Exception.Create('Erro na inclusão de modelo carro: '+ vErro);

  if not InsereModeloCarro('MAREA', 'MAREA HLX', 2012, vErro) then
    raise Exception.Create('Erro na inclusão de modelo carro: '+ vErro);

  if not InsereModeloCarro('UNO', 'UNO ATTRACTIVE 1.0 FLEX', 2010, vErro) then
    raise Exception.Create('Erro na inclusão de modelo carro: '+ vErro);

  if not InsereModeloCarro('UNO', 'UNO DRIVE 1.0 FLEX', 2011, vErro) then
    raise Exception.Create('Erro na inclusão de modelo carro: '+ vErro);

end;


function TFazTudo.InsereCliente(pNomeCliente, pCpf: string;
  out pErro: String): Boolean;
var
  vCliente: TCliente;
  vId: Integer;
begin
  Result := False;
  vCliente := TCliente.Create;
  vCliente.nomecliente := pNomeCliente;
  vCliente.cpf := pCpf;
  vCliente.inserirclientenovo(pErro, vId);
  fListaCliente.Add(vCliente);
  if pErro <> '' then
  begin
    vCliente.Free;
  end;
  Result := True;

{
  vCliente.CreateInstance;
  vCliente.nomecliente := pNomeCliente;
  vCliente.cpf := pCpf;
  vCliente.inserircliente(vCliente, pErro, vId);
  fListaCliente.Add(vCliente);
  if pErro <> '' then
  begin
    vCliente.FinalizeInstance;
  end;
}
end;

function TFazTudo.InsereModeloCarro(pDescricaoCarro, pDescricaoModelo: string;
  pAnoLancamento: Integer; out pErro: String): Boolean;
var
  vCarroModelo: TCarroModelo;
  vId: Integer;
begin
  Result := False;
  vCarroModelo := TCarroModelo.Create;
  vCarroModelo.carro := TCarro.Create;
  vCarroModelo.carro.descricaocarro := pDescricaoCarro;
  vCarroModelo.descricaomodelo := pDescricaoModelo;
  vCarroModelo.anolancamento := pAnoLancamento;
  if not vCarroModelo.existecarromodelo(pErro) then
  begin
    if not vCarroModelo.carro.existecarro(pErro) then
      vCarroModelo.carro.inserircarro(pErro, vId);
    if pErro <> '' then
    begin
      vCarroModelo.Free;
    end;
    vCarroModelo.inserircarromodelo(pErro, vId);
    if pErro <> '' then
    begin
      vCarroModelo.Free;
    end;
    fListaCarroModelo.Add(vCarroModelo);
    Result := True;
  end;
end;

end.
