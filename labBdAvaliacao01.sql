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