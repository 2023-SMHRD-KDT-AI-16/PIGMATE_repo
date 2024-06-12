package kr.board.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.DetectionInfo;
import kr.board.mapper.DetectionInfoMapper;

import java.util.List;

@RestController
public class DetectionInfoController {

    @Autowired
    private DetectionInfoMapper detectionInfoMapper;

    @GetMapping("/farm/DetectionInfo")
    public List<DetectionInfo> getSitCount(@RequestParam("farm_idx") int farm_idx) {
        return detectionInfoMapper.getSitCountByFarmIdx(farm_idx);
    }
}
