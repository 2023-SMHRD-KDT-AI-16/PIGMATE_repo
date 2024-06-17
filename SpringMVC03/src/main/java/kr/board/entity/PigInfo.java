package kr.board.entity;

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
    private int farm_idx;
    private double avg_pig_cnt;
    private double avg_livestock_cnt;
    private String created_date;
    private double avg_warn_cnt;
}