package kr.board.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor 
@AllArgsConstructor
@Data
public class FarmEnv {

	private int env_idx;
	private float temperature;
	private float humidity;
	private int co2;
	private float ammonia;
	private float pm;
	private String created_at;
	private int farm_idx;
	
}
