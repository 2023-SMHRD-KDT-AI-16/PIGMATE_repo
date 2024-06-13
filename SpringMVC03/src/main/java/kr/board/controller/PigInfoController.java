package kr.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.PigInfo;
import kr.board.mapper.PigInfoMapper;

@RestController
public class PigInfoController {

    @Autowired
    private PigInfoMapper pigInfoMapper;
    
    @GetMapping("/farm/PigInfo")
    public List<PigInfo> getWarnCount(@RequestParam("farm_idx") int farm_idx){
    	System.out.println("========================================================================");
        return pigInfoMapper.getWarnCountByFarmIdx(farm_idx);
    }
}