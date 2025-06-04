package com.appviajes.model.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "travel_invitations")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TravelInvitationEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "travel_id", nullable = false)
    private TravelEntity travel;

    @ManyToOne
    @JoinColumn(name = "inviter_id", nullable = false)
    private UserEntity inviter;

    @ManyToOne
    @JoinColumn(name = "invited_id", nullable = false)
    private UserEntity invited;

    @Column(nullable = false)
    private String status = "PENDING"; // PENDING, ACCEPTED, DECLINED
}
