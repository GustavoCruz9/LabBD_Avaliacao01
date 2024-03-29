// template.js
const template = document.createElement('template');

template.innerHTML = `
    <header>
        <div class="logo">
            <a href="./index.jsp"><img src="./images/LogoAGIS.png" alt="Logo"></a>
        </div>
        <nav>
            <ul>
                <li>
                    <select name="selectAluno" id="selectAluno" class="">
                        <option disabled selected>&nbsp;&nbsp; &nbsp;Aluno</option>
                        <option value="cadastrar"><a href="#">Cadastrar</a></option>
                        <option value="alterar"><a href="#">Alterar</a></option>
                        <option value="vizualizar"><a href="#">Vizualizar</a></option>
                    </select>
                </li>
                <li>
                    <select name="selectDisciplina" id="selectDisciplina" class="">
                        <option disabled selected>Disciplina</option>
                        <option value="cadastrar"><a href="#">Cadastrar</a></option>
                        <option value="alterar"><a href="#">Alterar</a></option>
                        <option value="vizualizar"><a href="#">Vizualizar</a></option>
                    </select>
                </li>
                <li>
                    <select name="selectMatricula" id="selectMatricula">
                        <option disabled selected>Matrícula</option>
                        <option value="cadastrar"><a href="#">Cadastrar</a></option>
                        <option value="vizualizar"><a href="#">Vizualizar</a></option>
                    </select>
                </li>
                <li>
                    <a href="cadastrarCurso.jsp" class="btnCurso">Curso</a>
                </li>
            </ul>
        </nav>
    </header>
`;

document.body.appendChild(template.content);
