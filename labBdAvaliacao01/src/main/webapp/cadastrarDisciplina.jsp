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

        <div class="titulo">
            <h1>Disciplina</h1>
            <h3>Cadastrar / Alterar</h3>
        </div>

        <form action="disciplina" method="post">
            <table>
                <tr>
                    <td colspan="2">
                        <input type="number" id="codigo" name="codigo" placeholder="Código da Disciplina">
                    </td>
                    <td colspan="2">
                        <input type="submit" id="buscar" name="buscar" value="Buscar">
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <input type="text" id="nome" name="nome" placeholder="Nome">
                    </td>
                    <td>
                        <input type="number" id="codigoCurso" name="codigoCurso" placeholder="Código do Curso">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="number" id="horasSemanais" name="horasSemanais" placeholder="Horas Semanais">
                    </td>
                    <td colspan="2">
                        <label>Inicio da Aula:</label>
                        <input type="time" id="horaInicio" name="horaInicio">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" id="botao" name="botao" value="Cadastrar">
                    </td>
                    <td colspan="2">
                        <input type="submit" id="botao" name="botao" value="Alterar">
                    </td>
                </tr>
            </table>
        </form>
    </main>
    
    <script src="./js/navegacao.js"></script>

</body>
</html>