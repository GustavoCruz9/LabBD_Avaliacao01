-- use master
-- drop database labBdAvaliacao01

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
Foreign Key(codCurso) references Curso(codCurso),
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

go
create table Disciplina (
codDisciplina	int				not null identity(1001, 1),
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


--PROCEDURE QUE VALIDA SE OCPF EXISTE OU É INVALIDO
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
	--VERIFICACAO DE DIGITOS REPETIDOS
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
					raiserror('CPF inexistente', 16, 1)
			end

		end else begin
			raiserror('CPF inexistente', 16, 1)
		end

	end else begin
		raiserror('CPF invalido, todos os digitos sao iguais', 16, 1)
	end

end else begin
	raiserror('CPF invalido, numero de caracteres incorreto', 16, 1)
end


--PROCEDURE QUE VALIDA SE ALUNO TEM 16 ANOS OU MAIS
-- drop procedure sp_validaIdade
go
create procedure sp_validaIdade(@dataNascimento date, @validaIdade bit output)
as
	if(datediff(year, @dataNascimento, getdate()) >= 16)begin
		set @validaIdade = 1
	end
	else
	begin
		set @validaIdade = 0
		raiserror('A idade é menor que 16 anos', 16, 1)
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

--PROCEDURE QUE VALIDA SE CPF é UNICO NO BANCO DE DADOS DO SISTEMA
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

-- PROCEDURE PARA VERIFICAÇÃO DE RA
go
create procedure sp_validaRa(@ra char(9), @saida bit output)
as
	declare @raExistente char(9)

	set @raExistente = null

	set @raExistente = (select ra from aluno where ra = @ra)

	if(@raExistente is null)
	begin
		set @saida = 0
	end
	else
	begin
		set @saida = 1
	end

--PROCEDURE QUE VALIDA SE CURSO É EXISTENTE
go
create procedure sp_validaCurso(@codCurso int, @validaCurso bit output)
as
	set @codCurso = (select codCurso from Curso where codCurso = @codCurso)

	if(@codCurso is not null)
	begin
		set @validaCurso = 1
	end
	else 
	begin
		set @validaCurso = 0
		raiserror('O codigo do curso é invalido', 16, 1)
	end

--PROCEDURE QUE VALIDA SE TELEFONE EXISTE
-- drop procedure sp_validaTelefone
go
create procedure sp_validaTelefone(@telefone char(11), @validaTelefone bit output)
as
	set @telefone = (select numero from Telefone where numero = @telefone)

	if(@telefone is not null)
	begin
		set @validaTelefone = 1
	end
	else 
	begin
		set @validaTelefone = 0
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
							declare @validaCurso bit
							exec sp_validaCurso @codCurso, @validaCurso output
							if(@validaCurso = 1)
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
													raiserror('Operação invalida', 16, 1)
											end
							end	
				end	
		end
		

--Procedure sp_iudTelefone	
-- drop procedure sp_iudTelefone
go
create procedure sp_iudTelefone(@op char(1), @cpf char(11), @telefoneAntigo char(11) null, @telefoneNovo char(11), 
								@saida  varchar(150) output)
as
		declare @validaTelefone bit 

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
										
										exec sp_validaTelefone @telefoneAntigo, @validaTelefone output
										if(@validaTelefone = 1)
										begin

													update Telefone set numero = @telefoneNovo where cpf = @cpf and numero = @telefoneAntigo

													set @saida = 'Telefone atualizado com sucesso'

													return
										end
										else
										begin
													raiserror('O telefone não existe no banco de dados', 16, 1)
										end
								end
								else
								begin
													raiserror('Tamanho de telefone incorreto', 16, 1)
								end
						end
						
						if(upper(@op) = 'D')
						begin
										exec sp_validaTelefone @telefoneNovo, @validaTelefone output
										if(@validaTelefone = 1)
										begin
														delete Telefone where cpf = @cpf and numero = @telefoneNovo

														set @saida = 'Telefone excluido com sucesso'
														
														return
										end
										else
										begin
														raiserror('O telefone não existe no banco de dados', 16, 1)
										end
						end
								
						if(upper(@op) = 'I')
						begin
									exec sp_validaTelefone @telefoneNovo, @validaTelefone output
									if(@validaTelefone = 0)
									begin
												insert into Telefone (cpf, numero) values (@cpf, @telefoneNovo)

												set @saida = 'Telefone cadastrado com sucesso'

												return
									end
									else
									begin
												raiserror('O telefone ja existe no banco de dados', 16, 1)
									end
						end
						else
						begin
									raiserror('Operação invalida', 16, 1)
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
go
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


-- FUNCTION PARA OBTER ANOSEMESTRE
-- drop function fn_obterAnoSemestre
go
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


-- PROCEDURE sp_cadastrarMatricula
-- drop procedure sp_cadastrarMatricula
go
create procedure sp_cadastrarMatricula(@ra char(9), @codDisciplinaRequerida int, @saida varchar(150) output)
as
		declare @codCurso int,
				@diaSemana varchar(15),
				@horaInicioDisciplinaRequerida time,
				@horaInicioDisciplinaMatriculada time,
				@horaFinalDisciplinaMatriculada time,
				@horaFinalDisciplinaRequerida time,
				@qtdMatricula int,
				@cpf char(11),
				@anoSemestre varchar(5),
				@valida bit

		set @valida = 0

		set @cpf = (select cpf from Aluno where ra = @ra)

		set @codCurso = (select codCurso from Aluno where ra = @ra)

		set @diaSemana = (select diaSemana from Disciplina where codDisciplina = @codDisciplinaRequerida)

		set @horaInicioDisciplinaRequerida = (select horaInicio from Disciplina where codDisciplina = @codDisciplinaRequerida)

		set @horaFinalDisciplinaRequerida = (select horaFinal from Disciplina where codDisciplina = @codDisciplinaRequerida)
									
		set @qtdMatricula = (select count(*) from matricula m, Disciplina d 
							 where lower(m.statusMatricula) = lower('Pendente') 
							 and m.codDisciplina = d.codDisciplina and
							 d.codCurso = @codCurso and d.diaSemana = @diaSemana)

		if (@qtdMatricula = 0)
		begin

			set @anoSemestre = dbo.fn_obterAnoSemestre()

			insert into Matricula (anoSemestre, cpf, codDisciplina) values
			(@anoSemestre, @cpf, @codDisciplinaRequerida)

			set @saida = 'Matricula realizada com sucesso'
		end

		create table #matriculastemp(
			horaInicioDisciplinaMatriculada time,
			horaFinalDisciplinaMatriculada time,
		)
		
		insert into #matriculastemp (horaInicioDisciplinaMatriculada, horaFinalDisciplinaMatriculada)
									SELECT d.horaInicio, d.horaFinal
									FROM matricula m, Disciplina d 
									WHERE LOWER(m.statusMatricula) = LOWER('Pendente') 
									AND d.codCurso = @codCurso 
									AND d.diaSemana = @diaSemana and
									m.codDisciplina = d.codDisciplina

		while(@qtdMatricula > 0)
		begin
			

				set @horaInicioDisciplinaMatriculada = (select top 1 horaInicioDisciplinaMatriculada from #matriculastemp)

				set @horaFinalDisciplinaMatriculada = (select top 1 horaFinalDisciplinaMatriculada from #matriculastemp)

				delete top (1) from #matriculastemp

				if((@horaInicioDisciplinaRequerida not between @horaInicioDisciplinaMatriculada and @horaFinalDisciplinaMatriculada)
				and 
				(@horaFinalDisciplinaRequerida not between @horaInicioDisciplinaMatriculada and @horaFinalDisciplinaMatriculada))
				begin

							set @valida  = 1

				end
				else
				begin
							set @valida = 0
							drop table #matriculastemp
							raiserror('Já existe um materia cadastrada nesse intervalo de horario', 16, 1)
							return
				end		

				set @qtdMatricula = @qtdMatricula - 1
				
		end

		if(@valida = 1)
		begin
				set @anoSemestre = dbo.fn_obterAnoSemestre()

				insert into Matricula (anoSemestre, cpf, codDisciplina) values
						(@anoSemestre, @cpf, @codDisciplinaRequerida)

				set @saida = 'Matricula realizada com sucesso'
		end

--- INSERT --- --- INSERT --- --- INSERT --- --- INSERT --- --- INSERT --- --- INSERT --- --- INSERT --- --- INSERT --- --- INSERT --- --- INSERT --- --- INSERT --- --- INSERT --- --- INSERT --- --- INSERT --- --- INSERT ---

-- Tabela Curso
go
-- Inserir múltiplas linhas na tabela Curso
INSERT INTO Curso (codCurso, nome, cargaHoraria, sigla, notaEnade) 
VALUES 
    (1, 'Análise e Desenvolvimento de Sistemas', 3000, 'ADS', 4),
    (2, 'Medicina', 6000, 'MED', 5),
    (3, 'Administração', 3200, 'ADM', 3),
    (4, 'Ciência da Computação', 3500, 'CCO', 4),
    (5, 'Direito', 3800, 'DIR', 4),
    (6, 'Psicologia', 3400, 'PSI', 3),
    (7, 'Engenharia Elétrica', 4200, 'ELE', 4),
    (8, 'Arquitetura e Urbanismo', 4000, 'ARQ', 4),
    (9, 'Economia', 3000, 'ECO', 3),
    (10, 'Letras', 2800, 'LET', 3);
go
-- Inserir disciplinas para o curso de Engenharia Civil (codCurso = 1)
INSERT INTO Disciplina (codCurso, nome, horasSemanais, horaInicio, diaSemana)
VALUES 
(1, 'Cálculo I', '3:30', '13:00', 'Segunda-feira'),
(1, 'Álgebra Linear', '1:40', '14:50', 'Segunda-feira'),
(1, 'Física I', '1:40', '16:40', 'Segunda-feira'),
(1, 'Desenho Técnico', '1:40', '13:00', 'Segunda-feira'),
(1, 'Introdução à Engenharia', '3:30', '14:50', 'Segunda-feira'),

(1, 'Engenharia de Materiais', '3:30', '13:00', 'Terça-feira'),
(1, 'Geometria Analítica', '1:40', '14:50', 'Terça-feira'),
(1, 'Mecânica Geral', '1:40', '16:40', 'Terça-feira'),
(1, 'Topografia', '1:40', '13:00', 'Terça-feira'),
(1, 'Fenômenos de Transporte', '3:30', '14:50', 'Terça-feira'),

(1, 'Mecânica dos Fluidos', '3:30', '13:00', 'Quarta-feira'),
(1, 'Estatística Aplicada', '1:40', '14:50', 'Quarta-feira'),
(1, 'Desenho Assistido por Computador', '1:40', '16:40', 'Quarta-feira'),
(1, 'Materiais de Construção Civil', '1:40', '13:00', 'Quarta-feira'),
(1, 'Probabilidade e Estatística', '3:30', '14:50', 'Quarta-feira'),

(1, 'Mecânica dos Solos', '3:30', '13:00', 'Quinta-feira'),
(1, 'Hidráulica', '1:40', '14:50', 'Quinta-feira'),
(1, 'Construção Civil', '1:40', '16:40', 'Quinta-feira'),
(1, 'Gestão de Projetos', '1:40', '13:00', 'Quinta-feira'),
(1, 'Sistemas Estruturais', '3:30', '14:50', 'Quinta-feira'),

(1, 'Instalações Hidrossanitárias', '3:30', '13:00', 'Sexta-feira'),
(1, 'Fundamentos de Engenharia', '1:40', '14:50', 'Sexta-feira'),
(1, 'Saneamento Básico', '1:40', '16:40', 'Sexta-feira'),
(1, 'Ética Profissional', '1:40', '13:00', 'Sexta-feira'),
(1, 'Legislação Ambiental', '3:30', '14:50', 'Sexta-feira');
go
-- Inserir disciplinas para o curso de Medicina (codCurso = 2)
INSERT INTO Disciplina (codCurso, nome, horasSemanais, horaInicio, diaSemana)
VALUES 
(2, 'Anatomia Humana', '3:30', '13:00', 'Segunda-feira'),
(2, 'Fisiologia', '1:40', '14:50', 'Segunda-feira'),
(2, 'Bioquímica', '1:40', '16:40', 'Segunda-feira'),
(2, 'Histologia', '1:40', '13:00', 'Segunda-feira'),
(2, 'Embriologia', '3:30', '14:50', 'Segunda-feira'),

(2, 'Farmacologia', '3:30', '13:00', 'Terça-feira'),
(2, 'Patologia Geral', '1:40', '14:50', 'Terça-feira'),
(2, 'Microbiologia', '1:40', '16:40', 'Terça-feira'),
(2, 'Genética', '1:40', '13:00', 'Terça-feira'),
(2, 'Imunologia', '3:30', '14:50', 'Terça-feira'),

(2, 'Semiologia', '3:30', '13:00', 'Quarta-feira'),
(2, 'Epidemiologia', '1:40', '14:50', 'Quarta-feira'),
(2, 'Parasitologia', '1:40', '16:40', 'Quarta-feira'),
(2, 'Bioética', '1:40', '13:00', 'Quarta-feira'),
(2, 'Saúde Pública', '3:30', '14:50', 'Quarta-feira'),

(2, 'Neuroanatomia', '3:30', '13:00', 'Quinta-feira'),
(2, 'Neurofisiologia', '1:40', '14:50', 'Quinta-feira'),
(2, 'Neurologia', '1:40', '16:40', 'Quinta-feira'),
(2, 'Psiquiatria', '1:40', '13:00', 'Quinta-feira'),
(2, 'Dermatologia', '3:30', '14:50', 'Quinta-feira'),

(2, 'Ginecologia', '3:30', '13:00', 'Sexta-feira'),
(2, 'Obstetrícia', '1:40', '14:50', 'Sexta-feira'),
(2, 'Pediatria', '1:40', '16:40', 'Sexta-feira'),
(2, 'Ortopedia', '1:40', '13:00', 'Sexta-feira'),
(2, 'Oftalmologia', '3:30', '14:50', 'Sexta-feira');
go
-- Inserir disciplinas para o curso de Administração (codCurso = 3)
INSERT INTO Disciplina (codCurso, nome, horasSemanais, horaInicio, diaSemana)
VALUES 
(3, 'Gestão Empresarial', '3:30', '13:00', 'Segunda-feira'),
(3, 'Contabilidade Financeira', '1:40', '14:50', 'Segunda-feira'),
(3, 'Marketing', '1:40', '16:40', 'Segunda-feira'),
(3, 'Economia', '1:40', '13:00', 'Segunda-feira'),
(3, 'Direito Empresarial', '3:30', '14:50', 'Segunda-feira'),

(3, 'Administração de Recursos Humanos', '3:30', '13:00', 'Terça-feira'),
(3, 'Gestão de Projetos', '1:40', '14:50', 'Terça-feira'),
(3, 'Logística', '1:40', '16:40', 'Terça-feira'),
(3, 'Comportamento Organizacional', '1:40', '13:00', 'Terça-feira'),
(3, 'Administração Financeira', '3:30', '14:50', 'Terça-feira'),

(3, 'Empreendedorismo', '3:30', '13:00', 'Quarta-feira'),
(3, 'Negociação', '1:40', '14:50', 'Quarta-feira'),
(3, 'Inovação', '1:40', '16:40', 'Quarta-feira'),
(3, 'Estratégia Empresarial', '1:40', '13:00', 'Quarta-feira'),
(3, 'Consultoria Empresarial', '3:30', '14:50', 'Quarta-feira'),

(3, 'Gestão de Qualidade', '3:30', '13:00', 'Quinta-feira'),
(3, 'Ética Empresarial', '1:40', '14:50', 'Quinta-feira'),
(3, 'Finanças Corporativas', '1:40', '16:40', 'Quinta-feira'),
(3, 'Gestão Ambiental', '1:40', '13:00', 'Quinta-feira'),
(3, 'Administração Pública', '3:30', '14:50', 'Quinta-feira'),

(3, 'Gestão de Tecnologia da Informação', '3:30', '13:00', 'Sexta-feira'),
(3, 'Marketing Digital', '1:40', '14:50', 'Sexta-feira'),
(3, 'Gestão de Pessoas', '1:40', '16:40', 'Sexta-feira'),
(3, 'Comércio Exterior', '1:40', '13:00', 'Sexta-feira'),
(3, 'Gestão de Vendas', '3:30', '14:50', 'Sexta-feira');
go
-- Inserir disciplinas para o curso de Ciência da Computação (codCurso = 4)
INSERT INTO Disciplina (codCurso, nome, horasSemanais, horaInicio, diaSemana)
VALUES 
(4, 'Introdução à Computação', '3:30', '13:00', 'Segunda-feira'),
(4, 'Algoritmos e Estruturas de Dados', '1:40', '14:50', 'Segunda-feira'),
(4, 'Banco de Dados', '1:40', '16:40', 'Segunda-feira'),
(4, 'Redes de Computadores', '1:40', '13:00', 'Segunda-feira'),
(4, 'Programação Orientada a Objetos', '3:30', '14:50', 'Segunda-feira'),

(4, 'Sistemas Operacionais', '3:30', '13:00', 'Terça-feira'),
(4, 'Inteligência Artificial', '1:40', '14:50', 'Terça-feira'),
(4, 'Engenharia de Software', '1:40', '16:40', 'Terça-feira'),
(4, 'Segurança da Informação', '1:40', '13:00', 'Terça-feira'),
(4, 'Computação Gráfica', '3:30', '14:50', 'Terça-feira'),

(4, 'Arquitetura de Computadores', '3:30', '13:00', 'Quarta-feira'),
(4, 'Sistemas Distribuídos', '1:40', '14:50', 'Quarta-feira'),
(4, 'Compiladores', '1:40', '16:40', 'Quarta-feira'),
(4, 'Web Development', '1:40', '13:00', 'Quarta-feira'),
(4, 'Machine Learning', '3:30', '14:50', 'Quarta-feira'),

(4, 'Computação Paralela e Distribuída', '3:30', '13:00', 'Quinta-feira'),
(4, 'Gestão de Projetos de TI', '1:40', '14:50', 'Quinta-feira'),
(4, 'Ética em Computação', '1:40', '16:40', 'Quinta-feira'),
(4, 'Big Data Analytics', '1:40', '13:00', 'Quinta-feira'),
(4, 'Mineração de Dados', '3:30', '14:50', 'Quinta-feira'),

(4, 'Computação em Nuvem', '3:30', '13:00', 'Sexta-feira'),
(4, 'Desenvolvimento Mobile', '1:40', '14:50', 'Sexta-feira'),
(4, 'Internet das Coisas', '1:40', '16:40', 'Sexta-feira'),
(4, 'Realidade Virtual e Aumentada', '1:40', '13:00', 'Sexta-feira'),
(4, 'Blockchain', '3:30', '14:50', 'Sexta-feira');
go
-- Inserir disciplinas para o curso de Direito (codCurso = 5)
INSERT INTO Disciplina (codCurso, nome, horasSemanais, horaInicio, diaSemana)
VALUES 
(5, 'Introdução ao Direito', '3:30', '13:00', 'Segunda-feira'),
(5, 'Teoria Geral do Estado', '1:40', '14:50', 'Segunda-feira'),
(5, 'Direito Constitucional', '1:40', '16:40', 'Segunda-feira'),
(5, 'Direito Civil I', '1:40', '13:00', 'Segunda-feira'),
(5, 'Filosofia do Direito', '3:30', '14:50', 'Segunda-feira'),

(5, 'Direito Penal I', '3:30', '13:00', 'Terça-feira'),
(5, 'Direito Administrativo I', '1:40', '14:50', 'Terça-feira'),
(5, 'Direito Civil II', '1:40', '16:40', 'Terça-feira'),
(5, 'Direito Tributário I', '1:40', '13:00', 'Terça-feira'),
(5, 'Sociologia Jurídica', '3:30', '14:50', 'Terça-feira'),

(5, 'Direito Penal II', '3:30', '13:00', 'Quarta-feira'),
(5, 'Direito Processual Civil I', '1:40', '14:50', 'Quarta-feira'),
(5, 'Direito do Consumidor', '1:40', '16:40', 'Quarta-feira'),
(5, 'Direito Tributário II', '1:40', '13:00', 'Quarta-feira'),
(5, 'Direito Processual Penal I', '3:30', '14:50', 'Quarta-feira'),

(5, 'Direito Internacional Público', '3:30', '13:00', 'Quinta-feira'),
(5, 'Direito Processual Civil II', '1:40', '14:50', 'Quinta-feira'),
(5, 'Direito Ambiental', '1:40', '16:40', 'Quinta-feira'),
(5, 'Direito Processual Penal II', '1:40', '13:00', 'Quinta-feira'),
(5, 'Direito Empresarial', '3:30', '14:50', 'Quinta-feira'),

(5, 'Direito Internacional Privado', '3:30', '13:00', 'Sexta-feira'),
(5, 'Direitos Humanos', '1:40', '14:50', 'Sexta-feira'),
(5, 'Mediação e Arbitragem', '1:40', '16:40', 'Sexta-feira'),
(5, 'Direito Previdenciário', '1:40', '13:00', 'Sexta-feira'),
(5, 'Crimes Digitais', '3:30', '14:50', 'Sexta-feira');
go
-- Inserir disciplinas para o curso de Psicologia (codCurso = 6)
INSERT INTO Disciplina (codCurso, nome, horasSemanais, horaInicio, diaSemana)
VALUES 
(6, 'Psicologia Geral', '3:30', '13:00', 'Segunda-feira'),
(6, 'Psicologia do Desenvolvimento', '1:40', '14:50', 'Segunda-feira'),
(6, 'Psicopatologia', '1:40', '16:40', 'Segunda-feira'),
(6, 'Psicologia Social', '1:40', '13:00', 'Segunda-feira'),
(6, 'Neuropsicologia', '3:30', '14:50', 'Segunda-feira'),

(6, 'Psicoterapia Cognitivo-Comportamental', '3:30', '13:00', 'Terça-feira'),
(6, 'Psicoterapia Psicanalítica', '1:40', '14:50', 'Terça-feira'),
(6, 'Psicologia Clínica', '1:40', '16:40', 'Terça-feira'),
(6, 'Psicologia Organizacional', '1:40', '13:00', 'Terça-feira'),
(6, 'Psicologia da Saúde', '3:30', '14:50', 'Terça-feira'),

(6, 'Psicologia Escolar e Educacional', '3:30', '13:00', 'Quarta-feira'),
(6, 'Psicologia Jurídica', '1:40', '14:50', 'Quarta-feira'),
(6, 'Psicologia do Esporte', '1:40', '16:40', 'Quarta-feira'),
(6, 'Orientação Vocacional', '1:40', '13:00', 'Quarta-feira'),
(6, 'Terapia de Família e Casal', '3:30', '14:50', 'Quarta-feira'),

(6, 'Psicologia Hospitalar', '3:30', '13:00', 'Quinta-feira'),
(6, 'Psicologia Comunitária', '1:40', '14:50', 'Quinta-feira'),
(6, 'Psicologia Forense', '1:40', '16:40', 'Quinta-feira'),
(6, 'Psicologia do Trânsito', '1:40', '13:00', 'Quinta-feira'),
(6, 'Psicologia Positiva', '3:30', '14:50', 'Quinta-feira'),

(6, 'Psicologia Existencial', '3:30', '13:00', 'Sexta-feira'),
(6, 'Neurociência e Comportamento', '1:40', '14:50', 'Sexta-feira'),
(6, 'Psicologia da Arte', '1:40', '16:40', 'Sexta-feira'),
(6, 'Psicologia Transpessoal', '1:40', '13:00', 'Sexta-feira'),
(6, 'Psicologia da Aprendizagem', '3:30', '14:50', 'Sexta-feira');
go
-- Inserir disciplinas para o curso de Engenharia Elétrica (codCurso = 7)
INSERT INTO Disciplina (codCurso, nome, horasSemanais, horaInicio, diaSemana)
VALUES 
(7, 'Circuitos Elétricos I', '3:30', '13:00', 'Segunda-feira'),
(7, 'Máquinas Elétricas', '1:40', '14:50', 'Segunda-feira'),
(7, 'Eletromagnetismo', '1:40', '16:40', 'Segunda-feira'),
(7, 'Eletrônica Analógica', '1:40', '13:00', 'Segunda-feira'),
(7, 'Sistemas de Controle', '3:30', '14:50', 'Segunda-feira'),

(7, 'Circuitos Elétricos II', '3:30', '13:00', 'Terça-feira'),
(7, 'Instalações Elétricas', '1:40', '14:50', 'Terça-feira'),
(7, 'Eletrotécnica', '1:40', '16:40', 'Terça-feira'),
(7, 'Automação Industrial', '1:40', '13:00', 'Terça-feira'),
(7, 'Geração e Distribuição de Energia Elétrica', '3:30', '14:50', 'Terça-feira'),

(7, 'Instrumentação Eletrônica', '3:30', '13:00', 'Quarta-feira'),
(7, 'Eletromecânica', '1:40', '14:50', 'Quarta-feira'),
(7, 'Sistemas de Potência', '1:40', '16:40', 'Quarta-feira'),
(7, 'Telecomunicações', '1:40', '13:00', 'Quarta-feira'),
(7, 'Energias Renováveis', '3:30', '14:50', 'Quarta-feira'),

(7, 'Eletrônica Digital', '3:30', '13:00', 'Quinta-feira'),
(7, 'Processamento de Sinais', '1:40', '14:50', 'Quinta-feira'),
(7, 'Microeletrônica', '1:40', '16:40', 'Quinta-feira'),
(7, 'Eletromagnetismo Aplicado', '1:40', '13:00', 'Quinta-feira'),
(7, 'Eletrônica de Potência', '3:30', '14:50', 'Quinta-feira'),

(7, 'Proteção de Sistemas Elétricos', '3:30', '13:00', 'Sexta-feira'),
(7, 'Engenharia Econômica', '1:40', '14:50', 'Sexta-feira'),
(7, 'Introdução ao Projeto de Sistemas Elétricos', '1:40', '16:40', 'Sexta-feira'),
(7, 'Sistemas Embarcados', '1:40', '13:00', 'Sexta-feira'),
(7, 'Trabalho de Conclusão de Curso', '3:30', '14:50', 'Sexta-feira');
go
-- Inserir disciplinas para o curso de Arquitetura e Urbanismo (codCurso = 8)
INSERT INTO Disciplina (codCurso, nome, horasSemanais, horaInicio, diaSemana)
VALUES 
(8, 'Desenho Arquitetônico', '3:30', '13:00', 'Segunda-feira'),
(8, 'História da Arquitetura e Urbanismo', '1:40', '14:50', 'Segunda-feira'),
(8, 'Teoria da Arquitetura', '1:40', '16:40', 'Segunda-feira'),
(8, 'Geometria Descritiva', '1:40', '13:00', 'Segunda-feira'),
(8, 'Conforto Térmico e Acústico', '3:30', '14:50', 'Segunda-feira'),

(8, 'Projeto Arquitetônico', '3:30', '13:00', 'Terça-feira'),
(8, 'Planejamento Urbano', '1:40', '14:50', 'Terça-feira'),
(8, 'Desenho Urbano', '1:40', '16:40', 'Terça-feira'),
(8, 'Tecnologia da Construção', '1:40', '13:00', 'Terça-feira'),
(8, 'Estudos Ambientais', '3:30', '14:50', 'Terça-feira'),

(8, 'Legislação Urbana', '3:30', '13:00', 'Quarta-feira'),
(8, 'Arquitetura Paisagística', '1:40', '14:50', 'Quarta-feira'),
(8, 'Projeto de Interiores', '1:40', '16:40', 'Quarta-feira'),
(8, 'Restauro e Conservação', '1:40', '13:00', 'Quarta-feira'),
(8, 'Gestão de Projetos de Arquitetura e Urbanismo', '3:30', '14:50', 'Quarta-feira'),

(8, 'Gestão Urbana', '3:30', '13:00', 'Quinta-feira'),
(8, 'Desenho Assistido por Computador', '1:40', '14:50', 'Quinta-feira'),
(8, 'Conforto Ambiental', '1:40', '16:40', 'Quinta-feira'),
(8, 'Planejamento Energético', '1:40', '13:00', 'Quinta-feira'),
(8, 'Ergonomia e Acessibilidade', '3:30', '14:50', 'Quinta-feira'),

(8, 'Gestão de Empreendimentos Imobiliários', '3:30', '13:00', 'Sexta-feira'),
(8, 'Ética e Legislação Profissional', '1:40', '14:50', 'Sexta-feira'),
(8, 'Tópicos Especiais em Arquitetura e Urbanismo', '1:40', '16:40', 'Sexta-feira'),
(8, 'Projeto de Graduação', '1:40', '13:00', 'Sexta-feira'),
(8, 'Prática Profissional', '3:30', '14:50', 'Sexta-feira');
go
-- Inserir disciplinas para o curso de Economia (codCurso = 9)
INSERT INTO Disciplina (codCurso, nome, horasSemanais, horaInicio, diaSemana)
VALUES 
(9, 'Microeconomia', '3:30', '13:00', 'Segunda-feira'),
(9, 'Macroeconomia', '1:40', '14:50', 'Segunda-feira'),
(9, 'Economia Internacional', '1:40', '16:40', 'Segunda-feira'),
(9, 'Economia do Setor Público', '1:40', '13:00', 'Segunda-feira'),
(9, 'Economia Brasileira', '3:30', '14:50', 'Segunda-feira'),

(9, 'Economia Monetária', '3:30', '13:00', 'Terça-feira'),
(9, 'Economia do Desenvolvimento', '1:40', '14:50', 'Terça-feira'),
(9, 'Economia da Tecnologia', '1:40', '16:40', 'Terça-feira'),
(9, 'Economia Política', '1:40', '13:00', 'Terça-feira'),
(9, 'Econometria', '3:30', '14:50', 'Terça-feira'),

(9, 'Teoria Econômica', '3:30', '13:00', 'Quarta-feira'),
(9, 'Economia Comportamental', '1:40', '14:50', 'Quarta-feira'),
(9, 'Economia Ambiental', '1:40', '16:40', 'Quarta-feira'),
(9, 'Economia da Educação', '1:40', '13:00', 'Quarta-feira'),
(9, 'Economia da Saúde', '3:30', '14:50', 'Quarta-feira'),

(9, 'Economia do Trabalho', '3:30', '13:00', 'Quinta-feira'),
(9, 'Economia Agrícola', '1:40', '14:50', 'Quinta-feira'),
(9, 'Economia do Meio Ambiente', '1:40', '16:40', 'Quinta-feira'),
(9, 'Economia de Energia', '1:40', '13:00', 'Quinta-feira'),
(9, 'Economia Criativa', '3:30', '14:50', 'Quinta-feira'),

(9, 'Economia Solidária', '3:30', '13:00', 'Sexta-feira'),
(9, 'Economia do Turismo', '1:40', '14:50', 'Sexta-feira'),
(9, 'Economia de Mercado', '1:40', '16:40', 'Sexta-feira'),
(9, 'Economia Informal', '1:40', '13:00', 'Sexta-feira'),
(9, 'Economia Colaborativa', '3:30', '14:50', 'Sexta-feira');
go
-- Inserir disciplinas para o curso de Medicina (codCurso = 10)
INSERT INTO Disciplina (codCurso, nome, horasSemanais, horaInicio, diaSemana)
VALUES 
(10, 'Anatomia Humana', '3:30', '13:00', 'Segunda-feira'),
(10, 'Bioquímica Médica', '1:40', '14:50', 'Segunda-feira'),
(10, 'Fisiologia', '1:40', '16:40', 'Segunda-feira'),
(10, 'Histologia', '1:40', '13:00', 'Segunda-feira'),
(10, 'Embriologia', '3:30', '14:50', 'Segunda-feira'),

(10, 'Patologia Geral', '3:30', '13:00', 'Terça-feira'),
(10, 'Farmacologia', '1:40', '14:50', 'Terça-feira'),
(10, 'Microbiologia', '1:40', '16:40', 'Terça-feira'),
(10, 'Imunologia', '1:40', '13:00', 'Terça-feira'),
(10, 'Epidemiologia', '3:30', '14:50', 'Terça-feira'),

(10, 'Semiologia', '3:30', '13:00', 'Quarta-feira'),
(10, 'Propedêutica Médica', '1:40', '14:50', 'Quarta-feira'),
(10, 'Bioética', '1:40', '16:40', 'Quarta-feira'),
(10, 'Psicologia Médica', '1:40', '13:00', 'Quarta-feira'),
(10, 'Introdução à Medicina', '3:30', '14:50', 'Quarta-feira'),

(10, 'Clínica Médica I', '3:30', '13:00', 'Quinta-feira'),
(10, 'Clínica Cirúrgica I', '1:40', '14:50', 'Quinta-feira'),
(10, 'Pediatria', '1:40', '16:40', 'Quinta-feira'),
(10, 'Ginecologia e Obstetrícia', '1:40', '13:00', 'Quinta-feira'),
(10, 'Medicina Preventiva', '3:30', '14:50', 'Quinta-feira'),

(10, 'Clínica Médica II', '3:30', '13:00', 'Sexta-feira'),
(10, 'Clínica Cirúrgica II', '1:40', '14:50', 'Sexta-feira'),
(10, 'Psiquiatria', '1:40', '16:40', 'Sexta-feira'),
(10, 'Ortopedia', '1:40', '13:00', 'Sexta-feira'),
(10, 'Urologia', '3:30', '14:50', 'Sexta-feira');
