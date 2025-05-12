package com.appviajes.repository;

import com.appviajes.model.entities.TravelEntity;
import java.util.Optional;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TravelJpaRepository extends JpaRepository<TravelEntity, Long> {

  @EntityGraph(attributePaths = "steps")
  Optional<TravelEntity> findWithStepsById(Long id);
}
