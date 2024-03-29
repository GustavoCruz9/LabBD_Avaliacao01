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

		<form action="aluno" method="post">

			<table>
				<tr>
					<td colspan="3"><input type="number" id="cpf" name="cpf"
						placeholder="CPF" required></td>
					<td><input type="submit" id="buscar" name="buscar"
						value="Buscar"></td>
				</tr>
				<tr>
					<td colspan="4"><input type="text" id="nome" name="nome"
						placeholder="Nome" required></td>
				</tr>
				<tr>
					<td colspan="1">
						<div class="datas">
							<label for="dataNascimento">Data de Nascimento</label> 
							<input type="date" id="dataNascimento" name="dataNascimento" required>
						</div>
					</td>
					<td colspan="3"><input type="text" id="nomeSocial"
						name="nomeSocial" placeholder="Nome Social"></td>
				</tr>
				<tr>
					<td colspan="2"><input type="text" id="email" name="email"
						placeholder="E-mail" required></td>
					<td colspan="2"> <input type="text" id="codCurso" name="codCurso" placeholder="Código do Curso" required> </td>
				</tr>
				<tr>
					<td colspan="1">
						<div class="datas">
							<label for="dataConclusao2Grau">Data de Conclusão</label> <input
								type="date" id="dataConclusao2Grau" name="dataConclusao2Grau"
								required>
						</div>
					</td>
					<td colspan="3"><input type="text"
						id="instituicaoConclusao2Grau" name="instituicaoConclusao2Grau"
						placeholder="Instituição de Conclusão 2º Grau" required></td>
				</tr>
				<tr>
					<td colspan="2"><input type="number" id="telefone1"
						name="telefone1" placeholder="Telefone" required></td>
					<td colspan="2"><input type="number" id="telefone2"
						name="telefone2" placeholder="Telefone"></td>
				</tr>
				<tr>
					<td colspan="2"><input type="submit" id="cadastrar"
						name="cadastrar" value="Cadastrar"></td>
					<td colspan="2"><input type="submit" id="alterar"
						name="alterar" value="Alterar"></td>
				</tr>
			</table>

		</form>

	</main>

	<script src="./js/navegacao.js"></script>

</body>
</html>