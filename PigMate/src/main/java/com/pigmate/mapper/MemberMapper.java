package com.pigmate.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.mybatis.spring.annotation.MapperScan;

import com.pigmate.entity.Member;

import lombok.AllArgsConstructor;

@Mapper
public interface MemberMapper {

	// Spring과 Mybatis를 연결하는 역할 (interface)
	
	public Member getMember(String mem_id);

	public int join(Member mem);

	public Member login(Member mem);
	
}
