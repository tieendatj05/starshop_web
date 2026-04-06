package com.starshop.controller.admin;

import com.starshop.config.CustomUserDetails;
import com.starshop.dto.ShopCommissionDTO;
import com.starshop.entity.Shop;
import com.starshop.entity.User;
import com.starshop.repository.ShopRepository;
import com.starshop.service.ShopCommissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin/commissions")
public class AdminCommissionController {

    @Autowired
    private ShopCommissionService commissionService;

    @Autowired
    private ShopRepository shopRepository;

    @GetMapping
    public String listCommissions(Model model,
                                  @RequestParam(required = false) Integer month,
                                  @RequestParam(required = false) Integer year) {
        List<ShopCommissionDTO> commissions;

        if (month != null && year != null) {
            commissions = commissionService.getCommissionsByMonthAndYear(month, year);
            model.addAttribute("selectedMonth", month);
            model.addAttribute("selectedYear", year);
        } else {
            commissions = commissionService.getAllCommissions();
            LocalDateTime now = LocalDateTime.now();
            model.addAttribute("selectedMonth", now.getMonthValue());
            model.addAttribute("selectedYear", now.getYear());
        }

        model.addAttribute("commissions", commissions);
        model.addAttribute("shops", shopRepository.findAll());
        return "admin/commission/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        List<Shop> shops = shopRepository.findAll();
        model.addAttribute("shops", shops);

        LocalDateTime now = LocalDateTime.now();
        model.addAttribute("currentMonth", now.getMonthValue());
        model.addAttribute("currentYear", now.getYear());

        return "admin/commission/create";
    }

    @PostMapping("/create")
    public String createCommission(@RequestParam Integer shopId,
                                   @RequestParam Integer month,
                                   @RequestParam Integer year,
                                   @RequestParam BigDecimal percentage,
                                   Authentication authentication,
                                   RedirectAttributes redirectAttributes) {
        try {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            User admin = userDetails.getUser();
            commissionService.createOrUpdateCommission(shopId, month, year, percentage, admin);
            redirectAttributes.addFlashAttribute("success", "Tạo chiết khấu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/commissions";
    }

    @PostMapping("/{id}/calculate")
    public String calculateCommission(@PathVariable Integer id,
                                     RedirectAttributes redirectAttributes) {
        try {
            ShopCommissionDTO commission = commissionService.getCommissionById(id);
            if (commission == null) {
                redirectAttributes.addFlashAttribute("error", "Commission không tồn tại!");
                return "redirect:/admin/commissions";
            }

            commissionService.calculateCommission(
                commission.getShopId(),
                commission.getCommissionMonth(),
                commission.getCommissionYear()
            );
            redirectAttributes.addFlashAttribute("success", "Tính toán chiết khấu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/commissions";
    }

    @PostMapping("/{id}/mark-paid")
    public String markAsPaid(@PathVariable Integer id,
                            RedirectAttributes redirectAttributes) {
        try {
            commissionService.markAsPaid(id);
            redirectAttributes.addFlashAttribute("success", "Đã đánh dấu là đã thanh toán!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/commissions";
    }

    @GetMapping("/{id}/details")
    public String viewDetails(@PathVariable Integer id, Model model) {
        ShopCommissionDTO commission = commissionService.getCommissionById(id);
        if (commission == null) {
            return "redirect:/admin/commissions";
        }
        model.addAttribute("commission", commission);
        return "admin/commission/details";
    }
}
