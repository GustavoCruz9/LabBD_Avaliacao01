package persistence;

import java.sql.SQLException;
import java.util.List;

public interface IConsultar<T> {
	public T consultar(T t) throws SQLException, ClassNotFoundException;
	
}