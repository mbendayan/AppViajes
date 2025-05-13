package com.appviajes.model.dtos;

import com.fasterxml.jackson.databind.annotation.JsonNaming;
import java.time.LocalDateTime;
import java.util.List;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public record CreateTravelRequest(
    String name,
    String destination,
    LocalDateTime startDate,
    LocalDateTime endDate,
    // TODO: sanitize preferences with enum in request and in postgres
    List<String> preferences) { }
