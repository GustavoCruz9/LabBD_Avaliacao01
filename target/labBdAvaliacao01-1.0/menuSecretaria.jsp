<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sistema AGIS - Secretaria Acadêmica</title>
<link rel="stylesheet" href="./css/styleSecretariaCurso.css">
</head>

<body>

	<script src="./js/header.js"></script>

	<main>
		<div class="titulo">
			<h1>Aluno</h1>
			<h3>Cadastrar / Alterar</h3>
		</div>
		
		<div align="center">
			<c:if test="${not empty erro }">
				<h2>
					<b><c:out value="${erro }" /></b>
				</h2>
			</c:if>
		</div>

		<br />
		<div align="center">
			<c:if test="${not empty saida }">
				<h3>
					<b><c:out value="${saida }" /></b>
				</h3>
			</c:if>
		</div>
		
		<br/>

		<form action="aluno" method="post">

			<table>
				<tr>
					<td colspan="3"><input type="number" id="cpf" name="cpf"
						placeholder="CPF *" value='<c:out value="${aluno.cpf}"></c:out>'></td>
					<td><input type="submit" id="botao" name="botao"
						value="Buscar"></td>
				</tr>
				<tr>
					<td colspan="4"><input type="text" id="nome" name="nome"
						placeholder="Nome *" value='<c:out value="${aluno.nome}"></c:out>'></td>
				</tr>
				<tr>
					<td colspan="1">
						<div class="datas">
							<label for="dataNascimento">Data de Nascimento *</label> <input
								type="date" id="dataNascimento" name="dataNascimento" 
								value='<c:out value="${aluno.dataNascimento}"></c:out>'>
						</div>
					</td>
					<td colspan="3"><input type="text" id="nomeSocial"
						name="nomeSocial" placeholder="Nome Social" 
						value='<c:out value="${aluno.nomeSocial}"></c:out>'></td>
				</tr>
				<tr>
					<td colspan="2"><input type="text" id="email" name="email"
						placeholder="E-mail *" value='<c:out value="${aluno.email}"></c:out>'></td>
					<td colspan="2"><input type="text" id="codCurso"
						name="codCurso" placeholder="Código do Curso *" 
						value='<c:out value="${aluno.curso.codigo}"></c:out>'></td>
				</tr>
				<tr>
					<td colspan="1">
						<div class="datas">
							<label for="dataConclusao2Grau">Data de Conclusão *</label> <input
								type="date" id="dataConclusao2Grau" name="dataConclusao2Grau" 
								value='<c:out value="${aluno.dataConclusao2Grau}"></c:out>'>
						</div>
					</td>
					<td colspan="3"><input type="text"
						id="instituicaoConclusao2Grau" name="instituicaoConclusao2Grau"
						placeholder="Instituição de Conclusão 2º Grau *" 
						value='<c:out value="${aluno.instituicao2Grau}"></c:out>'></td>
				</tr>
				<tr>
					<td colspan="2"><input type="number" id="pontuacaoVestibular"
						name="pontuacaoVestibular" placeholder="Pontuação Vestibular *" 
						value='<c:out value="${aluno.pontuacaoVestibular}"></c:out>'></td>
					<td colspan="2"><input type="number" id="posicaoVestibular"
						name="posicaoVestibular" placeholder="Posição Vestibular *"
						value='<c:out value="${aluno.posicaoVestibular}"></c:out>'></td>
				</tr>
				<tr>
					<td colspan="2"><input type="submit" id="botao" name="botao"
						value="Cadastrar"></td>
					<td colspan="2"><input type="submit" id="botao" name="botao"
						value="Alterar"></td>
				</tr>
			</table>

		</form>

		<br />
		

	</main>

	<script src="./js/navegacao.js"></script>

</body>
</html>