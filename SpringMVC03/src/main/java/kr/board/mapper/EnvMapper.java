package kr.board.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.board.entity.Env;

@Mapper
public interface EnvMapper {
	
	public Env getEnv(String mem_id);


}
