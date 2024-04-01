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
import model.Telefone;

public class TelefoneDao implements ITelefone, IListar<Aluno>{
	
	private GenericDao gDao;

	public TelefoneDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public List<Aluno> listar() throws SQLException, ClassNotFoundException {
		List<Aluno> alunos = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = """
				select a.nome, t.cpf, t.numero
				from Telefone t, Aluno a
				where a.cpf = t.cpf
				order by t.cpf
				""";

		PreparedStatement ps = c.prepareStatement(sql);

		ResultSet rs = ps.executeQuery();
		
		while(rs.next()) {
			Aluno a = new Aluno();
			Telefone tel = new Telefone();
			List<Telefone> telefone = new ArrayList<>();
			
			a.setNome(rs.getString("nome"));
			a.setCpf(rs.getString("cpf"));
			tel.setNumero(rs.getString("numero"));
			telefone.add(tel);
			a.setTelefones(telefone);
			
			alunos.add(a);
		}
		return alunos;
	}

	@Override
	public String iudTelefone(String acao, Aluno a, Telefone telefoneAntigo) throws SQLException, ClassNotFoundException {
		Connection C = gDao.getConnection();
		String sql = "{CALL sp_iudTelefone(?, ?, ?, ?, ?)}";
		CallableStatement cs = C.prepareCall(sql);
		cs.setString(1, acao);
		cs.setString(2, a.getCpf());
		
		cs.setString(3, telefoneAntigo.getNumero());

		cs.setString(4, a.getTelefones().get(0).getNumero());
		cs.registerOutParameter(5, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(5);

		cs.close();
		C.close();
				
		return saida;
	}

	
	
	
	
	
}
