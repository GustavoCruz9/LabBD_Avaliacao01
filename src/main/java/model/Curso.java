package model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Curso {
	
	private int codigo;
	private String nome;
	private int cargaHoraria;
	private String sigla;
	private int notaEnade;
}
