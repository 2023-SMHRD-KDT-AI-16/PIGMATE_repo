package kr.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.board.entity.Farm;
import kr.board.entity.FarmEnv;

@Mapper
public interface FarmMapper {
	
	public List<FarmEnv> getEnv(int farm_idx);
	
	public Farm getFarm(String mem_id);
	
	public void updateFarm(Farm farm);

}
