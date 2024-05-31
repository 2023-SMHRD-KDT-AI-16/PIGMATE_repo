package kr.board.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor // form에서 name값으로 요청데이터 넘길 때 알아서 객체로 묶어주는데 기본생성자가 꼭 있어야함
@AllArgsConstructor
@Data
//@ToString
public class Member {
	
	private String mem_id;
	private String mem_pw;
	private String mem_name;
	private String mem_phone;
	private String mem_email;
	private String joined_at;


}









