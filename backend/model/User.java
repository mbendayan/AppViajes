package com.appviajes.backend.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "users")
//Lombock:
@Data 
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String email;
    private String password;
}
