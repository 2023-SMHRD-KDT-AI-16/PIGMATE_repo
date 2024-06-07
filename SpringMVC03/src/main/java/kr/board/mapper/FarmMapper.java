package kr.board.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.board.entity.Farm;
import kr.board.entity.FarmEnv;

@Mapper
public interface FarmMapper {

    // 회원의 모든 농장 정보 가져오기
    List<Farm> getFarm(String mem_id);

    // 농장의 일별 환경 정보 가져오기
    List<FarmEnv> getDaliyEnv(@Param("farm_idx") int farm_idx);
    
    // 최신 4주 데이터 가져오기
    List<FarmEnv> getWeeklyEnv(@Param("farm_idx") int farm_idx);
    
    // 월별 데이터 가져오기
    List<FarmEnv> getMonthlyEnv(@Param("farm_idx") int farm_idx);

    void insertFarm(Farm farm);

    void deletePenInfoByFarmName(String farmName);

    void deleteEnvCriteriaByFarmName(String farmName);

    void deleteFarmByName(String farmName);

    void updateFarmByOldName(@Param("oldFarmName") String oldFarmName, @Param("newFarmName") String newFarmName,
                             @Param("farmLoc") String farmLoc, @Param("farmLivestockCnt") int farmLivestockCnt);
}
