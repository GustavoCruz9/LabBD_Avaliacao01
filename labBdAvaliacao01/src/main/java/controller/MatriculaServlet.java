package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Aluno;
import model.Disciplina;
import model.Matricula;
import persistence.GenericDao;
import persistence.MatriculaDao;

@WebServlet("/matricula")
public class MatriculaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public MatriculaServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String pesquisaRa = request.getParameter("pesquisaRa");
		Aluno a = new Aluno();

		a.setRa(pesquisaRa);
		List<Matricula> disciplinas = new ArrayList<>();

		a.setRa(pesquisaRa);

		String saida = "";
		String erro = "";

		try {

			disciplinas = listarDisciplinas(a);

		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("disciplinas", disciplinas);
			request.setAttribute("pesquisaRa", pesquisaRa);

			RequestDispatcher rd = request.getRequestDispatcher("cadastrarMatricula.jsp");
			rd.forward(request, response);
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String cmd = request.getParameter("botao");
		String pesquisaRa = request.getParameter("pesquisaRa");

		String saida = "";
		String erro = "";

		List<Matricula> disciplinas = new ArrayList<>();
		List<Matricula> matriculas = new ArrayList<>();

		Aluno a = new Aluno();
		Matricula m = new Matricula();
		Disciplina d = new Disciplina();

		a.setRa(pesquisaRa);
		
		if (!cmd.contains("🔍")) {
			d.setCodigoDisciplina(Integer.parseInt(cmd));

			m.setAluno(a);
			m.setDisciplina(d);
		}

		try {
			if (cmd.contains("🔍")) {
				matriculas = listarMatriculas(a);
			} else {
				saida = cadastrarMatricula(m);
				disciplinas = listarDisciplinas(a);
			}

		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
			
			try {
				disciplinas = listarDisciplinas(a);
			} catch (SQLException | ClassNotFoundException e1) {
				erro = e1.getMessage();
			} 
			
		} finally {
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("disciplinas", disciplinas);
			request.setAttribute("matriculas", matriculas);

			if (cmd.contains("🔍")) {
				RequestDispatcher rd = request.getRequestDispatcher("vizualizarMatricula.jsp");
				rd.forward(request, response);
			} else {
				RequestDispatcher rd = request.getRequestDispatcher("cadastrarMatricula.jsp");
				rd.forward(request, response);
			}
		}

	}

	private String cadastrarMatricula(Matricula m) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		MatriculaDao mDao = new MatriculaDao(gDao);
		return mDao.iMatricula(m);
	}

	private List<Matricula> listarMatriculas(Aluno a) throws SQLException, ClassNotFoundException {
		List<Matricula> matriculas = new ArrayList<>();
		GenericDao gDao = new GenericDao();
		MatriculaDao mDao = new MatriculaDao(gDao);
		matriculas = mDao.listarMatriculas(a);
		return matriculas;
	}

	private List<Matricula> listarDisciplinas(Aluno a) throws SQLException, ClassNotFoundException {
		List<Matricula> disciplinas = new ArrayList<>();
		GenericDao gDao = new GenericDao();
		MatriculaDao mDao = new MatriculaDao(gDao);
		disciplinas = mDao.listarDisciplinas(a);
		return disciplinas;
	}
}
