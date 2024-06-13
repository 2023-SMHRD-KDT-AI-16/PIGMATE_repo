package kr.board.entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class PigInfo {

	private String created_at;
	private int warn_cnt;
	private int livestock_cnt;
	
}
