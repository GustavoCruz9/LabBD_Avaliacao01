<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sistema AGIS - Secretaria Acadêmica</title>
<link rel="stylesheet" href="./css/styleSecretariaMatricula.css">
</head>

<body>

	<script src="./js/header.js"></script>

	<main>
		<h1>Cadastro de Matrícula</h1>

		<form action="matricula" method="post" class="formMatricula">
			<div class="cpfMatricula">
				<div class="pesquisaCpf">
					<input type="text" name="pesquisaRa" id="pesquisaRa"
						name="pesquisaRa" placeholder="RA" class="inputCPF"> <input
						type="submit" value="🔎" class="btnCPF" id="botao" name="botao">
				</div>
			</div>
			
			<br>
			<br>

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
			
			<br>
			<br>

			<div class="diasSemana">
				<table class="segunda">
					<thead>
						<tr>
							<th colspan="6" class="tableTitle">Segunda-feira</th>
						</tr>
						<tr>
							<th>Código</th>
							<th>Disciplina</th>
							<th>Horas Semanais</th>
							<th>Hora de Início</th>
							<th>Status</th>
							<th>Selecionar</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="d" items="${disciplinas }">
							<c:if test="${d.disciplina.diaSemana eq 'segunda-feira' }">
								<tr>
									<td><c:out value="${d.disciplina.codigoDisciplina}"></c:out>
									<td><c:out value="${d.disciplina.disciplina}"></c:out>
									<td><c:out value="${d.disciplina.horasSemanais}"></c:out>
									<td><c:out value="${d.disciplina.horaInicio}"></c:out>
									<td><c:out value="${d.status}"></c:out>
									<td class="status"><input type="submit" id="matricular"
										name="matricular" value="matricular"></td>
								</tr>
							</c:if>
						</c:forEach>
					</tbody>
				</table>
				<table class="terca">
					<thead>
						<tr>
							<th colspan="6" class="tableTitle">Terca-feira</th>
						</tr>
						<tr>
							<th>Código</th>
							<th>Disciplina</th>
							<th>Horas Semanais</th>
							<th>Hora de Início</th>
							<th>Status</th>
							<th>Selecionar</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="d" items="${disciplinas }">
							<c:if test="${d.disciplina.diaSemana eq 'terça-feira' }">
								<tr>
									<td><c:out value="${d.disciplina.codigoDisciplina}"></c:out>
									<td><c:out value="${d.disciplina.disciplina}"></c:out>
									<td><c:out value="${d.disciplina.horasSemanais}"></c:out>
									<td><c:out value="${d.disciplina.horaInicio}"></c:out>
									<td><c:out value="${d.status}"></c:out>
									<td class="status"><input type="submit" id="matricular"
										name="matricular" value="matricular"></td>
								</tr>
							</c:if>
						</c:forEach>
					</tbody>
				</table>
				<table class="quarta">
					<thead>
						<tr>
							<th colspan="6" class="tableTitle">Quarta-feira</th>
						</tr>
						<tr>
							<th>Código</th>
							<th>Disciplina</th>
							<th>Horas Semanais</th>
							<th>Hora de Início</th>
							<th>Status</th>
							<th>Selecionar</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="d" items="${disciplinas }">
							<c:if test="${d.disciplina.diaSemana eq 'quarta-feira' }">
								<tr>
									<td><c:out value="${d.disciplina.codigoDisciplina}"></c:out>
									<td><c:out value="${d.disciplina.disciplina}"></c:out>
									<td><c:out value="${d.disciplina.horasSemanais}"></c:out>
									<td><c:out value="${d.disciplina.horaInicio}"></c:out>
									<td><c:out value="${d.status}"></c:out>
									<td class="status"><input type="submit" id="matricular"
										name="matricular" value="matricular"></td>
								</tr>
							</c:if>
						</c:forEach>
					</tbody>
				</table>
				<table class="quinta">
					<thead>
						<tr>
							<th colspan="6" class="tableTitle">Quinta-feira</th>
						</tr>
						<tr>
							<th>Código</th>
							<th>Disciplina</th>
							<th>Horas Semanais</th>
							<th>Hora de Início</th>
							<th>Status</th>
							<th>Selecionar</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="d" items="${disciplinas }">
							<c:if test="${d.disciplina.diaSemana eq 'quinta-feira' }">
								<tr>
									<td><c:out value="${d.disciplina.codigoDisciplina}"></c:out>
									<td><c:out value="${d.disciplina.disciplina}"></c:out>
									<td><c:out value="${d.disciplina.horasSemanais}"></c:out>
									<td><c:out value="${d.disciplina.horaInicio}"></c:out>
									<td><c:out value="${d.status}"></c:out>
									<td class="status"><input type="submit" id="matricular"
										name="matricular" value="matricular"></td>
								</tr>
							</c:if>
						</c:forEach>
					</tbody>
				</table>
				<table class="sexta">
					<thead>
						<tr>
							<th colspan="6" class="tableTitle">Sexta-feira</th>
						</tr>
						<tr>
							<th>Código</th>
							<th>Disciplina</th>
							<th>Horas Semanais</th>
							<th>Hora de Início</th>
							<th>Status</th>
							<th>Selecionar</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="d" items="${disciplinas }">
							<c:if test="${d.disciplina.diaSemana eq 'sexta-feira' }">
								<tr>
									<td><c:out value="${d.disciplina.codigoDisciplina}"></c:out>
									<td><c:out value="${d.disciplina.disciplina}"></c:out>
									<td><c:out value="${d.disciplina.horasSemanais}"></c:out>
									<td><c:out value="${d.disciplina.horaInicio}"></c:out>
									<td><c:out value="${d.status}"></c:out>
									<td class="status"><input type="submit" id="matricular"
										name="matricular" value="matricular"></td>
								</tr>
							</c:if>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<input type="submit" value="Matricular" class="btnMatricular">
		</form>

	</main>

	<script src="./js/navegacao.js"></script>


</body>
</html>