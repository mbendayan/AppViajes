package com.appviajes.model.entities;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "travels")
public class TravelEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String name;

  @OneToOne(cascade = CascadeType.ALL)
  @JoinColumn(name = "preferences_id", referencedColumnName = "id")
  private Preferences preferences;

  private String destination;

  private LocalDateTime creationDate;

  private LocalDateTime startDate;

  private LocalDateTime endDate;

  @OneToMany(cascade = CascadeType.ALL)
  @JoinColumn(name = "travel_id", referencedColumnName = "id")
  private List<TravelStepEntity> steps;

  @ManyToMany(mappedBy = "travels")
  private List<UserEntity> savedByUsers;

}
