package kr.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.board.entity.PigInfo;

@Mapper
public interface PigInfoMapper {

	List<PigInfo> getWarnCountByFarmIdx(@Param("farm_idx") int farm_idx);
	
}
