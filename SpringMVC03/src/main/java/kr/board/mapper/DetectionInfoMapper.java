package kr.board.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.board.entity.DetectionInfo;
import java.util.List;

@Mapper
public interface DetectionInfoMapper {

	List<DetectionInfo> getLyingCountByFarmIdx(@Param("farm_idx") int farm_idx);

	List<DetectionInfo> gettimeLyingCount(@Param("farm_idx") int farm_idx);

	List<DetectionInfo> getdayLyingCount(@Param("farm_idx") int farm_idx);

	List<DetectionInfo> getAbnormalDetectionCount(@Param("farm_idx") int farm_idx);

	List<DetectionInfo> getLastLyingCount(@Param("farm_idx") int farm_idx);

    // 날짜별 하루 단위 탐지 정보 가져오기
    List<DetectionInfo> getDailyDetectionInfoByDate(@Param("farm_idx") int farm_idx, @Param("date") String date);
}
