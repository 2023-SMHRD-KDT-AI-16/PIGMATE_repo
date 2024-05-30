package kr.board.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor 
@AllArgsConstructor
@Data
public class Farm {
	
	private int farm_idx;
	private String farm_loc;
	private int farm_livestock_cnt;
	private String mem_id;

}
