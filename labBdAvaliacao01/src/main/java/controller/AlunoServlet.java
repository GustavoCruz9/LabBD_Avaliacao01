package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Aluno;
import model.Curso;
import persistence.AlunoDao;
import persistence.GenericDao;

@WebServlet("/aluno")
public class AlunoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public AlunoServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String cmd = request.getParameter("botao");
		String codCurso =request.getParameter("codCurso");
		String cpf = request.getParameter("cpf");
		String nome = request.getParameter("nome");
		String dataNascimento = request.getParameter("dataNascimento");
		String nomeSocial = request.getParameter("nomeSocial");
		String email = request.getParameter("email");
		String dataConclusao2Grau = request.getParameter("dataConclusao2Grau");
		String instituicaoConclusao2Grau = request.getParameter("instituicaoConclusao2Grau");
		String pontuacaoVestibular = request.getParameter("pontuacaoVestibular");
		String posicaoVestibular = request.getParameter("posicaoVestibular");
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

		String saida = "";
		String erro = "";
		
		Aluno a = new Aluno();
		List<Aluno> alunos = new ArrayList<>();
		
		if(cmd.contains("Cadastrar") || cmd.contains("Alterar")){
			
			Curso c = new Curso();
			
			c.setCodigo(Integer.parseInt(codCurso));
			a.setCurso(c);
			
			a.setCpf(cpf);
			a.setNome(nome);
			
			a.setAnoIngresso(LocalDate.now().getYear());
		
			int mesAtual = LocalDate.now().getMonthValue();
			
	        if (mesAtual >= 1 && mesAtual <= 6) {
	            a.setSemestreIngresso(1);
	            a.setSemestreLimite(1);
	        } else {
	        	a.setSemestreIngresso(2);
	        	a.setSemestreLimite(2);
	        }
						
			LocalDate dataNascLocalDate = LocalDate.parse(dataNascimento, formatter);
			a.setDataNascimento(dataNascLocalDate);
			
			a.setNomeSocial(nomeSocial);
			a.setEmail(email);
			
			LocalDate dataConclusao2GrauLocalDate = LocalDate.parse(dataConclusao2Grau, formatter);
			a.setDataConclusao2Grau(dataConclusao2GrauLocalDate);
			
			a.setInstituicao2Grau(instituicaoConclusao2Grau);
			
			a.setPontuacaoVestibular(Integer.parseInt(pontuacaoVestibular));
			a.setPosicaoVestibular(Integer.parseInt(posicaoVestibular));
			
//			Telefone [] telefones = new Telefone[2];
//			Telefone tel = new Telefone();
//			tel.setNumero(telefone1);
//			
//			telefones[0] = tel;
//			
//			tel = new Telefone();
//			tel.setNumero(telefone2);
//			
//			telefones[1] = tel;
//			a.setTelefones(telefones);
//			

			
		}else if(cmd.contains("Buscar")) {
			a.setCpf(cpf);
		}
		
		try {
			if(cmd.contains("Cadastrar")) {
				saida = cadastrarAluno(a);
				a = null;
			}
			if(cmd.contains("Alterar")) {
				saida = atualizarAluno(a);
				a = null;
			}
			if(cmd.contains("Buscar")) {
				a = buscarAluno(a);
			}
			if(cmd.contains("Listar")) {
				alunos = listarAlunos();
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		}finally {
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("aluno", a);
			request.setAttribute("alunos", alunos);
			
			if(cmd.contains("Listar")) {
				RequestDispatcher rd = request.getRequestDispatcher("vizualizarAlunos.jsp");
				rd.forward(request, response);
			}else {
				RequestDispatcher rd = request.getRequestDispatcher("menuSecretaria.jsp");
				rd.forward(request, response);
			}	
		}
	}

	private String cadastrarAluno(Aluno a) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		AlunoDao aDao = new AlunoDao(gDao);	
		String saida = aDao.iuAluno("I", a);
		return saida;
	}

	private String atualizarAluno(Aluno a) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		AlunoDao aDao = new AlunoDao(gDao);	
		String saida = aDao.iuAluno("U", a);
		return saida;
	}

	private Aluno buscarAluno(Aluno a) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		AlunoDao aDao = new AlunoDao(gDao);
		a = aDao.consultar(a);
		return a;
	}

	private List<Aluno> listarAlunos() throws SQLException, ClassNotFoundException {
		List<Aluno> alunos = new ArrayList<>();
		GenericDao gDao = new GenericDao();
		AlunoDao aDao = new AlunoDao(gDao);	
		alunos = aDao.listar();
		return alunos;
	}

}
