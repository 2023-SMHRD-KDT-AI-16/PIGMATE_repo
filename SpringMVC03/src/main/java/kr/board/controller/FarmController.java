package kr.board.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.EnvCri;
import kr.board.entity.Farm;
import kr.board.entity.FarmEnv;
import kr.board.entity.Member;
import kr.board.mapper.Env_criteria_infoMapper;
import kr.board.mapper.FarmMapper;
import kr.board.mapper.MemberMapper;

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

		// 세션에서 로그인한 사용자의 mvo 가져오기
		Member mvo = (Member) session.getAttribute("mvo");

		if (mvo == null) {
			System.out.println("mvo 없음");
			return "redirect:/login.do";
		}

		// mvo 객체에서 mem_id 가져오기
		String mem_id = mvo.getMem_id();
		// System.out.println("아이디 : " + mem_id);

		// farm 객체에 아이디 저장
		farm.setMem_id(mem_id);

		// farm 정보 업데이트
		// System.out.println(farm.getFarm_livestock_cnt());
		farmMapper.insertFarm(farm);
		// System.out.println("업데이트 성공 " + mem_id);

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
			// 먼저 연관된 레코드를 삭제합니다.
			farmMapper.deletePenInfoByFarmName(farmName);

			// 그 다음에 농장 정보를 삭제합니다.
			farmMapper.deleteFarmByName(farmName);
			return new ResponseEntity<>("농장 삭제가 완료되었습니다.", HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity<>("농장 삭제 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	// 환경 기준 정보 추가하기
	@PostMapping("/insertEnvCri.do")
	public String insertEnvCri(EnvCri envCri, HttpSession session) {

		// 세션에서 로그인한 사용자 mvo 가져오기
		Member mvo = (Member) session.getAttribute("mvo");

		if (mvo == null) {
			System.out.println("mvo 없음");
			return "redirect:/login.do";
		}

		String mem_id = mvo.getMem_id();

		// mvo 객체에서 farm_idx 가져오기
		List<Farm> farm_idx = farmMapper.getFarm(mem_id);
		System.out.println("아이디 : " + farm_idx);

		// envCri 객체에 아이디 저장
		// envCri.setFarm_idx(farm_idx);

		// envCri 정보 업데이트
		System.out.println(envCri.getPm());
		env_criteria_infoMapper.insertEnvCri(envCri);
		System.out.println("업데이트 성공 " + farm_idx);

		return "redirect:/myPage.do";
	}
}