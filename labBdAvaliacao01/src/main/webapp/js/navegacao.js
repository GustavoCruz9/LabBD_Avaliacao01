var urlsAluno = {
    "cadastrar": "menuSecretaria.jsp",
    "alterar": "menuSecretaria.jsp",
    "vizualizar": "vizualizarAlunos.jsp",
    "telefone" : "cadastrarTelefone.jsp"
};

// Objeto para mapear opções selecionadas para URLs de selectDisciplina
var urlsDisciplina = {
    "cadastrar": "cadastrarDisciplina.jsp",
    "alterar": "cadastrarDisciplina.jsp",
    "vizualizar": "index.jsp"
};

var urlsMatricula = {
    "cadastrar": "cadastrarMatricula.jsp",
    "vizualizar": "vizualizarMatricula.jsp"
}

// Função para redirecionar com base no valor selecionado
function redirecionar(selectedValue, urls) {
    var url = urls[selectedValue];
    if (url) {
        window.location.href = url;
    } else {
        console.error("URL não encontrada para a opção selecionada: " + selectedValue);
    }
}

// Manipulador de eventos para selectAluno
document.getElementById("selectAluno").addEventListener("change", function () {
    var selectedValue = this.value;
    redirecionar(selectedValue, urlsAluno);
});

// Manipulador de eventos para selectDisciplina
document.getElementById("selectDisciplina").addEventListener("change", function () {
    var selectedValue = this.value;
    redirecionar(selectedValue, urlsDisciplina);
});

document.getElementById("selectMatricula").addEventListener("change", function () {
    var selectedValue = this.value;
    redirecionar(selectedValue, urlsMatricula);
});