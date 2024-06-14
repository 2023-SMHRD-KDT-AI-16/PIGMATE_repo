package kr.board.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.DetectionInfo;
import kr.board.entity.Member;
import kr.board.mapper.DetectionInfoMapper;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

@RestController
public class DetectionInfoController {

    @Autowired
    private DetectionInfoMapper detectionInfoMapper;

    @GetMapping("/farm/DetectionInfo")
    public List<DetectionInfo> DetectionInfoList(HttpSession session, @RequestParam("period") String period,
                                                 @RequestParam("type") String type, @RequestParam("farm_idx") String farm_id) {
        System.out.println("Entering DetectionInfoList method");
        List<DetectionInfo> detection_info = new ArrayList<>();

        Member m = (Member) session.getAttribute("mvo");
        System.out.println("Session member: " + m);

        if (m != null) {
            String mem_id = m.getMem_id();
            System.out.println("Member ID: " + mem_id);

            if (farm_id != null && !farm_id.isEmpty()) {
                int farm_idx = Integer.parseInt(farm_id);
                System.out.println("Farm ID: " + farm_idx);

                if ("time".equals(period)) {
                    detection_info = detectionInfoMapper.gettimeLyingCount(farm_idx);
                    System.out.println("Detection info (time): " + detection_info);
                } else if ("day".equals(period)) {
                    detection_info = detectionInfoMapper.getdayLyingCount(farm_idx);
                    System.out.println("Detection info (day): " + detection_info);
                }
            }
        }
        return detection_info;
    }
}
