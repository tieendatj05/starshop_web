package com.starshop.dto;

import com.starshop.entity.Shop;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ShopDTO {
    private Integer id;
    private String name;
    private boolean active;

    // Thêm getter/setter methods thủ công
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public static ShopDTO fromEntity(Shop shop) {
        if (shop == null) {
            return null;
        }
        ShopDTO dto = new ShopDTO();
        dto.setId(shop.getId());
        dto.setName(shop.getName());
        dto.setActive("APPROVED".equals(shop.getStatus()));
        return dto;
    }
}
