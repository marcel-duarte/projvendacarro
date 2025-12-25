-- SCRIPTS SOLICITADOS NO TESTE --

-- *** QUANTIDADE DE VENDAS DO MAREA ***
select sum(vi.quantidade) quantidade
from vendas v
inner join vendasitens vi on vi.idvenda = v.id
inner join carromodelo cm on cm.id = vi.idmodelocarro
inner join carro cr on cr.id = cm.idcarro
where cr.descricaocarro like '%MAREA%';

-- *** QUANTIDADE DE VENDAS COM UNO ***
select sum(vi.quantidade) quantidade
from vendas v
inner join vendasitens vi on vi.idvenda = v.id
inner join carromodelo cm on cm.id = vi.idmodelocarro
inner join carro cr on cr.id = cm.idcarro
where cr.descricaocarro like '%UNO%';


-- *** QTDE DE CLIENTES QUE NAO EFETUARAM VENDAS ***
select count(c.id)
from cliente c
left join vendas v on v.idcliente = c.id
where v.id is null;


-- *** CLIENTES SORTEADOS ***
select v.id, v.datavenda, c.id, c.nomecliente, sum(vi.quantidade)
from vendas v
inner join cliente c on c.id = v.idcliente
inner join vendasitens vi on vi.idvenda = v.id
inner join carromodelo cm on cm.id = vi.idmodelocarro
inner join carro cr on cr.id = cm.idcarro
where cr.descricaocarro like '%MAREA%' and left(c.cpf,1) = '0' 
group by v.id, v.datavenda, c.id, c.nomecliente
having sum(vi.quantidade) = 1
order by v.datavenda
limit 15;


-- *** EXCLUIR NAO SORTEADOS ***
-- vendas itens
with vendasparamanter as (
    select v.id
    from vendas v
    inner join cliente c on c.id = v.idcliente
    inner join vendasitens vi on vi.idvenda = v.id
    inner join carromodelo cm on cm.id = vi.idmodelocarro
    inner join carro cr on cr.id = cm.idcarro
    where cr.descricaocarro like '%MAREA%' and left(c.cpf, 1) = '0'
    group by v.id, v.datavenda, c.id, c.nomecliente
    having sum(vi.quantidade) = 1
    order by v.datavenda
    limit 15
)
delete from vendasitens vi
where not exists (
    select 1
    from vendasparamanter vm
    where vm.id = vi.id
);

-- vendas
delete from vendas v where not exists(select 1 from vendasitens vi where vi.idvenda = v.id);
