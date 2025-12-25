unit classe.venda;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections;

type

  TVendaItem = class
    private
      fid: Integer;
      fidvenda: Integer;
      fidmodelocarro: Integer;
      fquantidade: Integer;
    public
      property id: Integer read fid write fid;
      property idvenda: Integer read fidvenda write fidvenda;
      property idmodelocarro: Integer read fidmodelocarro write fidmodelocarro;
      property quantidade: Integer read fquantidade write fquantidade;
  end;

  TVenda = class
    private
      fid: Integer;
      fidcliente: Integer;
      fdatavenda: TDateTime;
      flistavendaitem: TObjectList<TVendaItem>;
    public
      constructor Create(pData: TDate);
      destructor Destroy; override;

      property id: Integer read fid write fid;
      property idcliente: Integer read fidcliente write fidcliente;
      property datavenda: TDateTime read fdatavenda write fdatavenda;
      property listavendaitem: TObjectList<TVendaItem> read flistavendaitem write flistavendaitem;
      function inserirvenda(out pErro: string): Boolean;
  end;

implementation

uses uDM, uLib;

{ TVenda }

constructor TVenda.Create(pData: TDate);
begin
  datavenda := pData;
  flistavendaitem := TObjectList<TVendaItem>.Create;
end;

destructor TVenda.Destroy;
begin
  flistavendaitem.Free;
  inherited;
end;

function TVenda.inserirvenda(out pErro: string): Boolean;
var
  vVendaItem: TVendaItem;
  vSql, vDataVenda: string;
  vId: Integer;
begin
  DM.ConectarDatabase;
  vDataVenda := Date_to_SQLDate(DateToStr(datavenda));

  DM.FDConnection.StartTransaction;

  vSql := 'INSERT INTO public.vendas(idcliente, datavenda) '
    + 'VALUES (:idcliente, :datavenda) RETURNING id';
  Result := DM.InserirDadosBD(vSql, [idcliente, datavenda], pErro, vId);

  if pErro <> '' then
  begin
    if DM.FDConnection.InTransaction then
      DM.FDConnection.Rollback;
    Exit;
  end;

  for vVendaItem in listavendaitem do
  begin
    vSql := 'INSERT INTO public.vendasitens(idvenda, idmodelocarro, quantidade) '
      + 'VALUES (:idvenda, :idmodelocarro, :quantidade) RETURNING id';
      Result := DM.InserirDadosBD(vSql, [vId, vVendaItem.idmodelocarro, vVendaItem.quantidade], pErro, vId);
    if pErro <> '' then
    begin
      if DM.FDConnection.InTransaction then
        DM.FDConnection.Rollback;
      Exit;
    end;
  end;

  if DM.FDConnection.InTransaction then
    DM.FDConnection.Commit;
end;



end.
