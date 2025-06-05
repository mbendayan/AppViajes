package com.appviajes.model.dtos;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class TravelUpdateRequest {
    private Long id;
    private String name;
    private String destination;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private PreferenciasRequest preferences;
    private List<TravelStepRequest> steps;
}