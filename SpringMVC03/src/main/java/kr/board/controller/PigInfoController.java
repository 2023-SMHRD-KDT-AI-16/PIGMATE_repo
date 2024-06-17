package kr.board.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.DetectionInfo;
import kr.board.entity.Member;
import kr.board.entity.PigInfo;
import kr.board.mapper.DetectionInfoMapper;
import kr.board.mapper.PigInfoMapper;

@RestController
public class PigInfoController {

	@Autowired
	private PigInfoMapper pigInfoMapper;

	@GetMapping("/farm/PigInfo")
	public List<PigInfo> PigInfoList(HttpSession session, @RequestParam("period") String period,
			@RequestParam("type") String type, @RequestParam("farm_idx") String farm_id) {
		System.out.println("Entering PigInfoList method");
		List<PigInfo> pig_info = new ArrayList<>();

		Member m = (Member) session.getAttribute("mvo");

		System.out.println("농장 번호:" + farm_id);
		if (m != null) {
			String mem_id = m.getMem_id();
			System.out.println("Member ID: " + mem_id);

			if (farm_id != null && !farm_id.isEmpty()) {
				int farm_idx = Integer.parseInt(farm_id);
				System.out.println("Farm ID: " + farm_idx);

				if ("time".equals(period)) {
					pig_info = pigInfoMapper.gettimeWarnCount(farm_idx);
					System.out.println("pig info (time): " + pig_info);
				} else if ("day".equals(period)) {
					pig_info = pigInfoMapper.getdayWarnCount(farm_idx);
					System.out.println("pig info (day): " + pig_info);
				}
			} else {
				System.out.println("Farm ID is null or empty");
			}
		} else {
			System.out.println("Session member is null");
		}
		// 추가된 부분: pig_info 데이터를 출력합니다.
		for (PigInfo info : pig_info) {
			System.out.println(info);
		}
		return pig_info;
	}

	// 날짜 선택 시 시간별 이상 돼지 객체 탐지 평균
	 @GetMapping("/farm/AbnormalInfo/date")
	    public List<PigInfo> getDailyAbnormalInfoByDate(@RequestParam("farm_id") int farm_idx,
	                                                    @RequestParam("date") String date) {
	        System.out.println("Fetching abnormal detection info for farm_id: " + farm_idx + ", date: " + date);
	        List<PigInfo> abnormalInfoList = new ArrayList<>();
	        try {
	            abnormalInfoList = pigInfoMapper.getDailyAbonormalInfoByDate(farm_idx, date);
	            System.out.println("Fetched abnormal detection info: " + abnormalInfoList);
	        } catch (Exception e) {
	            System.err.println("Error fetching abnormal detection info: " + e.getMessage());
	            e.printStackTrace();
	        }
	        return abnormalInfoList;
	    }
}
