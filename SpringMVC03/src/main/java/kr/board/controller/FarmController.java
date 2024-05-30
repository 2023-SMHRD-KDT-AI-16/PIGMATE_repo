package kr.board.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.FarmEnv;
import kr.board.entity.Member;
import kr.board.mapper.FarmMapper;

@RestController
public class FarmController {
	
	@Autowired
	private FarmMapper farmMapper ;
	
	// 환경 정보 이동
	@PostMapping("farm")
	public List<FarmEnv> FarmEnvList(HttpSession session, Model model) {
		
		List<FarmEnv> farm_env = null;
		
		Member m = (Member) session.getAttribute("mvo");
		
		if(m != null) {
			// 환경 정보 누르면 session에서 mem_id 가져와서 회원이 가지고 있는 농장 인덱스만 가져오기
			String mem_id = m.getMem_id();
					
			int farm_idx = farmMapper.getFarm(mem_id).getFarm_idx();
			
			System.out.println(farm_idx);
		
			farm_env = farmMapper.getEnv(farm_idx);
			
			// model.addAttribute("farm_env", farm_env);
		
		}
		
		return farm_env;
	}
	
	
	
}
