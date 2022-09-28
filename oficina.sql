CREATE database OFICINA;
USE OFICINA;

-- percistindo os dados
show databases;
desc carro;
select*from Cliente;
select*from MaoDeObra;
select*from OS;
select*from PecasValor , OS;


select distinct * from Cliente c,Carro ca,Mecanico m,MecanicoReparo mr,Reparo r, OS os, PecasValor pv
where c.idCliente = ca.idCliente and ca.idCarro = m.idMecanico and m.idMecanico = mr.id_meca_rl and os.idPecas = pv.idPecas; -- r.idReparo = mr.id_repar_rl; idOs

select concat(c.nome,' ',sobrenome) as nome_completo, c.telefone, ca.modelo, ca.cor, m.nome,r.gravidade,r.previsao,os.valor,pv.descrição
from Cliente c,Carro ca,Mecanico m,MecanicoReparo mr,Reparo r,OS os, PecasValor pv
where c.idCliente = ca.idCliente and ca.idCarro = m.idMecanico and m.idMecanico = mr.id_meca_rl and r.idReparo = mr.id_repar_rl and os.idPecas = pv.idPecas;

-- VEICULO
select*from Carro;
drop table Carro;
Create table Carro(
	idCarro int auto_increment primary key,
    placa varchar(7) not null,
    idCliente int not null,
    cor varchar(10),
    modelo varchar(15),
    constraint fk_carroClient foreign key(idCliente) references Cliente(idCliente)
);
alter table Carro add constraint fk_carroClient foreign key(idCliente) references Cliente(idCliente);
insert into Carro(placa,idCliente,cor,modelo)
	values('cpr4989',1,'vermelho','Maverik'),
		  ('bwd5959',2,'preto','Mustangue'),
          ('bol2200',3,'branco','i320');


alter table Carro auto_increment=1;
-- CLIENTE

Create table Cliente(
	idCliente int auto_increment primary key,
    nome varchar (10),
    sobrenome varchar(15),
    endereço varchar (11),
    telefone smallint,
    whatapp enum('Possui','Não Possui')
);

insert into Cliente(nome,sobrenome,endereço,telefone,whatapp)
	values('João','Borgews','rua dos acabados','1999696554','Não Possui'),
		  ('Hadassa','Gallani','rua dos corruptos','2199696654','Possui'),
          ('Gerson','Gallani','rua dos presidentes','1899696444','Possui');

alter table Carro auto_increment=1;

-- MECANICO
desc Mecanico;
select count(*) from Mecanico;
select * from Mecanico;
Create table Mecanico(
	idMecanico int auto_increment primary key,
    especialidade varchar(10) not null,
    nome varchar(20),
    endereço varchar(30)
);
alter table Mecanico change avalia nome varchar(20);
insert into Mecanico(especialidade,nome,endereço)
values('motores','biela torta',null),
	  ('cambio','tião',null),
      ('injeção','ze loco',null);
alter table Mecanico auto_increment=1;
-- ORDEM DE SERVIÇO

CREATE table OS(
	idOs int auto_increment primary key,
    dataEmissao datetime,
    dataEntrega datetime,
    idPecas int,
    idTabelaMao int,
    valor float
    
);
alter table OS add constraint fk_pecas foreign key(idPecas) references PecasValor(idPecas);
alter table OS add constraint fk_mao foreign key(idTabelaMao) references MaoDeObra(idTabelaMao);

insert into OS (dataEmissao,dataEntrega,idPecas,idMaoObra,valor)
values('2017-09-27 12:00:00','2017-09-28 12:00:00',3,3,15000.00);
alter table OS auto_increment=1;
-- TABELA DE MÃO DE OBRA DOS MECANICOS

Create table MaoDeObra(
	idTabelaMao int auto_increment primary key,
    valorServiço float not null,
    categoria enum('Motor','Cambio','Revisao','Perifericos')
);
insert into MaoDeObra (valorServiço,categoria)
values(5025.78,'Perifericos'),
		(1025.10,'Revisao'),
        (10005.25,'Motor');
alter table MaoDeObra auto_increment =1;
-- TABELA DE PREÇOS DAS PEÇAS

Create table PecasValor(
	idPecas int auto_increment primary key,
    valor float,
    descrição varchar(30)
);

insert into PecasValor (valor,descrição)
values(7025.78,'kit suspensão e pneus'),
		(3025.10,'Fluidos'),
        (14005.25,'Turbina');
alter table PecasValor auto_increment =1;
-- revisão

Create table Revisao(
	idRevisao int auto_increment primary key,
    periodica enum('Sim','Não'),
    TipoRevisao enum('Básica','Completa')
);
insert into Revisao(periodia,TipoRevisao)
values('Sim','Completa'),
       ('Não','Básica'),
       ('Não','Completa');
alter table Revisao auto_increment =1;

-- REPARO
select*from Reparo;
Create table Reparo(
	idReparo int auto_increment primary key ,
    gravidade varchar(30),
    previsao enum('rápido','Demorado','Complexo','Indefinido' )
	);
insert into Reparo (gravidade,previsao)
values('Gravissimo,troca de motor','Complexo'),
	   ('Simples','Rapido');
    
-- CRIANDO RELACIONAMENTO

-- MECANICO REPARO(DIAGNOSTICO)

create table MecanicoReparo(
	id_meca_rl int ,
    id_repar_rl int,
    constraint pk_composta primary key(id_meca_rl,id_repar_rl),
    constraint fk_relacaoMecanico foreign key(id_meca_rl) references Mecanico (idMecanico),
    constraint fk_relacaoReparo foreign key(id_repar_rl) references Reparo (idReparo)
);
insert into MecanicoReparo (id_meca_rl,id_repar_rl)
values (4,1),
       (5,2);
-- RELAÇÃO MECANICO REVISÃO

create table MecanicoRevisao(
	id_mecaR_rl int,
    id_revi_rl int,
    constraint pk_compostaRevis primary key(id_mecaR_rl,id_revi_rl),
    constraint fk_mecanicoRevisao foreign key(id_mecaR_rl) references Mecanico (idMecanico),
    constraint fk_relacaoRevisao foreign key(id_revi_rl) references Revisao (idRevisao)
);

-- RELAÇÃO MECANICO OS
create table MecanicoOS(
	id_mecaOS_rl int,
    id_OS_rl int,
    constraint pk_compostaRevis primary key(id_mecaOS_rl,id_OS_rl),
    constraint fk_mecanicoOS foreign key(id_mecaOS_rl) references Mecanico (idMecanico),
    constraint fk_relacaoOS foreign key(id_OS_rl) references OS (idOs)
);


-- RELAÇÃO ORDEM DE SERVIÇO CLIENTE 

create table ClienteOS(
	id_clientOS_rl int,
    id_Orden_rl int,
    constraint pk_compostaRevis primary key(id_clientOS_rl,id_Orden_rl),
    constraint fk_clienteOS foreign key(id_clientOS_rl) references Cliente (idCliente),
    constraint fk_ordemRelaOS foreign key(id_Orden_rl) references OS (idOs)
);



-- RELAÇÃO CARRO  REVISÃO

create table CarroRevisa(
	id_carroRevi_rl int,
    id_reviCar_rl int,
    id_carCli_rl int,
    constraint pk_compostaRevis primary key(id_carroRevi_rl,id_reviCar_rl,id_carCli_rl),
    constraint fk_carroRevi foreign key(id_carroRevi_rl) references Cliente (idCliente),
    constraint fk_carroCli foreign key(id_carCli_rl) references Carro (idCarro),
    constraint fk_reviCar foreign key(id_reviCar_rl) references Revisao (idRevisao)
);


-- RELAÇÃO CARRO REPARO

create table CarroRePar(
	id_carroRepar_rl int,
    id_reparCar_rl int,
    id_carCli_rl int,
    constraint pk_compostaRevis primary key(id_carroRepar_rl,id_reparCar_rl,id_carCli_rl),
    constraint fk_carroRepar foreign key(id_carroRepar_rl) references Cliente (idCliente),
    constraint fk_carroCliRepar foreign key(id_carCli_rl) references Carro (idCarro),
    constraint id_reparCar_rl foreign key(id_reparCar_rl) references Reparo (idReparo)
);
insert into CarroRePar (id_carroRepar_rl,id_reparCar_rl,id_carCli_rl)
values(1,1,6);


