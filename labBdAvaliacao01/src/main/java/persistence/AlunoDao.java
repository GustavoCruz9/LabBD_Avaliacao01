package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Aluno;

public class AlunoDao implements ICrud<Aluno>, IAluno {

	private GenericDao gDao;

	public AlunoDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public void inserir(Aluno a) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		AlunoDao aDao = new AlunoDao(gDao);
		aDao.iuAluno("I", a);
	}

	@Override
	public void atualizar(Aluno a) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		AlunoDao aDao = new AlunoDao(gDao);
		aDao.iuAluno("U", a);
	}

	@Override
	public Aluno consultar(Aluno a) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "select * from Aluno where cpf = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, a.getCpf());

		ResultSet rs = ps.executeQuery();

		if (rs.next()) {
			a.setCpf(rs.getString("cpf"));
			a.setCodigoCurso(rs.getInt("codigoCurso"));
			a.setRa(rs.getInt("ra"));
			a.setNome(rs.getString("nome"));
			a.setNomeSocial(rs.getString("nomeSocial"));

			Date dataNasc = rs.getDate("dataNascimento");
			a.setDataNascimento(dataNasc.toLocalDate());

			a.setEmail(rs.getString("email"));
			a.setEmailCorporativo(rs.getString("emailCorporativo"));

			Date dataConclusao2Grau = rs.getDate("dataConclusao2Grau");
			a.setDataConclusao2Grau(dataConclusao2Grau.toLocalDate());

			a.setInstituicao2Grau(rs.getString("instituicao2Grau"));
			a.setPontuacaoVestibular(rs.getInt("pontuacaoVestibular"));
			a.setPosicaoVestibular(rs.getInt("PosicaoVestibular"));
			;
			a.setAnoIngresso(rs.getInt("anoIngresso"));
			a.setSemestreIngresso(rs.getInt("semestreIngresso"));
			a.setAnoIngresso(rs.getInt("semestreLimite"));
			a.setAnoLimite(rs.getInt("anoLimite"));
		}

		rs.close();
		rs.close();
		c.close();

		return a;
	}

	@Override
	public List<Aluno> listar() throws SQLException, ClassNotFoundException {
		List<Aluno> alunos = new ArrayList<>();

		Connection c = gDao.getConnection();
		String sql = "select * from Aluno";
		PreparedStatement ps = c.prepareStatement(sql);

		ResultSet rs = ps.executeQuery();

		while (rs.next()) {

			Aluno a = new Aluno();

			a.setCpf(rs.getString("cpf"));
			a.setCodigoCurso(rs.getInt("codigoCurso"));
			a.setRa(rs.getInt("ra"));
			a.setNome(rs.getString("nome"));
			a.setNomeSocial(rs.getString("nomeSocial"));

			Date dataNasc = rs.getDate("dataNascimento");
			a.setDataNascimento(dataNasc.toLocalDate());

			a.setEmail(rs.getString("email"));
			a.setEmailCorporativo(rs.getString("emailCorporativo"));

			Date dataConclusao2Grau = rs.getDate("dataConclusao2Grau");
			a.setDataConclusao2Grau(dataConclusao2Grau.toLocalDate());

			a.setInstituicao2Grau(rs.getString("instituicao2Grau"));
			a.setPontuacaoVestibular(rs.getInt("pontuacaoVestibular"));
			a.setPosicaoVestibular(rs.getInt("PosicaoVestibular"));
			;
			a.setAnoIngresso(rs.getInt("anoIngresso"));
			a.setSemestreIngresso(rs.getInt("semestreIngresso"));
			a.setAnoIngresso(rs.getInt("semestreLimite"));
			a.setAnoLimite(rs.getInt("anoLimite"));

			alunos.add(a);
		}

		rs.close();
		ps.close();
		c.close();

		return alunos;
	}

	@Override
	public String iuAluno(String acao, Aluno a) throws SQLException, ClassNotFoundException {
		Connection C = gDao.getConnection();
		String sql = "{CALL sp_iuAluno (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
		CallableStatement cs = C.prepareCall(sql);
		cs.setString(1, acao);
		cs.setString(2, a.getCpf());
		cs.setInt(3, a.getRa());
		cs.setInt(4, a.getCodigoCurso());
		cs.setString(5, a.getNome());
		cs.setString(6, a.getNomeSocial());
		cs.setString(7, a.getDataNascimento().toString());
		cs.setString(8, a.getEmail());
		cs.setString(9, a.getEmailCorporativo());
		cs.setString(10, a.getDataConclusao2Grau().toString());
		cs.setString(11, a.getInstituicao2Grau());
		cs.setInt(11, a.getPontuacaoVestibular());
		cs.setInt(12, a.getPosicaoVestibular());
		cs.setInt(13, a.getAnoIngresso());
		cs.setInt(14, a.getSemestreIngresso());
		cs.setInt(15, a.getSemestreLimite());
		cs.setInt(16, a.getAnoLimite());
		cs.registerOutParameter(17, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(7);

		cs.close();
		C.close();
		
		return saida;
	}
}
