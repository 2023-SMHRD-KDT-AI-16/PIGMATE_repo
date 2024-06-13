package kr.board.entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class DetectionInfo {
	
    private String created_at;
    private int sit_cnt;
    private int livestock_cnt;
    private int farm_idx;
    
}
