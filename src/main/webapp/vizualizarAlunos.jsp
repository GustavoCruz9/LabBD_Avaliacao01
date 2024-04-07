<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sistema AGIS - Secretaria Acadêmica</title>
<link rel="stylesheet" href="./css/styleSecretariaDisicplina.css">
</head>

<body>

	<script src="./js/header.js"></script>

	<main>
		<h1>Alunos</h1>

		<form action="aluno" method="post">
			<input type="submit" id="botao" name="botao" value="Listar">
		</form>
		
		<div class="divTabelaAlunos">
			<c:if test="${not empty alunos}">
			<table class="tabelaAluno">
				<thead>
					<tr>
						<th class="lista">RA</th>
						<th class="lista">CPF</th>
						<th class="lista">Cód. Curso</th>
						<th class="lista">Nome</th>
						<th class="lista">Nome Social</th>
						<th class="lista">Data de Nasc.</th>
						<th class="lista">E-mail</th>
						<th class="lista">E-mail Corp.</th>
						<th class="lista">Data 2º Grau</th>
						<th class="lista">Inst. 2º Grau</th>
						<th class="lista">Pont. Vest.</th>
						<th class="lista">Pos. Vest.</th>
						<th class="lista">Ano/Sem. Ingresso</th>
						<th class="lista">Ano/Sem. Limite</th>
						<th class="lista">Tel. 1</th>
						<th class="lista">Tel. 2</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="a" items="${alunos}">
						<tr>
							<td><c:out value="${a.ra}"></c:out>
							<td><c:out value="${a.cpf}"></c:out>
							<td><c:out value="${a.curso.codigo}"></c:out>
							<td><c:out value="${a.nome}"></c:out>
							<td><c:out value="${a.nomeSocial}"></c:out>
							<td><c:out value="${a.dataNascimento}"></c:out>
							<td><c:out value="${a.email}"></c:out>
							<td><c:out value="${a.emailCorporativo}"></c:out>
							<td><c:out value="${a.dataConclusao2Grau}"></c:out>
							<td><c:out value="${a.instituicao2Grau}"></c:out>
							<td><c:out value="${a.pontuacaoVestibular}"></c:out>
							<td><c:out value="${a.posicaoVestibular}"></c:out>
							<td><c:out value="${a.anoIngresso}${-a.semestreIngresso}"></c:out>
							<td><c:out value="${a.anoLimite}${-a.semestreLimite}"></c:out>
							<td><c:out value="${a.telefones[0].numero}"></c:out>
							<td><c:out value="${a.telefones[1].numero}"></c:out>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
		</div>

		
		<br />

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

		<br />

		<script src="./js/navegacao.js"></script>
	</main>
</body>
</html>