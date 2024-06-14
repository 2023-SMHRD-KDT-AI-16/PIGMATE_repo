package kr.board.entity;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class DetectionInfo {
	
	private int detect_idx;
    private String created_at;
    private int lying_cnt;
    private int livestock_cnt;
    private int farm_idx;
    private int result;
//    private double avg_lying_cnt;
//    private double avg_livestock_cnt;
//    private String created_date;
    
}
