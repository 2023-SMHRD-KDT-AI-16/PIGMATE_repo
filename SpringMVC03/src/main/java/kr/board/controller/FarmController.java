package kr.board.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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

	// 환경 정보 페이지로 환경 정보 가져오기
	@PostMapping("/farm/env")
	public List<FarmEnv> FarmEnvList(HttpSession session) {

		List<FarmEnv> farm_env = new ArrayList<>();

		Member m = (Member) session.getAttribute("mvo");

		if (m != null) {
			// 환경 정보 누르면 session에서 mem_id 가져와서 회원이 가지고 있는 농장 인덱스만 가져오기
			String mem_id = m.getMem_id();

			System.out.println("환경 정보 조회할 회원 :" + m.getMem_id());

			List<Farm> farm = farmMapper.getFarm(mem_id);

			for (int i = 0; i < farm.size(); i++) {

				int idx = farm.get(i).getFarm_idx();

				farm_env.addAll(farmMapper.getEnv(idx));
				
			}
		}
		return farm_env;
	}

	// 농장 전체보기
	@GetMapping("/all")
	public List<Farm> getFarm(HttpSession session) {
		Member m = (Member) session.getAttribute("mvo");
		String mem_id = m.getMem_id();
		System.out.println("[농장 전체보기]");
		List<Farm> list = farmMapper.getFarm(mem_id);
		System.out.println("반환된 농장 목록 : " + list);
		return list;
	}

	// 농장정보 추가하기
	@PostMapping("/insertFarm.do")
	public String updateFarm(Farm farm, HttpSession session) {
		Member mvo = (Member) session.getAttribute("mvo");

		if (mvo == null) {
			System.out.println("mvo 없음");
			return "redirect:/login.do";
		}

		String mem_id = mvo.getMem_id();
		farm.setMem_id(mem_id);
		farmMapper.insertFarm(farm);
		return "redirect:/myPage.do";
	}

	// 농장 정보 업데이트
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

	// 농장 삭제하기
	@RequestMapping("/deleteFarm.do")
	@ResponseBody
	public ResponseEntity<String> deleteFarm(@RequestParam("farm_name") String farmName) {
		try {
			farmMapper.deletePenInfoByFarmName(farmName);
			farmMapper.deleteFarmByName(farmName);
			return new ResponseEntity<>("농장 삭제가 완료되었습니다.", HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity<>("농장 삭제 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	// 환경 기준 정보 가져오기
	@GetMapping("/getEnvCriteria.do")
	public ResponseEntity<EnvCri> getEnvCriteria(@RequestParam("farm_idx") int farmIdx) {
		try {
			EnvCri envCri = env_criteria_infoMapper.getEnvCriByFarmIdx(farmIdx);
			if (envCri != null) {
				System.out.println("환경 기준 데이터: " + envCri); // 서버 콘솔에 출력
				return new ResponseEntity<>(envCri, HttpStatus.OK);
			} else {
				System.out.println("환경 기준 데이터 없음: 빈 객체 반환"); // 서버 콘솔에 출력
				return new ResponseEntity<>(new EnvCri(), HttpStatus.OK);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	// 농장별 환경 기준 추가/수정하기
	@PostMapping("/insertEnvCri.do")
	public ResponseEntity<String> insertEnvCri(EnvCri envCri, HttpSession session) {
	    try {
	        // 환경 기준 데이터가 이미 존재하는지 확인
	        EnvCri existingEnvCri = env_criteria_infoMapper.getEnvCriByFarmIdx(envCri.getFarm_idx());
	        if (existingEnvCri != null) {
	            // 존재하면 업데이트
	            env_criteria_infoMapper.updateEnvCri(envCri);
	            return new ResponseEntity<>("환경 기준이 수정되었습니다.", HttpStatus.OK);
	        } else {
	            // 존재하지 않으면 추가
	            env_criteria_infoMapper.insertEnvCri(envCri);
	            return new ResponseEntity<>("환경 기준이 저장되었습니다.", HttpStatus.OK);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ResponseEntity<>("환경 기준 저장 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}

	
	
}
