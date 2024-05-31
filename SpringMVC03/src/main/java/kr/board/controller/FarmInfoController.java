package kr.board.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

import kr.board.entity.Farm;
import kr.board.entity.Member;
import kr.board.mapper.FarmMapper;

@Controller
public class FarmInfoController {
    
	@Autowired
    private FarmMapper farmMapper;

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
        System.out.println("아이디 : " + mem_id);
        
        // farm 객체에 아이디 저장
        farm.setMem_id(mem_id);

        // farm 정보 업데이트
        System.out.println(farm.getFarm_livestock_cnt());
        farmMapper.insertFarm(farm);
        System.out.println("업데이트 성공 " + mem_id);
        
        return "redirect:/myPage.do";
    }
}
