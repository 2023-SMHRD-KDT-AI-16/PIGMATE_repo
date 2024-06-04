package kr.board.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.board.entity.Farm;
import kr.board.entity.FarmEnv;

@Mapper
public interface FarmMapper {

	List<FarmEnv> getEnv(int farm_idx);

	List<Farm> getFarm(String mem_id);

	void insertFarm(Farm farm);

	void deletePenInfoByFarmName(String farmName);

	void deleteEnvCriteriaByFarmName(String farmName);

	void deleteFarmByName(String farmName);

	void updateFarmByOldName(@Param("oldFarmName") String oldFarmName, @Param("newFarmName") String newFarmName,
			@Param("farmLoc") String farmLoc, @Param("farmLivestockCnt") int farmLivestockCnt);
}
