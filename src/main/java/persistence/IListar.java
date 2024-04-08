package persistence;

import java.sql.SQLException;
import java.util.List;

public interface IListar<T> {
	
	public List<T> listar() throws SQLException, ClassNotFoundException;
	
}
