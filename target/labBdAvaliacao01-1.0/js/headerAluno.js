// template.js
const template = document.createElement('template');

template.innerHTML = `
<header>
    <div class="logo">
        <a href="index.jsp"><img src="./images/LogoAGIS.png" alt="Logo"></a>
    </div>
    <nav>
        <ul>
            <li><a href="menuAluno.jsp">Matrícula</a></li>
            <li><a href="vizualizarMatriculasAluno.jsp">Disciplinas</a></li>
        </ul>
    </nav>
</header>
`

document.body.appendChild(template.content);
