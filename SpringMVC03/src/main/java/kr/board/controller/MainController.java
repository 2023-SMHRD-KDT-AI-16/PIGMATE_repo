package kr.board.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.board.entity.Member;
import kr.board.mapper.FarmMapper;

@Controller
public class MainController {
	
	@RequestMapping("/")
	public String index(HttpSession session) {
		Member m = (Member) session.getAttribute("mvo");
		if(m != null) {
			return "index";
		}else {
			return "member/loginForm";
		}
	}
	
	@GetMapping("/farmEnv.do")
	public String farmEnv() {
		return "farm/FarmEnvList";
	}
	
	@GetMapping("/newsList.do")
	public String newsList() {
		return "board/newsBoardList";
	}
	
	@GetMapping("/news")
    public String news() {
    	return "board/newsBoardContent";
    }
	
	@GetMapping("/reportList.do")
	public String reportList() {
		return "board/reportContent";
	}
}




