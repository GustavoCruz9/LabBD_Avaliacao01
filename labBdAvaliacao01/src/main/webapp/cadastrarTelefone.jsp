<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sistema AGIS - Secretaria Acadêmica</title>
<link rel="stylesheet" href="./css/styleSecretariaDisicplina.css">
<script type="text/javascript"> 
	function ApareceBotaoAntigo() {
		var divTelefoneAntigo = document.getElementById("divTelefoneAntigo");
		divTelefoneAntigo.style.display = 'block';
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
					<td colspan="4"><input type="number" id="cpf" name="cpf" placeholder="CPF"></td>
				</tr>
				<tr>
					<td colspan="4"><input type="text" id="numero" name="numero" placeholder="Número de Telefone"></td>
				</tr>
				<tr id="divTelefoneAntigo" style="display: none;">
					<td colspan="4">
						<input type="text" id="numeroAntigoInput" name="numeroAntigo" placeholder="Número de Telefone Antigo">
						<input type="submit" id="botaoConfirmar" name="botaoConfirmar" value="Confirmar">
					</td>
				</tr>	
				<tr>
					<td colspan="2"><input type="submit" id="botao" name="botao" value="Cadastrar"></td>
					<td colspan="2">
						<button class="" type="button" onclick="ApareceBotaoAntigo()">
							Alterar
						</button>
					</td>
					<td colspan="4"><input type="submit" id="botao" name="botao" value="Excluir"></td>
				</tr>
			</table>
		</form>
	</main>
	<script src="./js/navegacao.js"></script>
</body>
</html>
