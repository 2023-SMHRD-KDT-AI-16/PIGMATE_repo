package kr.board.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.board.entity.DetectionInfo;

import java.util.List;

@Mapper
public interface DetectionInfoMapper {
	
    List<DetectionInfo> getSitCountByFarmIdx(@Param("farm_idx") int farm_idx);
    
    List<DetectionInfo> gettimeSitCount(@Param("farm_idx") int farm_idx);
    
    List<DetectionInfo> getAbnormalDetectionCount(@Param("farm_idx") int farmIdx);
    
    List<DetectionInfo> getdaySitCount(@Param("farm_idx") int farm_idx);
    
}
