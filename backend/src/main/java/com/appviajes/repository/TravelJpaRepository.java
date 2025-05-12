package com.appviajes.repository;

import com.appviajes.model.entities.TravelEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TravelJpaRepository extends JpaRepository<TravelEntity, Long> {

}
