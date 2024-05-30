package kr.board.mapper;

import org.apache.ibatis.annotations.Mapper;
import kr.board.entity.Farm;

@Mapper
public interface FarmMapper {

    public void updateFarm(Farm farm);

}
