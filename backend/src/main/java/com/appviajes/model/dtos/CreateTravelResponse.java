package com.appviajes.model.dtos;

import com.appviajes.model.entities.TravelEntity;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public record CreateTravelResponse(
    Long id,
    String name,
    PreferenciasResponse preferences,
    String destination,
    List<CreateTravelStepResponse> steps
) {

  public CreateTravelResponse(TravelEntity entity) {
    this(
        entity.getId(),
        entity.getName(),
        new PreferenciasResponse(entity.getPreferences()),
        entity.getDestination(),
        entity.getSteps().stream().map(stepEntity ->
            new CreateTravelStepResponse(
                stepEntity.getId(),
                stepEntity.getDescription(),
                stepEntity.getStartDate(),
                stepEntity.getEndDate(),
                stepEntity.getLocation(),
                stepEntity.getName(),
                stepEntity.getCost(),
                stepEntity.getRecommendations()
            )
        ).toList());
  }

  @JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
  public record CreateTravelStepResponse(
      Long id,
      String description,
      LocalDateTime startDate,
      LocalDateTime endDate,
      String location,
      String name,
      BigDecimal cost,
      String recommendations
  ) {

  }
}
