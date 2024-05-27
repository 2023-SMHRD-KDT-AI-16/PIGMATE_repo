package com.pigmate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {

	// main.jsp로 이동하는 기능
	@RequestMapping("/")
	public String index() {
		return "main";
	}
}
