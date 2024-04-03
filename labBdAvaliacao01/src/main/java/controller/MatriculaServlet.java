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
import model.Matricula;
import persistence.GenericDao;
import persistence.MatriculaDao;

@WebServlet("/matricula")
public class MatriculaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public MatriculaServlet() {
    	super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String cmd = request.getParameter("botao");
		String pesquisaRa = request.getParameter("pesquisaRa");
//		String pesquisaRaVizualizar = request.getParameter("pesquisaRaVizualizar");

		String saida = "";
		String erro = "";
		
		List<Matricula> disciplinas = new ArrayList<>();
		List<Matricula> matriculas = new ArrayList<>();
		
		Aluno a = new Aluno();
		
		a.setRa(pesquisaRa);
		
//		if(cmd.contains("🔎")) {
//			
//		}
//		if(cmd.contains("🔍")) {
//			a.setRa(pesquisaRaVizualizar);
//		}
		
		try {
			if(cmd.contains("🔎")) {
				disciplinas = listarDisciplinas(a);
			}
			if(cmd.contains("🔍")) {
				matriculas = listarMatricular(a);
			}
			
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("disciplinas",	disciplinas);
			request.setAttribute("matriculas",	matriculas);
			
			if(cmd.contains("🔎")) {
				RequestDispatcher rd = request.getRequestDispatcher("cadastrarMatricula.jsp");
				rd.forward(request, response);
			}
			if(cmd.contains("🔍")) {
				RequestDispatcher rd = request.getRequestDispatcher("vizualizarMatricula.jsp");
				rd.forward(request, response);
			}
		}
		
	}

	private List<Matricula> listarMatricular(Aluno a) throws SQLException, ClassNotFoundException {
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
