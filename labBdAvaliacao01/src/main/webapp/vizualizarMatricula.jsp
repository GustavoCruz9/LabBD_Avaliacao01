<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema AGIS - Secretaria Acadêmica</title>
    <link rel="stylesheet" href="./css/styleSecretariaMatricula.css">
</head>

<body>

    <script src="./js/header.js"></script>

    <main>
        <h1>Vizualizar Matrícula</h1>

        <form action="vizualizarMatricula" method="post">
            <div class="cpfMatricula">
                <div class="pesquisaCpf">
                    <input type="text" name="pesquisaCpf" id="pesquisaCpf" placeholder="CPF" class="inputCPF">
                    <input type="submit" value="🔎" class="btnCPF">
                </div>
            </div>

            <table class="vizualizarMatricula">
                <thead>
                    <tr>
                        <th colspan="6" class="tableTitle">
                            Matrícula
                        </th>
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
                    <tr>
                        <td>001</td>
                        <td>Teste 1</td>
                        <td>4</td>
                        <td>08:00</td>
                        <td>Pendente</td>
                    </tr>
                    <tr>
                        <td>002</td>
                        <td>Teste 2</td>
                        <td>3</td>
                        <td>09:30</td>
                        <td>Reprovado</td>
                    </tr>
                </tbody>
            </table>


        </form>
    </main>

    <script src="./js/navegacao.js"></script>

</body>
</html>