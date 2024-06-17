package kr.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.board.entity.DetectionInfo;
import kr.board.entity.PigInfo;

@Mapper
public interface PigInfoMapper {


    List<PigInfo> getWarnCountByFarmIdx(@Param("farm_idx") int farm_idx);
    
    List<PigInfo> gettimeWarnCount(@Param("farm_idx") int farm_idx);
    
    List<PigInfo> getdayWarnCount(@Param("farm_idx") int farm_idx);
    
    // 날짜별 시간 단위 이상 탐지 정보 가져오기
    List<PigInfo> getDailyAbonormalInfoByDate(@Param("farm_idx") int farm_idx, @Param("date") String date);
    
}

