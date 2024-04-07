<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sistema AGIS - Aluno</title>
<link rel="stylesheet" href="./css/styleMenuAluno.css">
</head>
<body>

	<script src="./js/headerAluno.js"></script>
	
	<main>
		<h1>Vizualizar Matrícula</h1>

		<form action="matricula" method="post">
			<div class="cpfMatricula">
				<div class="pesquisaCpf">
					<input type="text" name="pesquisaRa"
						id="pesquisaRa" placeholder="RA" class="inputCPF">
					<input type="submit" value="☑️" class="btnCPF" id="botao"
						name="botao">
				</div>
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

			<table class="vizualizarMatricula">
				<thead>
					<tr>
						<th colspan="6" class="tableTitle">Matrícula</th>
					</tr>
					<tr>
						<th>Código</th>
						<th>Disciplina</th>
						<th>Horas Semanais</th>
						<th>Hora de Início</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="m" items="${matriculas }">
						<tr>
							<td><c:out value="${m.disciplina.codigoDisciplina}"></c:out>
							<td><c:out value="${m.disciplina.disciplina}"></c:out>
							<td><c:out value="${m.disciplina.horasSemanais}"></c:out>
							<td><c:out value="${m.disciplina.horaInicio}"></c:out>
							<td class="status"><c:out value="${m.status}"></c:out>
						</tr>
					</c:forEach>
				</tbody>
				</tbody>
			</table>


		</form>
	</main>

</body>
</html>