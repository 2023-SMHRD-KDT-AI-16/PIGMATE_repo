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
    
   /*
    * @GetMapping("farm/pigcnt") public List<Integer> getPigCount(HttpSession
    * session, @RequestParam("farmId") String farm_id){ System.out.println("도착!!");
    * List<Integer> pigCnt = new ArrayList<Integer>();
    * 
    * Member m = (Member) session.getAttribute("mvo");
    * 
    * if (m != null) { if (farm_id != null && !farm_id.isEmpty()) {
    * System.out.println(farm_id); int farm_idx = Integer.parseInt(farm_id);
    * System.out.println(farm_idx);
    * 
    * if (detectionInfoMapper != null) { List<DetectionInfo> lists =
    * detectionInfoMapper.getLastLyingCount(farm_idx);
    * 
    * if (lists != null && !lists.isEmpty()) { System.out.println(lists);
    * 
    * int all_pig = lists.get(0).getLivestock_cnt(); int lying_pig =
    * lists.get(0).getLying_cnt(); int standing_pig = all_pig - lying_pig;
    * 
    * pigCnt.add(lying_pig); pigCnt.add(standing_pig);
    * 
    * System.out.println(pigCnt); } else {
    * System.out.println("No data found for the given farm_idx"); } } else {
    * System.out.println("detectionInfo object is null"); } } else {
    * System.out.println("farm_id is null or empty"); } } else {
    * System.out.println("Member is null"); }
    * 
    * return pigCnt; }
    */
    
    
    
    @GetMapping("farm/pigcnt")
    public List<Integer> getPigCount(HttpSession session, @RequestParam("farmId") String farm_id){
       
        List<Integer> pigCnt = new ArrayList<Integer>();

        Member m = (Member) session.getAttribute("mvo");

        if (m != null) {
           
            if (farm_id != null && !farm_id.isEmpty()) {
               
                int farm_idx = Integer.parseInt(farm_id);

                if (detectionInfoMapper != null) {
                    List<DetectionInfo> lists = detectionInfoMapper.getLastLyingCount(farm_idx);

                    if (lists != null && !lists.isEmpty()) {
                        System.out.println(lists);

                        int all_pig = lists.get(0).getLivestock_cnt();
                        int lying_pig = lists.get(0).getLying_cnt();
                        int standing_pig = all_pig - lying_pig;

                        pigCnt.add(lying_pig);
                        pigCnt.add(standing_pig);

                    }
                } 
            } 
        } 

        return pigCnt;
    }
    
   // 날짜 선택 시 시간별 돼기객체 탐지 평균
    @GetMapping("/farm/DetectionInfo/date")
    public List<DetectionInfo> getDailyDetectionInfoByDate(@RequestParam("farm_id") int farm_idx, @RequestParam("date") String date) {
        List<DetectionInfo> detectionInfoList = detectionInfoMapper.getDailyDetectionInfoByDate(farm_idx, date);
        System.out.println("날짜별 탐지 정보: " + detectionInfoList);
        return detectionInfoList;
    }
    
}