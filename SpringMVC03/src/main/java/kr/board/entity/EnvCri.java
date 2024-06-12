package kr.board.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor 
@AllArgsConstructor
@Data
public class EnvCri {

	private int criteria_idx;
	private int farm_idx;
	private float temperature;
	private float humidity;
	private int co2;
	private float ammonia;
	private float pm;
	private String created_at;
	
}
