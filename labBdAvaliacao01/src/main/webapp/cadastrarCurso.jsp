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
            <h1>Curso</h1>
            <h3>Cadastrar / Alterar</h3>
        </div>

        <form action="curso" method="post">

            <table>
                <tr>
                    <td colspan="2">
                        <input type="number" min="0" step="1" id="codigo" name="codigo" placeholder="Codígo">
                    </td>
                    <td colspan="2" class="botao">
                        <input type="submit" id="botao" name="botao" value="Buscar">
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <input type="text" id="nome" name="nome" placeholder="Nome" pattern="[0-9]*">
                    </td>
                    <td>
                        <input type="text" id="sigla" name="sigla" placeholder="Sigla">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="number" min="0" step="1" id="cargaHoraria" name="cargaHoraria"
                            placeholder="Carga Horária">
                    </td>
                    <td colspan="2">
                        <input type="number" min="0" id="notaEnade" name="notaEnade" placeholder="Nota Enade">
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="botao">
                        <input type="submit" id="botao" name="botao" value="Cadastrar">
                    </td>
                    <td colspan="2" class="botao">
                        <input type="submit" id="botao" name="botao" value="Alterar">
                    </td>
                </tr>
            </table>
            <input type="submit" id="botao" name="botao" value="Listar" class="btnListar">
            
        </form>


        <table class="tabelaCurso">
            <thead>
                <th>Código</th>
                <th>Sigla</th>
                <th>Nome</th>
                <th>Carga Horária</th>
                <th>Nota Enade</th>
            </thead>
            <!-- Adicione linhas de dados conforme necessário -->
        </table>
    </main>

    <script src="./js/navegacao.js"></script>

</body>
</html>