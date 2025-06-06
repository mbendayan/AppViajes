package com.appviajes.model.dtos;

import com.appviajes.model.entities.TravelEntity;
import com.appviajes.model.entities.TravelStepEntity;
import com.appviajes.model.entities.UserEntity;
import jakarta.persistence.CascadeType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.OneToMany;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class TravelDto {
    private Long id;

    private String name;

    private String preferences;

    private String destination;

    private LocalDateTime creationDate;

    private LocalDateTime startDate;

    private LocalDateTime endDate;

    private List<TravelStepEntity> steps;


    public static TravelDto from(TravelEntity travel){
        TravelDto travelDto = new TravelDto();
        travelDto.setDestination(travel.getDestination());
        travelDto.setId(travel.getId());
        travelDto.setName(travel.getName());
        travelDto.setCreationDate(travel.getCreationDate());
        travelDto.setStartDate(travel.getStartDate());
        travelDto.setEndDate(travel.getEndDate());
        travelDto.setPreferences(travel.getPreferences());
        travelDto.setSteps(travel.getSteps());
        return travelDto;
    }
}
