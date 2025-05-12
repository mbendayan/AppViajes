package com.appviajes.model.dtos;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public record CreateTravelResponse(
    Long id,
    String name,
    String preferences,
    String destination,
    List<CreateTravelStepResponse> steps
) {
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
  ) { }
}
