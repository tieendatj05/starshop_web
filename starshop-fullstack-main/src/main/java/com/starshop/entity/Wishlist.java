package com.starshop.entity;

import jakarta.persistence.*;
import lombok.Data;

// Explicitly importing classes, even from the same package, to help the compiler.
import com.starshop.entity.User;
import com.starshop.entity.Product;

@Entity
@Table(name = "Wishlist")
@Data
public class Wishlist {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    // Constructors
    public Wishlist() {}

    public Wishlist(User user, Product product) {
        this.user = user;
        this.product = product;
    }

    // Manual getters and setters to ensure compilation
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }
}
