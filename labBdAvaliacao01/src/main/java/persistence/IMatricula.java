package persistence;

import java.sql.SQLException;
import java.util.List;

import model.Aluno;

public interface IMatricula <T> {
	public String iMatriucla(Aluno a) throws SQLException, ClassNotFoundException;
	public List<T> listarDisciplinas(Aluno a) throws SQLException, ClassNotFoundException;
	public List<T> listarMatriculas(Aluno a) throws SQLException, ClassNotFoundException;
}
