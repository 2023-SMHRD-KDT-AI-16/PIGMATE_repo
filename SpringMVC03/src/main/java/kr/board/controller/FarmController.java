package kr.board.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import kr.board.entity.Farm;
import kr.board.entity.Member;
import kr.board.mapper.EnvMapper;
import kr.board.mapper.FarmMapper;
import kr.board.mapper.MemberMapper;


@Controller
public class FarmController {
	
	@Autowired
	private EnvMapper envMapper;

	@GetMapping("/envList.do")
	public String envList() {
		System.out.println("envList");
		return "farm/envList";
	}
}
