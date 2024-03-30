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

        <form action="tabelaDiasSemana" method="post" class="formMatricula">
            <div class="cpfMatricula">
                <div class="pesquisaCpf">
                    <input type="text" name="pesquisaRa" id="pesquisaRa" placeholder="RA" class="inputCPF">
                    <input type="submit" value="🔎" class="btnCPF">
                </div>
            </div>

            <div class="diasSemana">
                <table class="segunda">
                    <thead>
                        <tr>
                            <th colspan="6" class="tableTitle">
                                Segunda-feira
                            </th>
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
                        <tr>
                            <td>001</td>
                            <td>Matemática Discreta</td>
                            <td>4</td>
                            <td>08:00</td>
                            <td>Pendente</td>
                            <td class="status"><input type="checkbox"></td>
                        </tr>
                        <tr>
                            <td>002</td>
                            <td>ALgoritmo e logica de programação</td>
                            <td>3</td>
                            <td>09:30</td>
                            <td>Reprovado</td>
                            <td class="status"><input type="checkbox"></td>
                        </tr>
                        <tr>
                            <td>003</td>
                            <td>História</td>
                            <td>2</td>
                            <td>10:45</td>
                            <td>Não Matriculado</td>
                            <td class="status"><input type="checkbox"></td>
                        </tr>
                        <tr>
                            <td>004</td>
                            <td>Ciências</td>
                            <td>3</td>
                            <td>13:00</td>
                            <td>Pendente</td>
                            <td class="status"><input type="checkbox"></td>
                        </tr>
                        <tr>
                            <td>005</td>
                            <td>Inglês</td>
                            <td>2</td>
                            <td>14:30</td>
                            <td>Não Matriculado</td>
                            <td class="status"><input type="checkbox"></td>
                        </tr>
                    </tbody>
                </table>
                <table class="terca">
                    <thead>
                        <tr>
                            <th colspan="6" class="tableTitle">
                                Terca-feira
                            </th>
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
                    </tbody>
                </table>
                <table class="quarta">
                    <thead>
                        <tr>
                            <th colspan="6" class="tableTitle">
                                Quarta-feira
                            </th>
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
                    </tbody>
                </table>
                <table class="quinta">
                    <thead>
                        <tr>
                            <th colspan="6" class="tableTitle">
                                Quinta-feira
                            </th>
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
                    </tbody>
                </table>
                <table class="sexta">
                    <thead>
                        <tr>
                            <th colspan="6" class="tableTitle">
                                Sexta-feira
                            </th>
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
                    </tbody>
                </table>
            </div>

            <input type="submit" value="Matricular" class="btnMatricular">
        </form>

    </main>

    <script src="./js/navegacao.js"></script>


</body>
</html>