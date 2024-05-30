package kr.board.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor // form에서 name값으로 요청데이터 넘길 때 알아서 객체로 묶어주는데 기본생성자가 꼭 있어야함
@AllArgsConstructor
@Data
public class Env {

	private int env_idx;
	private float temperature;
	private float humidity;
	private int co2;
	private int ammonia;
	private float pm;
	private String created_at;
	private int farm_idx;
}
