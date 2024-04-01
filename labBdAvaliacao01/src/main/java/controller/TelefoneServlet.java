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
import model.Telefone;
import persistence.GenericDao;
import persistence.TelefoneDao;

@WebServlet("/telefone")
public class TelefoneServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public TelefoneServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String cmd = request.getParameter("botao");
		String cpf = request.getParameter("cpf");
		String telefoneNovo = request.getParameter("telefoneNovo");
		String telefoneAntigo = request.getParameter("telefoneAntigo");

		String saida = "";
		String erro = "";

		Aluno a = new Aluno();
		Telefone tel = new Telefone();
		List<Aluno> alunos = new ArrayList<>();
		List<Telefone> telefones = new ArrayList<>();

		tel.setNumero(telefoneNovo);
		telefones.add(tel);
		a.setTelefones(telefones);
		a.setCpf(cpf);

		if (cmd.contains("Confirmar")) {
			tel = new Telefone();
			tel.setNumero(telefoneAntigo);
		}

		try {
			if (cmd.contains("Cadastrar")) {
				saida = cadastrarTelefone(a, tel);
				tel = null;
				a = null;
			}
			if (cmd.contains("Confirmar")) {
				saida = atualizarTelefone(a, tel);
				tel = null;
				a = null;
			}
			if (cmd.contains("Excluir")) {
				saida = excluirTelefone(a, tel);
				tel = null;
				a = null;
			}
			if (cmd.contains("Listar")) {
				alunos = listarTelefones();
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("aluno", a);
			request.setAttribute("alunos", alunos);

			RequestDispatcher rd = request.getRequestDispatcher("cadastrarTelefone.jsp");
			rd.forward(request, response);

		}
	}

	private String cadastrarTelefone(Aluno a, Telefone telefoneAntigo) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		TelefoneDao tDao = new TelefoneDao(gDao);
		String saida = tDao.iudTelefone("I", a, telefoneAntigo);
		return saida;
	}

	private String atualizarTelefone(Aluno a, Telefone telefoneAntigo) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		TelefoneDao tDao = new TelefoneDao(gDao);
		String saida = tDao.iudTelefone("U", a, telefoneAntigo);
		return saida;
	}

	private String excluirTelefone(Aluno a, Telefone telefoneAntigo) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		TelefoneDao tDao = new TelefoneDao(gDao);
		String saida = tDao.iudTelefone("D", a, telefoneAntigo);
		return saida;
	}

	private List<Aluno> listarTelefones() throws SQLException, ClassNotFoundException {
		List<Aluno> alunos = new ArrayList<>();
		GenericDao gDao = new GenericDao();
		TelefoneDao tDao = new TelefoneDao(gDao);
		alunos = tDao.listar();
		return alunos;
	}

}
