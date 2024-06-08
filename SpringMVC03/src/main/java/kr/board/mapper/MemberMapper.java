package kr.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.board.entity.Farm;
import kr.board.entity.Member;

@Mapper
public interface MemberMapper {

	public Member login(Member m);
	
	public List<Farm> loginFarm(String mem_id);

	public Member getMember(String mem_id);
	
	public int join(Member m);

	public void update(Member m);
	
	// 모든 회원정보 가져오기 - 이메일 전송
	public List<Member> getAllMembers();

}
