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
  classe.carromodelo,
  classe.venda;

type
  TExecutadora = class
    public
    fListaCliente: TObjectList<TCliente>;
    fListaCarroModelo: TObjectList<TCarroModelo>;

    constructor Create;
    destructor Destroy; override;

    function Insere5Clientes: Boolean;
    function Insere5ModelosCarros: Boolean;
    function Insere5Vendas: Boolean;
    function InsereCliente(pNomeCliente, pCpf: string;
      out pErro: String): Boolean;
    function InsereModeloCarro(pDescricaoCarro, pDescricaoModelo: string;
      pAnoLancamento: Integer; out pErro: String): Boolean;
    function InsereVenda(pCliente: TCliente; pCarroModelo: TCarroModelo;
      out pErro: String): Boolean;
  end;

implementation

{ TExecutadora }

constructor TExecutadora.Create;
begin
  fListaCliente := TObjectList<TCliente>.Create;
  fListaCarroModelo := TObjectList<TCarroModelo>.Create;
end;

destructor TExecutadora.Destroy;
begin
  fListaCliente.Free;
  fListaCarroModelo.Free;
  inherited;
end;

function TExecutadora.Insere5Clientes: Boolean;
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

function TExecutadora.Insere5ModelosCarros: Boolean;
var
  vCarro: TCarro;
  vCarroModelo: TCarroModelo;
  vErro: string;
//  vId: Integer;
begin
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


function TExecutadora.Insere5Vendas: Boolean;
var
  I: Integer;
  vErro: string;
begin
  for I := 0 to 4 do
  begin
    if not InsereVenda(fListaCliente[i], fListaCarroModelo[i], vErro) then
      raise Exception.Create('Erro na inclusão de modelo carro: '+ vErro);
  end;
end;

function TExecutadora.InsereCliente(pNomeCliente, pCpf: string;
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
end;

function TExecutadora.InsereModeloCarro(pDescricaoCarro, pDescricaoModelo: string;
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

function TExecutadora.InsereVenda(pCliente: TCliente; pCarroModelo: TCarroModelo;
  out pErro: String): Boolean;
var
  vVenda: TVenda;
  vVendaItem: TVendaItem;
  vId: Integer;
begin
  Result := False;
  vVenda := TVenda.Create(Now);
  vVenda.idcliente := pCliente.id;

  vVendaItem := TVendaItem.Create;
  vVendaItem.idmodelocarro := pCarroModelo.id;
  vVendaItem.quantidade := 1;
  vVenda.listavendaitem.Add(vVendaItem);
  vVenda.inserirvenda(pErro);
  if pErro <> '' then
    Exit;
  Result := True;
end;


end.
