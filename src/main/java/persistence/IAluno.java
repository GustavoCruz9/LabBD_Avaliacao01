package persistence;

import java.sql.SQLException;
import model.Aluno;

public interface IAluno {
	
	public String iuAluno(String acao, Aluno a) throws SQLException, ClassNotFoundException;
	public int verificaCpf(Aluno a) throws SQLException, ClassNotFoundException;
	
}