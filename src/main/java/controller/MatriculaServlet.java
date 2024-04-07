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
		String cmd = request.getParameter("botao");
		String pesquisaRa = request.getParameter("pesquisaRa");
		Aluno a = new Aluno();

		a.setRa(pesquisaRa);
		List<Matricula> disciplinas = new ArrayList<>();

		a.setRa(pesquisaRa);

		String saida = "";
		String erro = "";

		try {

			if (verificaRa(a) == 1) {
				disciplinas = listarDisciplinas(a);
				if (disciplinas.isEmpty()) {
					erro = "Aluno concluiu todas as disciplinas de seu curso";
				}
			} else {
				erro = "RA inválido";
			}

		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("disciplinas", disciplinas);
			request.setAttribute("pesquisaRa", pesquisaRa);

			if (cmd.contains("✔️")) {
				RequestDispatcher rd = request.getRequestDispatcher("menuAluno.jsp");
				rd.forward(request, response);
			} else {
				RequestDispatcher rd = request.getRequestDispatcher("cadastrarMatricula.jsp");
				rd.forward(request, response);
			}

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

		String aux = "";

		if (!cmd.contains("🔍") && !cmd.contains("✔️") && !cmd.contains("🔎") && !cmd.contains("☑️")) {

			if (cmd.contains(".")) {
				aux = cmd.substring(0, cmd.length() - 1);
				d.setCodigoDisciplina(Integer.parseInt(aux));
			} else {
				d.setCodigoDisciplina(Integer.parseInt(cmd));
			}

			m.setAluno(a);
			m.setDisciplina(d);
		}

		try {
			if (cmd.contains("🔍") || cmd.contains("☑️")) {

				matriculas = listarMatriculas(a);
				if (matriculas.isEmpty()) {
					erro = "O aluno do Ra " + pesquisaRa + " não possui matriculas";
				}

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
			}
			if (cmd.contains("🔎")
					|| (!cmd.contains(".")) && !cmd.contains("🔍") && !cmd.contains("☑️") && !cmd.contains("✔️")) {
				RequestDispatcher rd = request.getRequestDispatcher("cadastrarMatricula.jsp");
				rd.forward(request, response);
			}
			if (cmd.contains("☑️")) {
				RequestDispatcher rd = request.getRequestDispatcher("vizualizarMatriculasAluno.jsp");
				rd.forward(request, response);
			}
			if (cmd.contains(".") || cmd.contains("✔️")) {
				RequestDispatcher rd = request.getRequestDispatcher("menuAluno.jsp");
				rd.forward(request, response);
			}
//			RequestDispatcher rd = request.getRequestDispatcher("cadastrarMatricula.jsp");
//			rd.forward(request, response);

		}

	}

	private int verificaRa(Aluno a) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		MatriculaDao mDao = new MatriculaDao(gDao);
		return mDao.verificaRa(a);
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
