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
import model.Curso;
import model.Telefone;

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
			
			Curso cu = new Curso();
			Telefone t = new Telefone();

			
			
			a.setCpf(rs.getString("cpf"));
			cu.setCodigo(rs.getInt("codCurso"));
			a.setCurso(cu);
			a.setRa(rs.getString("ra"));
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
//			
//			t.setNumero((rs.getString("telefone1")));
//			a.setTelefone1(t);
//			t.setNumero((rs.getString("telefone2")));
//			a.setTelefone2(t);
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
			Curso cu = new Curso();
			Telefone t = new Telefone();


			a.setCpf(rs.getString("cpf"));
			cu.setCodigo(rs.getInt("codCurso"));
			a.setCurso(cu);
			a.setRa(rs.getString("ra"));
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
			
			a.setAnoIngresso(rs.getInt("anoIngresso"));
			a.setSemestreIngresso(rs.getInt("semestreIngresso"));
			a.setAnoIngresso(rs.getInt("semestreLimite"));
			a.setAnoLimite(rs.getInt("anoLimite"));
//			t.setNumero((rs.getString("telefone1")));
//			a.setTelefone1(t);
//			t.setNumero((rs.getString("telefone2")));
//			a.setTelefone2(t);

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
		cs.setInt(3, a.getCurso().getCodigo());
		cs.setString(4, a.getNome());
		cs.setString(5, a.getNomeSocial());
		cs.setString(6, a.getDataNascimento().toString());
		cs.setString(7, a.getEmail());
		cs.setString(8, a.getDataConclusao2Grau().toString());
		cs.setString(9, a.getInstituicao2Grau());
		cs.setInt(10, a.getPontuacaoVestibular());
		cs.setInt(11, a.getPosicaoVestibular());
		cs.setInt(12, a.getAnoIngresso());
		cs.setInt(13, a.getSemestreIngresso());
		cs.setInt(14, a.getSemestreLimite());
		cs.setString(15, a.getTelefone1().getNumero());
		cs.setString(16, a.getTelefone2().getNumero());
		cs.registerOutParameter(17, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(17);

		cs.close();
		C.close();
		
		return saida;
	}
}
