package persistence;

import java.sql.SQLException;

import model.Aluno;

public interface IMatricula {
	public String iMatriucla(Aluno a) throws SQLException, ClassNotFoundException;
}
