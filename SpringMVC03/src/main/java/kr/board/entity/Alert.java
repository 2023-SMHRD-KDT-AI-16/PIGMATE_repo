package kr.board.entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Alert {

    private Long alarmIdx;
    private String memId;
    private String alarmMsg;
    private Date alarmedAt;
    private int farm_idx;
    private String type;
    private int count;
    private String created_at;

}
