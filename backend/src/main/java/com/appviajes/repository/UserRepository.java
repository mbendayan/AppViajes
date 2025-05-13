package com.appviajes.repository;

import com.appviajes.model.entities.UserEntity;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {
   Optional<UserEntity> findByEmail(String email);
}
