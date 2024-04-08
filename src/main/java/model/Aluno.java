package model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Aluno {
	
	private String cpf;
	private String ra; 
	private Curso curso;
	private String nome;
	private String nomeSocial;
	private LocalDate dataNascimento;
	private String email;
	private String emailCorporativo;
	private LocalDate dataConclusao2Grau;
	private String instituicao2Grau;
	private int pontuacaoVestibular;
	private int posicaoVestibular;
	private int anoIngresso;
	private int semestreIngresso;
	private int anoLimite;
	private int semestreLimite;
	List<Telefone> telefones = new ArrayList<>();
}
