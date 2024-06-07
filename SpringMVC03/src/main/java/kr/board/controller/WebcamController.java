package kr.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebcamController {

    @GetMapping("/webcam")
    public String getWebcamStream() {
        return "index";  // index.jsp를 렌더링
    }
}