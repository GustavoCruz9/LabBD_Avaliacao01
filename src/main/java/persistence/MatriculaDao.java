package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Aluno;
import model.Disciplina;
import model.Matricula;

public class MatriculaDao implements IMatricula<Matricula> {

	private GenericDao gDao;

	public MatriculaDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public List<Matricula> listarDisciplinas(Aluno a) throws SQLException, ClassNotFoundException {

		ArrayList<Matricula> disciplinas = new ArrayList<>();

		Connection c = gDao.getConnection();
		String sql = """
				select diaSemana, codDisciplina, disciplina, horasSemanais,
				horaInicio, statusMatricula
				from fn_popularMatricula( ? )
				""";
		PreparedStatement ps = c.prepareStatement(sql);

		ps.setString(1, a.getRa());

		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			Matricula m = new Matricula();
			Disciplina d = new Disciplina();

			d.setDiaSemana(rs.getString("diaSemana").toLowerCase());
			d.setCodigoDisciplina(rs.getInt("codDisciplina"));
			d.setDisciplina(rs.getString("disciplina"));
			d.setHorasSemanais(rs.getTime("horasSemanais").toLocalTime());
			d.setHoraInicio(rs.getTime("horaInicio").toLocalTime());
			m.setDisciplina(d);
			m.setStatus(rs.getString("statusMatricula"));

			disciplinas.add(m);
		}

		return disciplinas;

	}

	@Override
	public List<Matricula> listarMatriculas(Aluno a) throws SQLException, ClassNotFoundException {
		ArrayList<Matricula> matriculas = new ArrayList<>();

		Connection c = gDao.getConnection();
		String sql = """
					select d.codDisciplina, d.nome, d.horasSemanais, d.horaInicio, m.statusMatricula
					from Disciplina d, Matricula m, Aluno a
					where a.ra = ? and d.codDisciplina = m.codDisciplina and m.cpf = a.cpf
				""";
		PreparedStatement ps = c.prepareStatement(sql);

		ps.setString(1, a.getRa());

		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			Matricula m = new Matricula();
			Disciplina d = new Disciplina();

			d.setCodigoDisciplina(rs.getInt("codDisciplina"));
			d.setDisciplina(rs.getString("nome"));
			d.setHorasSemanais(rs.getTime("horasSemanais").toLocalTime());
			d.setHoraInicio(rs.getTime("horaInicio").toLocalTime());
			m.setDisciplina(d);
			m.setStatus(rs.getString("statusMatricula"));

			matriculas.add(m);
		}

		return matriculas;
	}

	@Override
	public String iMatricula(Matricula m) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_cadastrarMatricula ( ?, ?, ? )}";
		CallableStatement cs = c.prepareCall(sql);

		cs.setString(1, m.getAluno().getRa());
		cs.setInt(2, m.getDisciplina().getCodigoDisciplina());
		cs.registerOutParameter(3, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(3);

		cs.close();
		c.close();

		return saida;
	}
	
	@Override
	public int verificaRa(Aluno a) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_validaRa ( ?, ? )}";
		CallableStatement cs = c.prepareCall(sql);

		cs.setString(1, a.getRa());
		cs.registerOutParameter(2, Types.VARCHAR);

		cs.execute();
		int saida = cs.getInt(2);

		cs.close();
		c.close();

		return saida;
	}

}
