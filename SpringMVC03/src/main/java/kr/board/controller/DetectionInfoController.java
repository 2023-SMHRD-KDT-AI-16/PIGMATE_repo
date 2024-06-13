package kr.board.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.DetectionInfo;
import kr.board.entity.FarmEnv;
import kr.board.entity.Member;
import kr.board.mapper.DetectionInfoMapper;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

@RestController
public class DetectionInfoController {

    @Autowired
    private DetectionInfoMapper detectionInfoMapper;

//    @GetMapping("/farm/DetectionInfo")
//    public List<DetectionInfo> getSitCount(@RequestParam("farm_idx") String farm_id) {
//    	int farm_idx = Integer.parseInt(farm_id);
//    	System.out.println(farm_idx);
//    	List<DetectionInfo> detection_info = detectionInfoMapper.getSitCountByFarmIdx(farm_idx);
//    	System.out.println(detection_info);
//        return detection_info;
//    }
    
    @GetMapping("/farm/DetectionInfo")
    public List<DetectionInfo> DetectionInfoList(HttpSession session,@RequestParam("period") String period,
    		@RequestParam("type") String type,  @RequestParam("farm_idx") String farm_id){
    	System.out.println("========================================================================");
    	List<DetectionInfo> detection_info = new ArrayList<>();
    	
    	Member m = (Member) session.getAttribute("mvo");

		if (m != null) {

			String mem_id = m.getMem_id();

			if (farm_id != null && !farm_id.isEmpty()) {

				int farm_idx = Integer.parseInt(farm_id);

				System.out.print(farm_idx);

				if ("time".equals(period)) {
					detection_info = detectionInfoMapper.gettimeSitCount(farm_idx);
					System.out.println(detection_info);
					//return detection_info;
				} else if ("day".equals(period)) {
					detection_info = detectionInfoMapper.getSitCountByFarmIdx(farm_idx);
					System.out.println(detection_info);
					//return detection_info;
				}
			}
		}
		return detection_info;
	}
}