<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sistema AGIS - Secretaria Acadêmica</title>
<link rel="stylesheet" href="./css/styleSecretariaDisicplina.css">
<script type="text/javascript">
	function ApareceBotaoAntigo() {
		document.getElementById("telefoneAntigo1").style.display = "table-row";
		document.getElementById("telefoneAntigo2").style.display = "table-row";
	}
</script>
</head>
<body>
	<script src="./js/header.js"></script>
	<main>

		<div class="titulo">
			<h1>Telefone</h1>
			<h3>Cadastrar / Alterar / Excluir / Visualizar</h3>
		</div>

		<form action="telefone" method="post">
			<table>
				<tr>
					<td colspan="3"><input type="number" id="cpf" name="cpf"
						placeholder="CPF"></td>
				</tr>
				<tr>
					<td colspan="3"><input type="text" id="telefoneNovo"
						name="telefoneNovo" placeholder="Número de Telefone"></td>
				</tr>
				<tr id="telefoneAntigo1" style="display: none;">
					<td colspan="3"><input type="text" id="telefoneAntigo"
						name="telefoneAntigo" placeholder="Número de Telefone Antigo">
					</td>
				</tr>
				<tr id="telefoneAntigo2" style="display: none;">
					<td colspan="3"><input type="submit" id="botao" name="botao"
						value="Confirmar"></td>
				</tr>
				<tr>
					<td colspan="1"><input type="submit" id="botao" name="botao"
						value="Cadastrar"></td>
					<td colspan="1">
						<button class="" type="button" onclick="ApareceBotaoAntigo()">
							Alterar</button>
					</td>
					<td colspan="1"><input type="submit" id="botao" name="botao"
						value="Excluir"></td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="submit" id="botao" name="botao" value="Listar">
					</td>
				</tr>
			</table>
		</form>
		
		<c:if test="${not empty alunos}">
			<table class="tabelaAluno">
				<thead>
					<tr>
						<th class="lista">CPF</th>
						<th class="lista">Nome</th>
						<th class="lista">Telefone</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="a" items="${alunos}">
						<tr>
							<td><c:out value="${a.cpf}"></c:out>
							<td><c:out value="${a.nome}"></c:out>
							<td><c:out value="${a.telefones.get(0).numero}"></c:out>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
		<br />

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

	</main>
	<script src="./js/navegacao.js"></script>
</body>
</html>
