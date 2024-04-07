package model;

import java.time.LocalTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Disciplina {

	private int codigoDisciplina;
	private String disciplina;
	private LocalTime horasSemanais;
	private LocalTime horaInicio; 
	private String diaSemana;
	
}
