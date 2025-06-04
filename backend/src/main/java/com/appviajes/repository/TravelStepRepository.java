package com.appviajes.repository;

import com.appviajes.model.entities.TravelStepEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TravelStepRepository extends JpaRepository<TravelStepEntity, Long> {
}
