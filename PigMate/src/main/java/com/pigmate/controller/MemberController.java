package com.pigmate.controller;

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
import com.pigmate.entity.Member;
import com.pigmate.mapper.MemberMapper;

@Controller
public class MemberController {

	@Autowired
	private MemberMapper memberMapper;

	// 로그인 기능 /login.do
	@PostMapping("/login.do")
	public String login(Member mem, RedirectAttributes rttr, HttpSession session) {

		// 로그인 기능 콘솔 확인
		System.out.println("로그인 시도 : " + mem.toString());

		Member loginMem = memberMapper.login(mem); // memId, memPassword

		if (loginMem == null) {
			// 로그인 실패
			System.out.println("로그인 실패 : 아이디와 비밀번호를 다시 입력해주세요.");
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "아이디와 비밀번호를 다시 입력해주세요.");

			return "redirect:/loginForm.do";
		} else {
			// 로그인 성공
			System.out.println("로그인 성공 : " + loginMem.toString());
			rttr.addFlashAttribute("msgType", "성공 메세지");
			rttr.addFlashAttribute("msg", "환영합니다.");

			session.setAttribute("mem", loginMem);
			return "redirect:/";
		}
	}

	// 로그인 페이지로 이동 /loginForm.do
	@GetMapping("/loginForm.do")
	public String loginForm() {
		return "member/loginForm";
	}

	// 회원가입 기능 /join.do
	@PostMapping("/join.do")
	public String join(Member mem, RedirectAttributes rttr, HttpSession session) { // memId, memPassword, memName ...

		// 회원가입 기능 콘솔 확인
		System.out.println("회원가입 시도 :" + mem.toString());

		if (mem.getMem_id() == null || mem.getMem_id().equals("") || mem.getMem_pw() == null
				|| mem.getMem_pw().equals("") || mem.getMem_name() == null || mem.getMem_name().equals("")) {

			// 회원가입 실패 시
			System.out.println("회원가입 실패 : 모든 내용을 입력해주세요. ");
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "모든 내용을 입력해주세요.");

			return "redirect:/joinForm.do"; // joinForm.jsp로 가주라는 요청

		} else {
			// 회원가입 성공
			System.out.println("회원가입 성공 : " + mem.toString());
			rttr.addFlashAttribute("msgType", "성공 메세지");
			rttr.addFlashAttribute("msg", "회원가입에 성공했습니다.");

			// 회원가입 성공 시 로그인 유지시키기
			session.setAttribute("mem", mem);

			return "redirect:/"; // main.jsp로 가주라는 요청
		}
	}

	// 로그아웃 기능 /logout.do
	@GetMapping("/logout.do")
	public String logout(HttpSession session, RedirectAttributes rttr) {

		// session에 남은 모든 mem 정보 지우기
		System.out.println("로그아웃 :" + session.getAttribute("mem"));
		
		session.removeAttribute("mem");

		rttr.addFlashAttribute("msgType", "로그아웃 메세지");
		rttr.addFlashAttribute("msg", "정상적으로 로그아웃 되었습니다.");

		return "redirect:/";
	}

}
