create database labBdAvaliacao01
go
use labBdAvaliacao01
go
create table Curso (
codCurso		int				not null,
nome			varchar(100)	not null,
cargaHoraria	int				not null,
sigla			varchar(3)		not null,
notaEnade		int				not null
Primary Key(codCurso)
)
go
create table Aluno (
cpf					char(11)		not null unique,
codCurso			int				not null,
ra					char(9)			not null,
nome				varchar(150)	not null,
nomeSocial			varchar(150)	null,
dataNascimento		date			not null,
email				varchar(100)	not null,
dataConclusao2Grau	date			not null,
emailCorporativo	varchar(100)	not null,
instituicao2Grau	varchar(100)	not null,
pontuacaoVestibular	int				not null,
posicaoVestibular	int				not null,
anoIngresso			int				not null,
semestreIngresso	int				not null,
semestreLimite		int				not null,
anoLimite			int				not null,
turno				varchar(10)		not null
Primary Key(cpf)
Foreign Key(codCurso) references Curso(codCurso)
)
go
create table Telefone (
numero		char(11)	not null,
cpf			char(11)	not null
Primary key(numero, cpf)
Foreign key(cpf) references Aluno(cpf)
)
go
create table Disciplina (
codDisciplina	int				not null,
codCurso		int				not null,
nome			varchar(100)	not null,
horasSemanais	int				not null,
horaInicio		time(7)			not null,
diaSemana		date			not null
Primary key(codDisciplina)
Foreign key(codCurso) references Curso(codCurso)
)
go
create table Matricula (
anoSemestre		int				not null,
cpf				char(11)		not null,
codDisciplina	int				not null,
statusMatricula	varchar(10)		not null,
nota			decimal(2,2)	null
Primary key(anoSemestre, cpf, codDisciplina)
Foreign key(cpf) references Aluno(cpf),
Foreign key(codDisciplina)	references Disciplina(codDisciplina)
)
go
create table Conteudo (
codConteudo		int				not null,
codDisciplina	int				not null,
nome			varchar(100)	not null
Primary key(codConteudo)
Foreign key(codDisciplina) references Disciplina(codDisciplina)
)


--PROCEDURE QUE VALIDA SE OCPF EXISTE OU � INVALIDO

create procedure sp_consultaCpf(@cpf char(11), @valido bit output)
as
--VARIAVEIS
	declare @i int, @valor int, @status int, @x int
--VALORES DAS VARIAVEIS
	set @i = 0
	set @status = 0
	set @x = 2

--verifica se cpf tem 11 digitos
if(LEN(@cpf) = 11)begin
	--VERIFICA��O DE DIGITOS REPETIDOS
	while(@i < 10) begin
		if(SUBSTRING(@cpf, 1,1) = SUBSTRING(@cpf, @x, 1)) begin
			set @status = @status + 1
		end 
	set @i = @i + 1
	set @x = @x + 1
	end
	--Descobrindo o digito 10
	If(@status < 10)begin
		declare @ValorMultiplicadoPor2 int
		set @valor = 10
		set @i = 0
		set @x = 1
		set @ValorMultiplicadoPor2 = 0
		
		while (@i < 9) begin
			set @ValorMultiplicadoPor2 = CAST(SUBSTRING(@cpf, @x, 1) as int) * @valor + @ValorMultiplicadoPor2  
			set @x = @x + 1
			set @i = @i + 1
			set @valor = @valor - 1
		end
		
		declare @valorDividido int, @primeiroDigito int 

		set @valorDividido = @ValorMultiplicadoPor2 % 11

		if(@valorDividido < 2)begin
			set @primeiroDigito = 0
		end else begin
			set @primeiroDigito = 11 - @valorDividido
		end

		-- verifica se o digito descoberto � igual o inserido

		if(CAST(SUBSTRING(@cpf, 10,1)as int) = @primeiroDigito) begin
			--descobrindo segundo digito
			set @valor = 11
			set @i = 0
			set @x = 1
			set @ValorMultiplicadoPor2 = 0

			while (@i < 10) begin
			set @ValorMultiplicadoPor2 =  CAST(SUBSTRING(@cpf, @x, 1) as int) * @valor + @ValorMultiplicadoPor2
			set @x = @x + 1
			set @i = @i + 1
			set @valor = @valor - 1
			end
			
			declare @segundoDigito int
			set @valorDividido = @ValorMultiplicadoPor2 % 11

			if(@valorDividido < 2)begin
				set @segundoDigito = 0
			end else begin
				set @segundoDigito = 11 - @valorDividido
			end

			if(CAST(SUBSTRING(@cpf, 11,1)as int) = @segundoDigito) begin
					set @valido  = 1
			end else begin
					set @valido  = 0
			end

		end else begin
			raiserror('CPF inexistente', 16, 1)
		end

	end else begin
		raiserror('CPF invalido, todos os digitos s�o iguais', 16, 1)
	end

end else begin
	raiserror('CPF invalido, n�mero de caracteres incorreto', 16, 1)
end


--PROCEDURE QUE VALIDA SE ALUNO TEM 16 ANOS OU MAIS

create procedure sp_validaIdade(@dataNascimento date, @validaIdade bit output)
as
	if(datediff(year, @dataNascimento, getdate()) >= 16)begin
		set @validaIdade = 1
	end
	else
	begin
		set @validaIdade = 0
	end

--PROCEDURE QUE CALCULA 5 ANSO DO ANO DE INGRESSSO

create function fn_anoLimite(@anoIngresso int)
returns int
as
begin
		declare @anoLimite int
		set @anolimite = @anoIngresso + 5
		return @anoLimite
end

-- Funcao para criacao de RA
create function fn_criaRa (@anoIngresso int, @semestreIngresso int, @rand1 int, @rand2 int, @rand3 int, @rand4 int)
returns char(9)
as
begin
    declare @ra char(9)

    set @ra = cast(@anoIngresso as char(4)) + cast(@semestreIngresso as char(1)) + cast(@rand1 as char(1)) + cast(@rand2 as char(1)) + cast(@rand3 as char(1)) + cast(@rand4 as char(1))
	
    return @ra
end

--FUCNTION QUE CRIA O EMAIL CORPORATIVO

create function fn_criaEmailCorporativo(@nome varchar(150), @ra char(9))
returns varchar (100)
as
begin

	set @nome = LOWER(@nome)
	set @nome = REPLAce(@nome, ' ', '.')

	set @nome = @nome + RIGHT(@ra, 4) + '@agis.com'
	return @nome
end

--PROCEDURE PARA INSERIR E ATUALIZAR ALUNO
-- drop procedure sp_iuAluno

create procedure sp_iuAluno(@op char(1), @cpf char(11), @codCurso int, @nome varchar(150), @nomeSocial varchar(150), @dataNascimento date, @email varchar(100), @dataConclusao2Grau date,
							@instituicao2Grau varchar(100), @pontuacaoVestibular int, @posicaoVestibular int, @anoIngresso int, @semestreIngresso int, @semestreLimite int, 
						    @telefone1 varchar(11),  @telefone2 varchar(11), @saida varchar(100) output)
as
		declare @validaCpf bit

		exec sp_consultaCpf @cpf, @validaCpf output 
		if(@validaCpf = 1)
		begin
				declare @validaIdade bit
				exec sp_validaIdade @dataNascimento, @validaIdade output
				if(@validaIdade = 1)
				begin
						if(upper(@op) = 'I')						
						begin
								declare @random1 int,
										@random2 int, 
										@random3 int, 
										@random4 int,
										@ra char(9),
										@emailCorporativo  varchar(100)

								set @random1 = CAST(RAND() * 10 as int)
								set @random2 = CAST(RAND() * 10 as int)
								set @random3 = CAST(RAND() * 10 as int)
								set @random4 = CAST(RAND() * 10 as int)

								set @ra = (SELECT dbo.fn_criaRa(2024, 1, @random1, @random2, @random3, @random4) as ra)

								set @emailCorporativo = (select dbo.fn_criaEmailCorporativo(@nome, @ra) as emailCorporativo)

								declare @anolimite int
								set @anoLimite = (select dbo.fn_anoLimite(@anoIngresso) as anoLimite)
								
								insert into Aluno values (@cpf, @codCurso, @ra, @nome, @nomeSocial, @dataNascimento, @email, @dataConclusao2Grau, @emailCorporativo, @instituicao2Grau,
														  @pontuacaoVestibular, @posicaoVestibular, @anoIngresso, @semestreIngresso, @semestreLimite, @anolimite, 'Vespertino')

								insert into Telefone (numero, cpf) values 
									(@telefone1, @cpf)
								
								if @telefone2 is not null
								begin 
									insert into Telefone (numero, cpf) values
										(@telefone2, @cpf)
								end

								set @saida = 'Aluno inserido com sucesso'
						end
						else
								if(upper(@op) = 'U')
								begin
									
									update Aluno
									set nome = @nome, email = @email, nomeSocial = @nomeSocial 
									where cpf = @cpf


									--Acho que esta errado
									update Telefone
									set numero = @telefone1
									where numero = numero and cpf = @cpf

									update Telefone
									set numero = @telefone2
									where numero = numero and cpf = @cpf
									
									set @saida = 'Aluno atualizado com sucesso'	
								end
								else
								begin
									raiserror('Opera��o inv�lida', 16, 1)
								end
				end
				else
				begin
						raiserror('Idade inv�lida, apenas alunos com 16 ou mais anos podem ser cadastrados', 16, 1)
				end
		end
		else
		begin
			raiserror('CPF Inv�lido, verifique e tente novamente.', 16, 1)
		end

								  


-- testes

-- Inser��es na tabela Curso
INSERT INTO Curso (codCurso, nome, cargaHoraria, sigla, notaEnade)
VALUES (1, 'Engenharia da Computa��o', 4000, 'ECO', 4),
       (2, 'Administra��o', 3200, 'ADM', 5),
       (3, 'Direito', 3600, 'DIR', 3),
       (4, 'Medicina', 6000, 'MED', 5),
       (5, 'Ci�ncia da Computa��o', 3800, 'CIC', 4);

-- Inser��es na tabela Aluno
INSERT INTO Aluno (cpf, codCurso, ra, nome, dataNascimento, email, dataConclusao2Grau, emailCorporativo, instituicao2Grau, pontuacaoVestibular, posicaoVestibular, anoIngresso, semestreIngresso, semestreLimite, anoLimite, turno)
VALUES ('12345678901', 1, 'RA123456', 'Jo�o da Silva', '1995-03-15', 'joao@gmail.com', '2013-12-31', 'joao@empresa.com', 'Escola X', 700, 50, 2020, 1, 10, 2025, 'Manh�'),
       ('98765432109', 2, 'RA987654', 'Maria Oliveira', '1998-07-20', 'maria@gmail.com', '2016-06-30', 'maria@empresa.com', 'Escola Y', 720, 40, 2019, 2, 9, 2024, 'Tarde'),
       ('55555555555', 3, 'RA555555', 'Ana Souza', '2000-10-05', 'ana@gmail.com', '2018-12-31', 'ana@empresa.com', 'Escola Z', 680, 60, 2022, 1, 8, 2027, 'Noite'),
       ('11111111111', 4, 'RA111111', 'Pedro Santos', '1997-09-25', 'pedro@gmail.com', '2015-07-31', 'pedro@empresa.com', 'Escola W', 740, 30, 2017, 2, 9, 2022, 'Tarde'),
       ('99999999999', 5, 'RA999999', 'Juliana Lima', '1996-12-10', 'juliana@gmail.com', '2014-12-31', 'juliana@empresa.com', 'Escola V', 710, 45, 2015, 1, 8, 2020, 'Manh�');

-- Inser��es na tabela Telefone
INSERT INTO Telefone (numero, cpf)
VALUES ('12345678901', '12345678901'),
       ('98765432109', '98765432109'),
       ('11122233344', '12345678901'),
       ('55566677788', '98765432109'),
       ('99988877766', '55555555555');


select * from Aluno where cpf = '41707740860'
delete Aluno where cpf = '41707740860'

select a.nome, t.numero
from Aluno a, Telefone t
where a.cpf = t.cpf and a.cpf = '41707740860'

select * from Telefone
delete Telefone where cpf = '41707740860'
--
declare @saidaa varchar(100)
exec sp_iuAluno 'I', '41707740860', 5, 'Guilherme Silveira', null,'28-01-2004', 'gui@gmail.com', '01-12-2023', 'Camargo Aranha', 100, 1, 2024, 1, 1, '11948574785',
				/*null*/'11985693254', @saidaa output
print @saidaa

insert into Aluno values ('41707740860', 5, '202415287', 'Guilherme Silveira', null,'28-01-2004', 'gui@gmail.com', '01-12-2023', 'guilherme.silveira5287@agis.com', 'Camargo Aranha', 100, 1, 2024, 1, 1, 2029, 'Vespertino')

-- Teste Funcao fn_criaRA
declare @random1 int, @random2 int, @random3 int, @random4 int

set @random1 = CAST(RAND() * 10 as int)
set @random2 = CAST(RAND() * 10 as int)
set @random3 = CAST(RAND() * 10 as int)
set @random4 = CAST(RAND() * 10 as int)

SELECT dbo.fn_criaRa(2024, 1, @random1, @random2, @random3, @random4) AS RA

select dbo.fn_criaEmailCorporativo('Gustavo da Cruz santos', '202411234') as emailCorp
