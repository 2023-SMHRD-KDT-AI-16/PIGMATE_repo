package kr.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import kr.board.entity.Alert;

@Mapper
public interface AlertInfoMapper {
	
    List<Alert> findAll();
    void insertAlert(Alert alert);
	List<Alert> findAlertsByFarmId(int farm_idx);
    
}