package com.appviajes.model.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "users")
@Data 
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String email;
    private String password;
}
