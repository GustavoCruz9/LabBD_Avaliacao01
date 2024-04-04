-- use master
--	 drop database labBdAvaliacao01

create database labBdAvaliacao01
go
use labBdAvaliacao01
go
create table Curso (
codCurso		int				not null check(codCurso >= 0 and codCurso <= 100),
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
dataConclusao2Grau	date			not null ,
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
constraint verificaDataConclusao check (dataConclusao2Grau > dataNascimento)
)
go
create table Telefone (
numero		char(11)	not null,
cpf			char(11)	not null
Primary key(numero, cpf)
Foreign key(cpf) references Aluno(cpf)
)
go

/*
drop table Disciplina
drop table matricula
drop table conteudo
*/

create table Disciplina (
codDisciplina	int				not null /*identity(1001, 1)*/,
codCurso		int				not null,
nome			varchar(100)	not null,
horasSemanais	time			not null,
horaInicio		time			not null,
horaFinal as dbo.calcularHoraFinal(HoraInicio, HorasSemanais),
diaSemana		varchar(15)		not null
Primary key(codDisciplina)
Foreign key(codCurso) references Curso(codCurso)
)
go
create table Matricula (
anoSemestre		int				not null,
cpf				char(11)		not null,
codDisciplina	int				not null,
statusMatricula	varchar(10)		not null default ('pendente'),
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
go
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
go
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
go
create function fn_anoLimite(@anoIngresso int)
returns int
as
begin
		declare @anoLimite int
		set @anolimite = @anoIngresso + 5
		return @anoLimite
end

-- Funcao para criacao de RA
--drop function fn_criaRa
go
create function fn_criaRa (@anoIngresso int, @semestreIngresso int, @random1 int, @random2 int, @random3 int, @random4 int)
returns @tabela table (
	statusRa	 bit,
	ra			char(9)
)
begin

    declare @ra char(9),
			@raExistente char(9)

	set @raExistente = null

	set @ra = cast(@anoIngresso as char(4)) + cast(@semestreIngresso as char(1)) + cast(@random1 as char(1)) + cast(@random2 as char(1)) + cast(@random3 as char(1)) + cast(@random4 as char(1))	

	set @raExistente = (select ra from Aluno where ra = @ra)

	if(@raExistente is null)
	begin
			insert into @tabela (statusRa, ra) values (1, @ra)
	end
	else
	begin
			insert into @tabela (statusRa, ra) values (0, @ra)
	end
	
    return 
end

--FUCNTION QUE CRIA O EMAIL CORPORATIVO
go
create function fn_criaEmailCorporativo(@nome varchar(150), @ra char(9))
returns varchar (100)
as
begin

	set @nome = LOWER(@nome)
	set @nome = REPLAce(@nome, ' ', '.')

	set @nome = @nome + RIGHT(@ra, 4) + '@agis.com'
	return @nome
end

--PROCEDURE QUE VALIDA SE CPF � UNICO NO BANCO DE DADOS DO SISTEMA
go
create procedure sp_validaCpfDuplicado(@cpf char(11), @validaCpfDuplicado bit output)
as
	declare @cpfExistente char(11)

	set @cpfExistente = null

	set @cpfExistente = (select cpf from aluno where cpf = @cpf)

	if(@cpfExistente is null)
	begin
		set @validaCpfDuplicado = 1
	end
	else
	begin
		set @validaCpfDuplicado = 0
	end

--PROCEDURE PARA INSERIR E ATUALIZAR ALUNO
-- drop procedure sp_iuAluno
go
create procedure sp_iuAluno(@op char(1), @cpf char(11), @codCurso int, @nome varchar(150), @nomeSocial varchar(150), @dataNascimento date, @email varchar(100), @dataConclusao2Grau date,
							@instituicao2Grau varchar(100), @pontuacaoVestibular int, @posicaoVestibular int, @anoIngresso int, @semestreIngresso int, @semestreLimite int, 
							@saida varchar(100) output)
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

								declare @validarDuplicidadeCpf bit
								exec sp_validaCpfDuplicado @cpf, @validarDuplicidadeCpf output
								if(@validarDuplicidadeCpf = 1)
								begin
											declare	@ra char(9),
													@emailCorporativo varchar(100),
													@random1 int,
													@random2 int, 
													@random3 int, 
													@random4 int,
													@status bit

											set @status = 0

											while(@status = 0)begin
									
												set @random1 = CAST(RAND() * 10 as int)
												set @random2 = CAST(RAND() * 10 as int)
												set @random3 = CAST(RAND() * 10 as int)
												set @random4 = CAST(RAND() * 10 as int)

												set @status = (select statusRa from fn_criaRa(2024, 1, @random1, @random2, @random3, @random4))
								
											end

											set @ra = (select ra from fn_criaRa(2024, 1, @random1, @random2, @random3, @random4))
								

											set @emailCorporativo = (select dbo.fn_criaEmailCorporativo(@nome, @ra) as emailCorporativo)

											declare @anolimite int
											set @anoLimite = (select dbo.fn_anoLimite(@anoIngresso) as anoLimite)
								
											insert into Aluno values (@cpf, @codCurso, @ra, @nome, @nomeSocial, @dataNascimento, @email, @dataConclusao2Grau, @emailCorporativo, @instituicao2Grau,
																 @pontuacaoVestibular, @posicaoVestibular, @anoIngresso, @semestreIngresso, @semestreLimite, @anolimite, 'Vespertino')

											
											set @saida = 'Aluno inserido com sucesso'
								end
								else
								begin
											raiserror('CPF já cadastrado', 16, 1)
								end
						end
						else
							if(upper(@op) = 'U')
							begin
									
									update Aluno
									set nome = @nome, dataNascimento = @dataNascimento, nomeSocial = @nomeSocial, email = @email, codCurso = @codCurso, dataConclusao2Grau = @dataConclusao2Grau, 
									instituicao2Grau = @instituicao2Grau, pontuacaoVestibular = @pontuacaoVestibular, posicaoVestibular = @posicaoVestibular
									where cpf = @cpf

										
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
			raiserror('CPF Inválido, verifique e tente novamente.', 16, 1)
		end

--Procedure sp_iudTelefone	
-- drop procedure sp_iudTelefone
create procedure sp_iudTelefone(@op char(1), @cpf char(11), @telefoneAntigo char(11) null, @telefoneNovo char(11), 
								@saida  varchar(150) output)
as
		declare @validarExistenciaCpf bit
		exec sp_validaCpfDuplicado @cpf, @validarExistenciaCpf output

		if(@validarExistenciaCpf = 0) 
		begin
				if(len(@telefoneNovo) = 11)
				begin
						if(upper(@op) = 'U')
						begin
								if(len(@telefoneAntigo) = 11)
								begin

									update Telefone set numero = @telefoneNovo where cpf = @cpf and numero = @telefoneAntigo

									set @saida = 'Telefone atualizado com sucesso'

								end
								else
								begin
									raiserror('Tamanho de telefone incorreto', 16, 1)
								end
						end
						else
								if(upper(@op) = 'D')
								begin
										begin try

											delete Telefone where cpf = @cpf and numero = @telefoneNovo

											set @saida = 'Telefone excluido com sucesso'

										end try
										begin catch
												raiserror('Telefone inexistente ou invalidado', 16, 1)
										end catch
								end
								else
										if(upper(@op) = 'I')
										begin
												insert into Telefone (cpf, numero) values (@cpf, @telefoneNovo)

												set @saida = 'Telefone cadastrado com sucesso'
										end
										else
										begin
												raiserror('Operação inválida', 16, 1)
										end
				end 
				else
				begin
					raiserror('Tamanho de telefone incorreto', 16, 1)
				end
		end
		else
		begin
				raiserror('O CPF não existe na base de dados do sistema', 16, 1)
		end

--FUNCTION FN_POPULARMATRICULA
--drop function fn_popularMatricula
create function fn_popularMatricula(@ra char(9))
returns @tabela table (
	diaSemana	varchar(15),
	codDisciplina	int,
	disciplina	varchar(100),
	horasSemanais	time,
	horaInicio		time,
	statusMatricula	varchar(20)
)
begin
	
		declare @codCurso int

		set @codCurso = (select codCurso from Aluno where ra = @ra)

		insert into @tabela (diaSemana, codDisciplina, disciplina, horasSemanais, horaInicio, statusMatricula)
					select d.diaSemana, d.codDisciplina, d.nome, d.horasSemanais, convert(varchar(5), d.horaInicio, 108) as horaInicio, 'não matriculado' as statusMatricula
					from Disciplina d left outer join Matricula m on d.codDisciplina = m.codDisciplina
					where m.cpf is null and d.codCurso = @codCurso
	
		insert into @tabela (diaSemana, codDisciplina, disciplina, horasSemanais, horaInicio, statusMatricula)
					select d.diaSemana, d.codDisciplina, d.nome, d.horasSemanais, convert(varchar(5), d.horaInicio, 108) as horaInicio , m.statusMatricula
					from Disciplina d, Matricula m
					left join Matricula m1 on m1.cpf = m.cpf
							  and m1.codDisciplina = m.codDisciplina
							  and m1.anoSemestre > m.anoSemestre
							  and m1.statusMatricula = 'Aprovado'
					where d.codCurso = @codCurso and
						  m.statusMatricula = 'Reprovado'
						  and m1.anoSemestre is null and 
						  d.codDisciplina = m.codDisciplina

		return
end	

-- Drop function calcularHoraFinal
-- FUNCTION CalcularHoraFinal 
create function calcularHoraFinal (@horaInicio time, @horasSemanais time)
returns time
as
begin
    declare @horaFinal time;
    declare @horas int;
    declare @minutos int;

    set @horas = datepart(hour, @horasSemanais);

    set @minutos = datepart(minute, @horasSemanais);

    set @horaFinal = dateadd(hour, @horas, @horaInicio);
    set @horaFinal = dateadd(minute, @minutos, @horaFinal);

    return @horaFinal
end


-- PROCEDURE sp_cadastrarMatricula
-- drop procedure sp_cadastrarMatricula

select * from Matricula
select * from Disciplina

create procedure sp_cadastrarMatricula(@ra char(9), @codDisciplinaRequerida int, @saida varchar(150) output)
as
		declare @codCurso int,
				@diaSemana varchar(15),
				@disciplinaRequerida time,
				@disciplinaMatriculada time,
				@cpf char(11)

		set @cpf = (select cpf from Aluno where ra = @ra)

		set @codCurso = (select codCurso from Aluno where ra = @ra)

		set @diaSemana = (select diaSemana from Disciplina where codDisciplina = @codDisciplinaRequerida)

		declare @horaInicioDisciplinaRequerida time,
				@horaInicioDisciplinaMatriculada time,
				@horaFinalDisciplinaMatriculada time,
				@horaFinalDisciplinaRequerida time,
				@qtdMatricula int

		set @horaInicioDisciplinaRequerida =  (select horaInicio 
									from Disciplina 
									where diaSemana =  @diaSemana
									and codCurso = @codCurso 
									and codDisciplina = @codDisciplinaRequerida)

		set @horaFinalDisciplinaRequerida = (select horaFinal 
									from Disciplina 
									where diaSemana = @diaSemana 
									and codCurso = @codCurso 
									and codDisciplina = @codDisciplinaRequerida)

		set @qtdMatricula = (select count(*) from matricula m, Disciplina d 
							 where lower(m.statusMatricula) = lower('Pendente') 
							 and m.codDisciplina = d.codDisciplina and
							 d.codCurso = @codCurso and d.diaSemana = @diaSemana)

		while(@qtdMatricula > 0)
		begin
				
				declare @top int,
						@codDisciplinaMatriculada int

				set @top = @qtdMatricula

				set @codDisciplinaMatriculada = (select top (@top) d.codDisciplina from matricula m, Disciplina d 
											  where lower(m.statusMatricula) = lower('Pendente') 
											  and m.codDisciplina = d.codDisciplina and
											  d.codCurso = @codCurso and d.diaSemana = @diaSemana)


				set @horaInicioDisciplinaMatriculada = (select d.horaInicio 
											  from matricula m, Disciplina d 
											  where lower(m.statusMatricula) = lower('Pendente') 
											  and m.codDisciplina = d.codDisciplina and
											  d.codCurso = @codCurso and d.diaSemana = @diaSemana
											  and d.codDisciplina = @codDisciplinaMatriculada)

				set @horaFinalDisciplinaMatriculada = (select d.horaFinal 
											  from matricula m, Disciplina d 
											  where lower(m.statusMatricula) = lower('Pendente') 
											  and m.codDisciplina = d.codDisciplina and
											  d.codCurso = @codCurso and d.diaSemana = @diaSemana
											  and d.codDisciplina = @codDisciplinaMatriculada)

		
				if(@horaInicioDisciplinaRequerida != @horaInicioDisciplinaMatriculada) 
				begin
							if((@horaInicioDisciplinaRequerida not between @horaInicioDisciplinaMatriculada and @horaFinalDisciplinaMatriculada)
								and 
								(@horaFinalDisciplinaRequerida not between @horaInicioDisciplinaMatriculada and @horaFinalDisciplinaMatriculada))
							begin
									print 'entrou'
									declare @anoSemestre varchar(5)

									set @anoSemestre = dbo.fn_obterAnoSemestre()

									insert into Matricula (anoSemestre, cpf, codDisciplina) values
									(@anoSemestre, @cpf, @codDisciplinaRequerida)

									set @saida = 'Matricula realizada com sucesso'

							end
							else
							begin
								raiserror ('Já existe um materia cadastrada nesse intervalo de horario 2', 16, 1)
							end		
				end
				else
				begin
						raiserror('Já existe um materia cadastrada nesse intervalo de horario', 16, 1)
				end

				set @qtdMatricula = @qtdMatricula - 1
		end



-- FUNCTION PARA OBTER ANOSEMESTRE
-- drop function fn_obterAnoSemestre
create function fn_obterAnoSemestre ()
returns varchar(5)
begin
		declare @anoSemestre varchar(5),
				@ano int,
				@mes int;

		
		set @ano = year(getdate())
		set @mes = month(getdate())


		if @mes >= 1 and @mes <= 6
			set @anoSemestre = cast(@ano as varchar(4)) + '1'
		else
			set @anoSemestre = cast(@ano as varchar(4)) + '2'

		return @anoSemestre
				
end


	  
-- TESTES -- -- TESTES -- -- TESTES -- -- TESTES -- -- TESTES -- -- TESTES -- -- TESTES -- -- TESTES ---- TESTES ---- TESTES -- -- TESTES --

declare @saida varchar(150)
exec sp_cadastrarMatricula '202416328', 1001, @saida output
print @saida

declare @resultado varchar(5);
set @resultado = dbo.fn_obterAnoSemestre();
print @resultado;

declare @top int
set @top = 1
select top (@top) d.codDisciplina from matricula m, Disciplina d 
											  where lower(m.statusMatricula) = lower('Pendente') 
											  and m.codDisciplina = d.codDisciplina and
											  d.codCurso = 1 and d.diaSemana = 'Segunda-feira'

select diaSemana, codDisciplina, disciplina, horasSemanais, convert(varchar(5), horaInicio, 108) as horaInicio, statusMatricula
 from fn_realizaMatricula('202416328')
 order by diaSemana, horaInicio

 select diaSemana, codDisciplina, disciplina, horasSemanais,
				horaInicio, statusMatricula
				from fn_realizaMatricula( '202416328' )


-- Inser��es na tabela Curso

INSERT INTO Curso (codCurso, nome, cargaHoraria, sigla, notaEnade)
VALUES (1, 'Engenharia da Computa��o', 4000, 'ECO', 4),
       (2, 'Administra��o', 3200, 'ADM', 5),
       (3, 'Direito', 3600, 'DIR', 3),
       (4, 'Medicina', 6000, 'MED', 5),
       (5, 'Ci�ncia da Computa��o', 3800, 'CIC', 4);

-- Inser��es na tabela Aluno
INSERT INTO Aluno (cpf, codCurso, ra, nome, dataNascimento, email, dataConclusao2Grau, emailCorporativo, instituicao2Grau, pontuacaoVestibular, posicaoVestibular, anoIngresso, semestreIngresso, semestreLimite, anoLimite, turno)
VALUES ('12345678901', 1, 'RA123456', 'Jo�o da Silva', '1995-03-15', 'joao@gmail.com', '2013-12-31', 'joao@empresa.com', 'Escola X', 700, 50, 2020, 1, 1, 2025, 'Manh�'),
       ('98765432109', 2, 'RA987654', 'Maria Oliveira', '1998-07-20', 'maria@gmail.com', '2016-06-30', 'maria@empresa.com', 'Escola Y', 720, 40, 2019, 2, 2, 2024, 'Tarde'),
       ('55555555555', 3, 'RA555555', 'Ana Souza', '2000-10-05', 'ana@gmail.com', '2018-12-31', 'ana@empresa.com', 'Escola Z', 680, 60, 2022, 1, 2, 2027, 'Noite'),
       ('11111111111', 4, 'RA111111', 'Pedro Santos', '1997-09-25', 'pedro@gmail.com', '2015-07-31', 'pedro@empresa.com', 'Escola W', 740, 30, 2017, 2, 2, 2022, 'Tarde'),
       ('99999999999', 5, 'RA999999', 'Juliana Lima', '1996-12-10', 'juliana@gmail.com', '2014-12-31', 'juliana@empresa.com', 'Escola V', 710, 45, 2015, 1, 1, 2020, 'Manh�');

-- Inser��es na tabela Telefone
INSERT INTO Telefone (numero, cpf)
VALUES ('12345678901', '12345678901'),
       ('98765432109', '98765432109'),
       ('11122233344', '12345678901'),
       ('55566677788', '98765432109'),
       ('99988877766', '55555555555');


select * from Aluno where cpf = '41707740860'
delete Aluno where  nome = 'Guilherme do Carmo Silveira'

--
declare @saidaa varchar(100)
exec sp_iuAluno 'I', '41707740860', 5, 'Guilherme Silveira', null,'28-01-2004', 'gui@gmail.com', '01-12-2023', 'Camargo Aranha', 100, 1, 2024, 1, 1, '11948574785',
				'11985693254', @saidaa output
print @saidaa

insert into Aluno values ('41707740860', 5, '202415287', 'Guilherme Silveira', null,'28-01-2004', 'gui@gmail.com', '01-12-2023', 'guilherme.silveira5287@agis.com', 'Camargo Aranha', 100, 1, 2024, 1, 1, 2029, 'Vespertino')

-- Teste Funcao fn_criaRA
declare @random1 int, @random2 int, @random3 int, @random4 int

set @random1 = CAST(RAND() * 10 as int)
set @random2 = CAST(RAND() * 10 as int)
set @random3 = CAST(RAND() * 10 as int)
set @random4 = CAST(RAND() * 10 as int)

SELECT dbo.fn_criaRa(2024, 1) AS RA

select dbo.fn_criaEmailCorporativo('Gustavo da Cruz santos', '202411234') as emailCorp



declare @saida bit
exec sp_validaCpfDuplicado '41707740865', @saida output
print @saida

select numero from telefone where cpf = '41707740860'
select * from telefone
delete Telefone where cpf = '41707740860'and numero = ''

select a.cpf, a.codCurso, a.ra, a.nome, a.nomeSocial, a.dataNascimento, a.email, a.emailCorporativo, a.dataConclusao2Grau, a.instituicao2Grau, a.pontuacaoVestibular,
	   a.posicaoVestibular, a.anoIngresso, a.semestreIngresso, a.anoIngresso, a.anoLimite
from Aluno a, Telefone t 
where a.cpf = t.cpf and a.cpf = '4170774080'

select a.cpf, a.codCurso, a.ra, a.nome, a.nomeSocial, a.dataNascimento, a.email, a.emailCorporativo, a.dataConclusao2Grau, a.instituicao2Grau, a.pontuacaoVestibular,
       a.posicaoVestibular, a.anoIngresso, a.semestreIngresso, a.anoIngresso, a.anoLimite, t.numero
from Aluno a, Telefone t
where a.cpf = t.cpf and a.cpf = '41707740860'

select * from Aluno a, Telefone t where a.cpf  = t.cpf 


select numero, cpf from Telefone order by cpf
select * from Telefone


SELECT a.cpf, a.codCurso, a.ra, a.nome, a.nomeSocial, a.dataNascimento, a.email, a.emailCorporativo, 
	a.dataConclusao2Grau, a.instituicao2Grau, a.pontuacaoVestibular, a.posicaoVestibular, a.anoIngresso, 
    a.semestreIngresso, a.anoIngresso, a.anoLimite, a.semestreLimite,
	(SELECT t1.numero FROM Telefone t1 WHERE t1.cpf = a.cpf AND t1.numero IS NOT NULL ORDER BY t1.numero OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY) AS telefone1,
	(SELECT t2.numero FROM Telefone t2 WHERE t2.cpf = a.cpf AND t2.numero IS NOT NULL ORDER BY t2.numero OFFSET 1 ROWS FETCH NEXT 1 ROW ONLY) AS telefone2
	FROM Aluno a


select cpf, codCurso, ra, nome, nomeSocial, dataNascimento, email, emailCorporativo, 
				dataConclusao2Grau, instituicao2Grau, pontuacaoVestibular,posicaoVestibular
				from Aluno where cpf = '41707740860'

INSERT INTO Disciplina (codDisciplina, codCurso, nome, horasSemanais, horaInicio, diaSemana)
VALUES 
( 1001, 1, 'Programação I', '3:30', '13:00', 'Segunda-feira'),
(1002, 1, 'Programação II', '1:40', '13:00', 'Segunda-feira'),
(1003, 1, 'Banco de Dados', '3:30', '14:50', 'Segunda-feira'),
(1004, 1, 'Engenharia de Software', '1:40', '14:50:00', 'Segunda-feira'),
(1005, 1, 'Laboratório de Hardware', '1:40', '16:40', 'Segunda-feira'),
(1006, 1, 'Arquitetura de computadores', '3:30', '14:50', 'Sexta-feira'),
(1007, 2, 'Gestao Empresarial', '1:40', '14:50', 'Segunda-feira') 

select * from Disciplina

INSERT INTO Matricula (anoSemestre, cpf, codDisciplina) VALUES 
(20241, '41707740860', 1001),
(20241, '41707740860', 1002 ),
(20242, '41707740860', 1003 ),
(20241, '41707740860', 1004 ),
(20241, '41707740860', 1005),
(20241, '41707740860', 1006),
(20241, '41707740860', 1007)

select m.diaSemana, m.codDisciplina, m.disciplina, m.horasSemanais,
					m.horaInicio, m.statusMatricula 
					from Matricula m, Aluno a
					where a.ra = '202416328' and m.cpf = a.cpf



select d.codDisciplina, d.nome, d.horasSemanais, d.horaInicio, m.statusMatricula
from Disciplina d, Matricula m, Aluno a
where a.ra = '202416328' and d.codDisciplina = m.codDisciplina and m.cpf = a.cpf

select * from Disciplina
select * from Matricula
delete Matricula

