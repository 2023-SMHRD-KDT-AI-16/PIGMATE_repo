package kr.board.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.board.entity.Farm;
import kr.board.entity.Member;
import kr.board.mapper.FarmMapper;

@Controller
public class MainController {

	@RequestMapping("/")
	public String index(HttpSession session) {
		Member m = (Member) session.getAttribute("mvo");
		if (m != null) {
			return "index";
		} else {
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
		return "board/reportList";
	}

	@GetMapping("/PigInfo.do")
	public String PigInfo(@RequestParam("farmId") int farmId, Model model) {
		List<Farm> penInfoList = FarmMapper.getPenInfo(farmId);
		model.addAttribute("penInfoList", penInfoList);
		return "farm/PigInfo";
	}

}