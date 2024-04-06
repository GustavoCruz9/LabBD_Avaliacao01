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

public class AlunoDao implements IConsultar<Aluno>, IAluno, IListar<Aluno> {

	private GenericDao gDao;

	public AlunoDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public Aluno consultar(Aluno a) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = """
				select cpf, codCurso, ra, nome, nomeSocial, dataNascimento, email, emailCorporativo,
				dataConclusao2Grau, instituicao2Grau, pontuacaoVestibular,posicaoVestibular
				from Aluno where cpf = ?
				""";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, a.getCpf());

		ResultSet rs = ps.executeQuery();
		Curso cu = new Curso();

		while (rs.next()) {

			a.setCpf(rs.getString("cpf"));
			cu.setCodigo(rs.getInt("codCurso"));
			a.setCurso(cu);
			a.setRa(rs.getString("ra"));
			a.setNome(rs.getString("nome"));
			a.setNomeSocial(rs.getString("nomeSocial"));

			Date dataNasc = rs.getDate("dataNascimento");
			a.setDataNascimento(dataNasc.toLocalDate());

			a.setEmail(rs.getString("email"));

			Date dataConclusao2Grau = rs.getDate("dataConclusao2Grau");
			a.setDataConclusao2Grau(dataConclusao2Grau.toLocalDate());

			a.setInstituicao2Grau(rs.getString("instituicao2Grau"));
			a.setPontuacaoVestibular(rs.getInt("pontuacaoVestibular"));
			a.setPosicaoVestibular(rs.getInt("PosicaoVestibular"));

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
		String sql = """
				SELECT a.cpf, a.codCurso, a.ra, a.nome, a.nomeSocial, a.dataNascimento, a.email, a.emailCorporativo, 
				a.dataConclusao2Grau, a.instituicao2Grau, a.pontuacaoVestibular, a.posicaoVestibular, a.anoIngresso, 
				a.semestreIngresso, a.anoIngresso, a.anoLimite, a.semestreLimite,
				(SELECT t1.numero FROM Telefone t1 WHERE t1.cpf = a.cpf AND t1.numero IS NOT NULL ORDER BY t1.numero OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY) AS telefone1,
				(SELECT t2.numero FROM Telefone t2 WHERE t2.cpf = a.cpf AND t2.numero IS NOT NULL ORDER BY t2.numero OFFSET 1 ROWS FETCH NEXT 1 ROW ONLY) AS telefone2
				FROM Aluno a
				""";

		PreparedStatement ps = c.prepareStatement(sql);

		ResultSet rs = ps.executeQuery();

		while (rs.next()) {

			Aluno a = new Aluno();
			Curso cu = new Curso();
			Telefone tel = new Telefone();

			List<Telefone> telefones =  new ArrayList<>();

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
			a.setSemestreLimite(rs.getInt("semestreLimite"));
			a.setAnoLimite(rs.getInt("anoLimite"));
			
			if(rs.getString("telefone1") != null) {
				tel.setNumero(rs.getString("telefone1"));
			}else {
				tel.setNumero("Pendente");
				
			}
			
			telefones.add(tel);
			tel = new Telefone();
			
			if(rs.getString("telefone2") != null) {
				tel.setNumero(rs.getString("telefone2"));
			}else {
				tel.setNumero("Não Cadastrado");
			}
			
			telefones.add(tel);

			a.setTelefones(telefones);

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
		String sql = "{CALL sp_iuAluno (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
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
		cs.registerOutParameter(15, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(15);

		cs.close();
		C.close();

		return saida;
	}
}
