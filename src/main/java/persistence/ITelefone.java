package persistence;

import java.sql.SQLException;

import model.Aluno;
import model.Telefone;

public interface ITelefone {
	
	public String iudTelefone(String acao, Aluno a, Telefone t) throws SQLException, ClassNotFoundException;
	
}
