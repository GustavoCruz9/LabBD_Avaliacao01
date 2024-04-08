<section align="center">
<h2><a name="About_labBdAvaliacao01"></a>Projeto Faculdade AGIS</h2><a name="About_labBdAvaliacao01"></a>
<h3>Desenvolvido por Guilherme do carmo Silveira e Gustavo da Cruz Santos </h3></section>
      </div>
	  <div>
		<h3>Escopo:</h3>
		<p>Um sistema acadêmico de uma faculdade, chamado AGIS, oferece diversas funcionalidades e 
seus usuários são alunos, professores e funcionários da secretaria acadêmica.

<br>

Apesar desses perfis, nesse momento, por se tratar de protótipo, o desenvolvimento não 
considera a necessidade de login para acesso seguro das áreas de cada usuário.

<br>

A secretaria acadêmica necessita cadastrar os alunos que ingressam na faculdade pelo 
vestibular. São diversos dados que devem ser incluídos no dia da primeira matrícula, como CPF, 
que deve ser válido de acordo com a legislação brasileira1, nome, nome social (Não 
obrigatório), data de nascimento2, telefones de contato, e-mail pessoal, e-mail corporativo, 
data de conclusão do segundo grau, instituição de conclusão do segundo grau, pontuação no 
vestibular, posição no vestibular, ano de ingresso, semestre de ingresso, semestre e ano limite 
de graduação. Todos os alunos devem receber um RA.

<br>

Todo aluno está vinculado a apenas 1 curso e 1 turno (Que devem ser preenchidos na ficha do 
aluno). 

<br>

A faculdade tem diversos cursos, que são registrados por 1 código único numérico de 0 a 100, 
um nome, uma carga horária, uma sigla para uso interno e a última nota da participação no 
ENADE (De acordo com o regimento do Ministério da Educação do Brasil)

<br>

Os cursos têm entre 40 e 50 disciplinas, que são registradas por um código numérico iniciado 
em 1001, um nome, quantidade de horas semanais. Cada disciplina tem entre 5 e 15 conteúdos 
que serão ministrados ao longo de um semestre. 

<br>

Cursos podem ter disciplinas semelhantes, mas não exatamente iguais, pois podem se 
diferenciar no nome, na carga horária ou no conteúdo. As disciplinas estão presentes em um 
curso, em um determinado horário

<br>

Todos os alunos devem poder se matricular em 1 ou mais disciplinas do seu curso para serem 
cursadas ao longo de um semestre. O processo de matrícula5 significa que o aluno deve 
selecionar, dentro de um rol de disciplinas, as que ele pretende cursar. Considere que o aluno 
pode, ou não, já ter cursados disciplinas em semestres anteriores, com ou sem aprovação. 
Considere que um aluno não pode fazer disciplinas cujos horários conflitem. Considere 
também, que matriculas são feitas semestralmente e o sistema deve estar preparado para isso.

<br>

Os horários disponíveis são (Outras possibilidades não estão contempladas):

<br>

Iniciando às 13:00 com 4 aulas de duração (Até 16h30)<br>
Iniciando às 13:00 com 2 aulas de duração (Até 14h40)<br>
Iniciando às 14:50 com 4 aulas de duração (Até 18h20)<br>
Iniciando às 14:50 com 2 aulas de duração (Até 16h30)<br>
Iniciando às 16:40 com 2 aulas de duração (Até 18h20)<br><br>

1 Deve-se fazer uma procedure que valide o CPF antes da inserção 2 Deve-se fazer uma procedure que valide uma idade igual
ou superior a 16 anos antes da inserção 3 A data limite de graduação deve ser a saída de uma procedure que calcula 5 anos do ingresso

<br>

4 O RA inicia com o ano de ingresso, seguido pelo semestre de ingresso e 4 números aleatórios, deve 
ser gerado por uma procedure para inserção.

<br>

5 A inserção das matrículas deve ter suas regras controladas por uma procedure e só ser confirmada 
caso não haja nenhuma restrição.

<br>

<h3>Observações:</h3>

<br>

- As telas curso e Disciplina não estão em funcionamento, pois foram inseridas diretamente pelos desenvolvedores no banco de dados.

</p>
<br>
	  </div>
    </div>
    <div class="clear">
      <hr/>
    </div>
    <div id="footer">
      <div class="xright" align="center">
        Copyright &#169;      Guilherme do Carmo Silveira Gustavo da Cruz Santos <br> 2024..      </div>
      <div class="clear">
        <hr/>
      </div>
    </div>
  </body>
</html>
