package com.starshop.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class InfoController {

    @GetMapping("/about")
    public String about(Model model) {
        model.addAttribute("pageTitle", "Về chúng tôi");
        return "info/about";
    }
}
