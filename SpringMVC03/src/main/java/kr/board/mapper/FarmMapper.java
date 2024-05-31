package kr.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.board.entity.Farm;
import kr.board.entity.FarmEnv;

@Mapper
public interface FarmMapper {
	
    List<FarmEnv> getEnv(int farm_idx);
    
    List<Farm> getFarm(String mem_id);
    
    void insertFarm(Farm farm);
    
    void deleteFarmByName(String farmName);
    
}
