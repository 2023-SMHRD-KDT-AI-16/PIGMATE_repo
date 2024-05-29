package kr.board.controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import kr.board.entity.Member;
import kr.board.mapper.MemberMapper;

@Controller
public class MemberController {

	@Autowired
	private MemberMapper memberMapper;


	// 로그인 기능 /login.do
	@PostMapping("/login.do")
	public String login(Member m, RedirectAttributes rttr, HttpSession session) {
		// 문제
		// 로그인 기능 구현
		// 입력한 아이디와 비밀번호 일치하는 회원을 검색하여
		// 로그인 성공 시
		// - session에 mvo이름으로 회원의 정보를 저장 index.jsp에서 "로그인에 성공했습니다." 모달창
		// 로그인 실패 시
		// - loginForm.jsp로 이동 후 "아이디와 비밀번호를 다시 입력해주세요." 모달창
		System.out.println(m.getMem_id());
		Member mvo = memberMapper.login(m);
		if (mvo == null) {
			// 로그인 실패
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "아이디와 비밀번호를 입력해주세요.");
			System.out.println("로그인 실패");
			return "redirect:/loginForm.do";
		} else {
			// 로그인 성공
			rttr.addFlashAttribute("msgType", "성공 메세지");
			rttr.addFlashAttribute("msg", "로그인에 성공했습니다.");
			System.out.println("로그인 성공" + mvo.getMem_id());
			session.setAttribute("mvo", mvo);
			return "redirect:/";
		}

	}

	// 로그인 페이지 이동 /loginForm.do
	@GetMapping("/loginForm.do")
	public String loginForm() {
		return "member/loginForm";
	}

	// 로그아웃 기능 /logout.do
	@GetMapping("/logout.do")
	public String logout(HttpSession session, RedirectAttributes rttr) {
		session.invalidate();
		rttr.addFlashAttribute("msgType", "로그아웃 메세지");
		rttr.addFlashAttribute("msg", "정상적으로 로그아웃 되었습니다.");
		return "redirect:/";
	}


}
