package kr.board.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.board.mapper.FarmMapper;

@Controller
public class MainController {
	
	@RequestMapping("/")
	public String index() {
		return "index";
	}
	
	
	@GetMapping("/farmEnv.do")
	public String farmEnv() {
		return "farm/FarmEnvList";
	}
	
}




