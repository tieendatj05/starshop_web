package com.starshop.controller.admin;

import com.starshop.entity.ShippingCarrier;
import com.starshop.service.ShippingCarrierService;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.bind.annotation.ModelAttribute; // Thêm import này

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/admin/shipping-carriers")
public class AdminShippingCarrierController {

    // Manual log declaration to ensure compilation works
    private static final Logger log = LoggerFactory.getLogger(AdminShippingCarrierController.class);

    @Autowired
    private ShippingCarrierService shippingCarrierService;

    @GetMapping
    public String list(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<ShippingCarrier> carriers;
        if (keyword != null && !keyword.trim().isEmpty()) {
            carriers = shippingCarrierService.search(keyword);
            model.addAttribute("keyword", keyword);
        } else {
            carriers = shippingCarrierService.findAll();
        }
        log.info("Tìm thấy {} nhà vận chuyển để hiển thị trên trang admin.", carriers.size());
        model.addAttribute("carriers", carriers);
        return "admin/shipping_carrier/list";
    }

    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("carrier", new ShippingCarrier());
        return "admin/shipping_carrier/form";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        java.util.Optional<ShippingCarrier> carrierOpt = shippingCarrierService.findById(id);
        if (carrierOpt.isPresent()) {
            model.addAttribute("carrier", carrierOpt.get());
            return "admin/shipping_carrier/form";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy nhà vận chuyển!");
            return "redirect:/admin/shipping-carriers";
        }
    }

    @PostMapping("/save")
    public String save(@ModelAttribute("carrier") ShippingCarrier carrier, RedirectAttributes redirectAttributes) {
        shippingCarrierService.save(carrier);
        redirectAttributes.addFlashAttribute("successMessage", "Lưu nhà vận chuyển thành công!");
        return "redirect:/admin/shipping-carriers";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            shippingCarrierService.deleteById(id);
            redirectAttributes.addFlashAttribute("successMessage", "Xóa nhà vận chuyển thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể xóa nhà vận chuyển này!");
        }
        return "redirect:/admin/shipping-carriers";
    }
}
