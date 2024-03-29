// template.js
const template = document.createElement('template');

template.innerHTML = `
<header>
    <div class="logo">
        <a href="index.jsp"><img src="./images/LogoAGIS.png" alt="Logo"></a>
    </div>
    <nav>
        <ul>
            <li><a href="#">Matrícula</a></li>
            <li><a href="#">Disciplinas</a></li>
        </ul>
    </nav>
</header>
`

document.body.appendChild(template.content);
