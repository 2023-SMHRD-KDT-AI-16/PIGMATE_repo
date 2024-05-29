package kr.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.board.entity.Member;

@Mapper
public interface MemberMapper {

	public Member login(Member m);

}
