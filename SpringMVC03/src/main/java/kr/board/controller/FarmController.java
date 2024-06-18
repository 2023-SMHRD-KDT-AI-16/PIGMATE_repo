package kr.board.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import kr.board.entity.EnvCri;
import kr.board.entity.Farm;
import kr.board.entity.FarmEnv;
import kr.board.entity.Member;
import kr.board.mapper.Env_criteria_infoMapper;
import kr.board.mapper.FarmMapper;

@RestController
public class FarmController {

	@Autowired
	private FarmMapper farmMapper;

	@Autowired
	private Env_criteria_infoMapper env_criteria_infoMapper;

	@GetMapping("/index.jsp")
	public String getDashboard(@RequestParam("farmId") int farm_idx, Model model, HttpSession session) {
		Member m = (Member) session.getAttribute("mvo");
		if (m == null) {
			return "redirect:/loginForm.do";
		}

		Farm farm = farmMapper.getFarmById(farm_idx);
		model.addAttribute("farm", farm);
		List<FarmEnv> farmEnv = farmMapper.getEnv(farm_idx);
		model.addAttribute("farmEnv", farmEnv);

		return "index";
	}

	// 농장 환경 정보 정해준 기간별로 가져오기
	@PostMapping("/farm/env")
	public List<FarmEnv> FarmEnvList(HttpSession session, @RequestParam("period") String period,
			@RequestParam("type") String type, @RequestParam("farm_id") String farm_id) {

		List<FarmEnv> farm_env = new ArrayList<>();

		Member m = (Member) session.getAttribute("mvo");

		if (m != null) {

			String mem_id = m.getMem_id();

			if (farm_id != null && !farm_id.isEmpty()) {

				int farm_idx = Integer.parseInt(farm_id);

				System.out.print(farm_idx);

				if ("weekly".equals(period)) {
					List<FarmEnv> WeeklyEnv = farmMapper.getWeeklyEnv(farm_idx);
					List<FarmEnv> weeklyAverages = calculateWeeklyAverages(WeeklyEnv);
					System.out.print(weeklyAverages);
					farm_env.addAll(weeklyAverages);

				} else if ("daily".equals(period)) {
					List<FarmEnv> dailyEnv = farmMapper.getDailyEnv(farm_idx);
					System.out.print(dailyEnv);
					farm_env.addAll(dailyEnv);

				} else if ("monthly".equals(period)) {
					List<FarmEnv> MonthlyEnv = farmMapper.getMonthlyEnv(farm_idx);
					System.out.print(MonthlyEnv);
					farm_env.addAll(MonthlyEnv);
				}
			}
		}
		return farm_env;
	}

	private List<FarmEnv> calculateWeeklyAverages(List<FarmEnv> latestWeeklyEnv) {
		List<FarmEnv> weeklyAverages = new ArrayList<>();
		int cnt = 0;
		double totalTemperature = 0;
		double totalHumidity = 0;
		double totalCo2 = 0;
		double totalAmmonia = 0;
		double totalPm = 0;

		for (int i = 0; i < latestWeeklyEnv.size(); i++) {
			FarmEnv env = latestWeeklyEnv.get(i);
			cnt++;
			totalTemperature += env.getTemperature();
			totalHumidity += env.getHumidity();
			totalCo2 += env.getCo2();
			totalAmmonia += env.getAmmonia();
			totalPm += env.getPm();

			if (cnt == 7) {
				FarmEnv averageEnv = new FarmEnv();
				averageEnv.setTemperature((float) (totalTemperature / 7));
				averageEnv.setHumidity((float) (totalHumidity / 7));
				averageEnv.setCo2((int) (totalCo2 / 7));
				averageEnv.setAmmonia((int) (totalAmmonia / 7));
				averageEnv.setPm((float) (totalPm / 7));
				averageEnv.setCreated_at(latestWeeklyEnv.get(i).getCreated_at());
				weeklyAverages.add(averageEnv);
				cnt = 0;
				totalTemperature = 0;
				totalHumidity = 0;
				totalCo2 = 0;
				totalAmmonia = 0;
				totalPm = 0;
			}
		}

		if (cnt > 0) {
			FarmEnv averageEnv = new FarmEnv();
			averageEnv.setTemperature((float) (totalTemperature / cnt));
			averageEnv.setHumidity((float) (totalHumidity / cnt));
			averageEnv.setCo2((int) (totalCo2 / cnt));
			averageEnv.setAmmonia((int) (totalAmmonia / cnt));
			averageEnv.setPm((float) (totalPm / cnt));
			averageEnv.setCreated_at(latestWeeklyEnv.get(latestWeeklyEnv.size() - 1).getCreated_at());
			weeklyAverages.add(averageEnv);
		}

		return weeklyAverages;
	}

	// 멤버가 가지고 있는 모든 농장 정보 가져오는 메소드
	@GetMapping("/all")
	public List<Farm> getFarm(HttpSession session) {
		Member m = (Member) session.getAttribute("mvo");
		String mem_id = m.getMem_id();
		return farmMapper.getFarm(mem_id);
	}

	// 회원의 농장
	@PostMapping("/insertFarm.do")
	public String updateFarm(Farm farm, HttpSession session) {
		Member mvo = (Member) session.getAttribute("mvo");

		if (mvo == null) {
			return "redirect:/login.do";
		}

		String mem_id = mvo.getMem_id();
		farm.setMem_id(mem_id);
		farmMapper.insertFarm(farm);
		return "redirect:/myPage.do";
	}

	@RequestMapping(value = "/editFarm.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<String> editFarm(@RequestParam("old_farm_name") String oldFarmName,
			@RequestParam("new_farm_name") String newFarmName, @RequestParam("farm_loc") String farmLoc,
			@RequestParam("farm_livestock_cnt") int farmLivestockCnt) {
		try {
			farmMapper.updateFarmByOldName(oldFarmName, newFarmName, farmLoc, farmLivestockCnt);
			return new ResponseEntity<>("농장 수정이 완료되었습니다.", HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity<>("농장 수정 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@RequestMapping("/deleteFarm.do")
	@ResponseBody
	public ResponseEntity<String> deleteFarm(@RequestParam("farm_name") String farmName) {
		try {
			farmMapper.deletePenInfoByFarmName(farmName);
			farmMapper.deleteEnvCriteriaByFarmName(farmName);
			farmMapper.deleteFarmByName(farmName);
			return new ResponseEntity<>("농장 삭제가 완료되었습니다.", HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity<>("농장 삭제 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	// 농장 환경 기준 가져오기
	@GetMapping("/env/cri")
	public ResponseEntity<EnvCri> getEnvCriteriaOne(@RequestParam("farmId") int farm_idx) {
		try {
			EnvCri envCri = env_criteria_infoMapper.getEnvCriByFarmIdx(farm_idx);
			if (envCri != null) {
				System.out.println(envCri);
				return new ResponseEntity<>(envCri, HttpStatus.OK);
			} else {
				return new ResponseEntity<>(new EnvCri(), HttpStatus.OK);
			}
		} catch (Exception e) {
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
	}

	// 새로고침 시 랜덤값 뽑아서 db에 저장
	@GetMapping("/env/randomCri")
	public FarmEnv getRandomEnv(@RequestParam("farmId") int farm_idx) {

		EnvCri cri = env_criteria_infoMapper.getEnvCriByFarmIdx(farm_idx);
		FarmEnv farm = new FarmEnv();
		
		List<Number> values = new ArrayList<>();
	    values.add(cri.getAmmonia());
	    values.add(cri.getCo2());
	    values.add(cri.getHumidity());
	    values.add(cri.getPm());
	    values.add(cri.getTemperature());
	    
	    Random random = new Random();
	    
	    for (int i = 0; i < values.size(); i++) {
	    	
	    	double randomValue = 0.0;
	    	Number value = values.get(i);
	    	
	    	if (i == 0) {
	    		
	    		double min = 1 * (1 - 0.5);
	            double max = 1 * (1 + 0.5);
	
	            randomValue = min + (max - min) * random.nextDouble();
	    	}else {
	            
	            double baseValue = value.doubleValue();
	            double percentage = 0.25; // 30%
	
	            double min = baseValue * (1 - percentage);
	            double max = baseValue * (1 + percentage);
	
	            randomValue = min + (max - min) * random.nextDouble();
            }
            randomValue = Math.round(randomValue * 10.0) / 10.0;

            // 리스트의 값을 변경
            if (value instanceof Float) {
                values.set(i, (float) randomValue);
            } else if (value instanceof Integer) {
                values.set(i, (int) randomValue);
            }
        }
	    
	    farm.setAmmonia((float)values.get(0));
	    farm.setCo2((int)values.get(1));
	    farm.setHumidity((float)values.get(2));
	    farm.setPm((float)values.get(3));
	    farm.setTemperature((float)values.get(4));
	    farm.setFarm_idx(farm_idx);

	    int result =  farmMapper.insertFarmEnvTime(farm);

	    return farm;
	}
	
	// 이메일 보내기 위한 멤버의 모든 농장 기준 가져오기
	@GetMapping("/env/criteria")
	public ResponseEntity<EnvCri> getEnvCriteria(HttpSession session) {
		
		Member m = (Member) session.getAttribute("mvo");
		if (m != null) {
			String mem_id = m.getMem_id();
			List<Farm> farmList = farmMapper.getFarm(mem_id);
			if (!farmList.isEmpty()) {
				int farmIdx = farmList.get(0).getFarm_idx();
				EnvCri envCri = env_criteria_infoMapper.getEnvCriByFarmIdx(farmIdx);
				return new ResponseEntity<>(envCri, HttpStatus.OK);
			}
		}
		return new ResponseEntity<>(HttpStatus.NO_CONTENT);
	}

	
	// 환경기준 수정
	@PostMapping("/insertEnvCri.do")
	public ResponseEntity<String> insertEnvCri(EnvCri envCri, HttpSession session) {
		try {
			EnvCri existingEnvCri = env_criteria_infoMapper.getEnvCriByFarmIdx(envCri.getFarm_idx());
			if (existingEnvCri != null) {
				env_criteria_infoMapper.updateEnvCri(envCri);
				return new ResponseEntity<>("환경 기준이 수정되었습니다.", HttpStatus.OK);
			} else {
				env_criteria_infoMapper.insertEnvCri(envCri);
				return new ResponseEntity<>("환경 기준이 저장되었습니다.", HttpStatus.OK);
			}
		} catch (Exception e) {
			return new ResponseEntity<>("환경 기준 저장 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	
	
}