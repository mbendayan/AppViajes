package com.appviajes.repository;

import com.appviajes.model.entities.TravelInvitationEntity;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TravelInvitationRepository extends JpaRepository<TravelInvitationEntity, Long> {
    
    List<TravelInvitationEntity> findByInvitedId(Long id);  
    List<TravelInvitationEntity> findByInviterId(Long id);  

}
