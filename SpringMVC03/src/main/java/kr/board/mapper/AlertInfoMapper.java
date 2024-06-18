package kr.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import kr.board.entity.Alert;

@Mapper
public interface AlertInfoMapper {
	
    List<Alert> findAll();
    void insertAlert(Alert alert);
	List<Alert> findAlertsByFarmId(int farm_idx);
	List<Alert> getAlertData(@Param("farm_idx") int farm_idx, @Param("date") String date);
    
}