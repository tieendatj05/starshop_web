package com.starshop.controller;

import com.starshop.entity.Address;
import com.starshop.entity.User;
import com.starshop.service.AddressService;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/addresses")
public class AddressController {

    @Autowired
    private AddressService addressService;

    @Autowired
    private UserService userService;

    // Hiển thị danh sách địa chỉ
    @GetMapping
    public String listAddresses(Model model) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        List<Address> addresses = addressService.getAddressesForUser(currentUser);
        model.addAttribute("addresses", addresses);
        return "user/address-book"; // Cập nhật đường dẫn view
    }

    // Hiển thị form thêm địa chỉ mới
    @GetMapping("/new")
    public String showAddAddressForm(Model model) {
        model.addAttribute("address", new Address());
        model.addAttribute("pageTitle", "Thêm Địa Chỉ Mới");
        return "user/address-form"; // Cập nhật đường dẫn view
    }

    // Hiển thị form chỉnh sửa địa chỉ
    @GetMapping("/edit/{id}")
    public String showEditAddressForm(@PathVariable("id") Integer id, Model model) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        Address address = addressService.getAddressById(id, currentUser)
                .orElseThrow(() -> new SecurityException("Địa chỉ không tồn tại hoặc bạn không có quyền truy cập."));
        
        model.addAttribute("address", address);
        model.addAttribute("pageTitle", "Chỉnh Sửa Địa Chỉ");
        return "user/address-form"; // Cập nhật đường dẫn view
    }

    // Lưu (thêm mới hoặc cập nhật) địa chỉ
    @PostMapping("/save")
    public String saveAddress(@ModelAttribute("address") Address address, RedirectAttributes ra) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        addressService.saveAddress(address, currentUser);
        ra.addFlashAttribute("successMessage", "Đã lưu địa chỉ thành công!");
        return "redirect:/addresses";
    }

    // Xóa địa chỉ
    @PostMapping("/delete/{id}")
    public String deleteAddress(@PathVariable("id") Integer id, RedirectAttributes ra) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        try {
            addressService.deleteAddress(id, currentUser);
            ra.addFlashAttribute("successMessage", "Đã xóa địa chỉ thành công!");
        } catch (SecurityException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/addresses";
    }

    // Đặt làm địa chỉ mặc định
    @PostMapping("/default/{id}")
    public String setDefaultAddress(@PathVariable("id") Integer id, RedirectAttributes ra) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        try {
            addressService.setDefaultAddress(id, currentUser);
            ra.addFlashAttribute("successMessage", "Đã đặt địa chỉ mặc định thành công!");
        } catch (SecurityException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/addresses";
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication.getPrincipal().equals("anonymousUser")) {
            return null;
        }
        return userService.findByUsername(authentication.getName()).orElse(null);
    }
}
