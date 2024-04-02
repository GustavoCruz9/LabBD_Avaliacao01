package persistence;

public class MatriculaDao implements IMatricula, IListar<>{
	
	private GenericDao gDao;

	public MatriculaDao(GenericDao gDao) {
		this.gDao = gDao;
	}
}
