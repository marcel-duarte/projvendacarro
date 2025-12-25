-- SCRIPT TESTE QUESTOR --
-- IMPORTANTE: 
-- 1 - rodar a primeira parte no query tool apontdo pra qq banco (pg admin) 
-- 2 - atualizar o postgres (refresh)
-- 3 - abrir novo query tool no banco criado
-- 4 - rodar a segunda parte


-- primeira parte - cria o banco --
CREATE DATABASE testequestor2
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- segunda parte - cria tabelas --
DROP TABLE IF EXISTS public.sorteio;
DROP TABLE IF EXISTS public.vendasitens;
DROP TABLE IF EXISTS public.vendas;
DROP TABLE IF EXISTS public.carromodelo;
DROP TABLE IF EXISTS public.carro;
DROP TABLE IF EXISTS public.cliente;


CREATE TABLE IF NOT EXISTS public.carro (
    id SERIAL PRIMARY KEY,
    descricaocarro character varying(100) NOT NULL
);

--

CREATE TABLE IF NOT EXISTS public.carromodelo
(
    id SERIAL PRIMARY KEY,
    idcarro integer NOT NULL,
    descricaomodelo character varying(100) COLLATE pg_catalog."default" NOT NULL,
    anolancamento integer NOT NULL,
    CONSTRAINT fk_carromodelo_carro FOREIGN KEY (idcarro)
        REFERENCES public.carro (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

--

CREATE TABLE IF NOT EXISTS public.cliente
(
    id SERIAL PRIMARY KEY,
    nomecliente character varying(100) COLLATE pg_catalog."default",
    cpf character varying(11) COLLATE pg_catalog."default"
);


--

CREATE TABLE IF NOT EXISTS public.vendas
(
    id SERIAL PRIMARY KEY,
    idcliente integer NOT NULL,
    datavenda date NOT NULL,
    CONSTRAINT fk_vendas_cliente FOREIGN KEY (idcliente)
        REFERENCES public.cliente (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

--

CREATE TABLE IF NOT EXISTS public.vendasitens
(
    id SERIAL PRIMARY KEY,
    idvenda integer NOT NULL,
    idmodelocarro integer NOT NULL,
    quantidade integer NOT NULL,
    CONSTRAINT fk_vendaitens_modelocarro FOREIGN KEY (idmodelocarro)
        REFERENCES public.carromodelo (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_vendasitens_vendas FOREIGN KEY (idvenda)
        REFERENCES public.vendas (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

--

CREATE TABLE IF NOT EXISTS public.sorteio
(
    id SERIAL PRIMARY KEY,
    datasorteio date NOT NULL,
    idcliente integer NOT NULL,
    idvenda integer NOT NULL,
    CONSTRAINT fk_sorteio_cliente FOREIGN KEY (idcliente)
        REFERENCES public.cliente (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_sorteio_venda FOREIGN KEY (idvenda)
        REFERENCES public.vendas (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);
