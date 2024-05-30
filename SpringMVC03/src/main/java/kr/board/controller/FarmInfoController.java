package kr.board.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

import kr.board.entity.Farm;
import kr.board.mapper.FarmMapper;

@Controller
public class FarmInfoController {
    
    @Autowired
    private FarmMapper farmMapper;

    // 마이 페이지 - 농장 정보 추가 기능 /updateFarm.do
    @PostMapping("/updateFarm.do")
    public String addFarm(Farm farm, HttpSession session) {
    	
        // 세션에서 로그인한 사용자의 아이디 가져오기 
        String mem_id = (String) session.getAttribute("mem_id");
        System.out.println("아이디 : " + mem_id);
        
        // farm 객체에 아이디 저장
        farm.setMem_id(mem_id);

        // farm 정보 업데이트
        farmMapper.updateFarm(farm);
        System.out.println("업데이트 성공 " + mem_id);
        
        return "redirect:/myPage.do";
    }
}
