package com.pigmate.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Data
@ToString
public class Member {

	private String mem_id;
	private String mem_pw;
	private String mem_name;
	private String mem_phone;
	private String joined_at;
}
