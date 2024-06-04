package kr.board.controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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

		// 로그인 기능 구현

		// 성공 시 session에 mvo 이름으로 회원의 정보를 저장 => index.jsp에서 "로그인에 성공했습니다." 모달창
		// 실패 시 loginForm.jsp로 이동 후 "아이디와 비밀번호를 다시 입력해주세요." 모달창

		// System.out.println(m.getMem_id());

		Member mvo = memberMapper.login(m);
		if (mvo == null) {
			// 로그인 실패
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "아이디와 비밀번호를 입력해주세요.");
			// System.out.println("로그인 실패");
			return "redirect:/loginForm.do";
		} else {
			// 로그인 성공
			rttr.addFlashAttribute("msgType", "성공 메세지");
			rttr.addFlashAttribute("msg", "로그인에 성공했습니다.");
			// System.out.println("로그인 성공 " + mvo.getMem_id());
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
	    return "redirect:/loginForm.do"; // 로그인 페이지로 리디렉션
	}
	
	// 회원가입 페이지로 이동 /joinForm.do
	@GetMapping("/joinForm.do")
	public String joinForm() {
		return "member/joinForm";
	}

	// 아이디 중복체크 기능 /idCheck.do
	@GetMapping("/idCheck.do")
	public @ResponseBody int idCheck(@RequestParam("mem_id") String mem_id) {
		Member m = memberMapper.getMember(mem_id);
		// m = null -> 사용 가능한 아이디 -> 1
		// m != null -> 사용 불가능한 아이디 -> 0

		if (m == null) {
			System.out.println("사용 가능한 아이디 " + mem_id);
			return 1;
		} else {
			System.out.println("사용 불가능한 아이디 " + m.getMem_id());
			return 0;
		}
	}

	@PostMapping("/join.do")
	public String join(Member m, RedirectAttributes rttr, HttpSession session, Model model) {
	    if (m.getMem_id() == null || m.getMem_id().equals("") || m.getMem_pw() == null || m.getMem_pw().equals("")
	            || m.getMem_name() == null || m.getMem_name().equals("") || m.getMem_phone() == null
	            || m.getMem_phone().equals("") || m.getMem_email() == null || m.getMem_email().equals("")) {
	    	
	        // 회원가입 실패 시
	        System.out.println("회원가입 실패");
	        rttr.addFlashAttribute("msgType", "실패 메세지");
	        rttr.addFlashAttribute("msg", "모든 내용을 입력해주세요.");
	        return "redirect:/joinForm.do";
	    } else {
	        // 회원가입 성공
	        memberMapper.join(m);
	        System.out.println("회원가입 성공 " + m.getMem_id());
	        rttr.addFlashAttribute("msgType", "성공 메세지");
	        rttr.addFlashAttribute("msg", "회원가입에 성공했습니다.");
	        // 회원가입 성공 시 로그인 처리
	        session.setAttribute("mvo", m);
	        model.addAttribute("mm", m);
	        System.out.println("로그인 성공 " + m.getMem_id());
	        return "redirect:/myPage.do";
	    }
	}


	// 마이 페이지 이동 /myPage.do
	@GetMapping("/myPage.do")
	public String myPage(HttpSession session, Model model) {

		// 세션에서 로그인 된 사용자 정보 가져오기
		Member m = (Member) session.getAttribute("mvo");

		if (m == null) {
			return "redirect:/loginForm.do";
		}

		// 모델에 회원 정보 추가
		model.addAttribute("member", m);

		// System.out.println("myPage");
		return "member/myPage";
	}

	// 마이 페이지 - 회원정보 수정 기능 /update.do
	@PostMapping("/update.do")
	public String update(Member m, HttpSession session) {

		// System.out.println(m);
		memberMapper.update(m);
		session.setAttribute("mvo", m);
		// System.out.println("업데이트 성공 " + m.getMem_name());

		return "redirect:/myPage.do";
	}

}