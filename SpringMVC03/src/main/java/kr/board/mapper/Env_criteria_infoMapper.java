package kr.board.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.board.entity.EnvCri;

@Mapper
public interface Env_criteria_infoMapper {
	void insertEnvCri(EnvCri envCri);
	EnvCri getEnvCriByFarmIdx(int farmIdx);
	void updateEnvCri(EnvCri envCri);
}
