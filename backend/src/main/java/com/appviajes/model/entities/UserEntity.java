package com.appviajes.model.entities;

import java.util.ArrayList;
import java.util.List;

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
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "preferencias_id", referencedColumnName = "id")
    private Preferences preferencias;
    @ManyToMany
    @JoinTable(
        name = "user_saved_travels",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "travel_id") 
    )
    private List<TravelEntity> travels = new ArrayList<>();

}
