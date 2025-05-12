package com.appviajes.controller;

import com.appviajes.model.dtos.CreateTravelRequest;
import com.appviajes.model.dtos.CreateTravelResponse;
import com.appviajes.model.entities.TravelEntity;
import com.appviajes.service.TravelService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/travels")
@RequiredArgsConstructor
// TODO: fix
public class TravelController {

  private final TravelService travelService;

  @PostMapping
  public ResponseEntity<CreateTravelResponse> createTravel(
      @RequestBody CreateTravelRequest request) {
    TravelEntity travel = travelService.createTravel(request);
    return ResponseEntity.ok(mapResponse(travel));
  }

  private CreateTravelResponse mapResponse(TravelEntity entity) {
    return new CreateTravelResponse(
        entity.getId(),
        entity.getName(),
        entity.getPreferences(),
        entity.getDestination(),
        entity.getSteps().stream().map(stepEntity ->
            new CreateTravelResponse.CreateTravelStepResponse(
                stepEntity.getId(),
                stepEntity.getDescription(),
                stepEntity.getStartDate(),
                stepEntity.getEndDate(),
                stepEntity.getLocation(),
                stepEntity.getName(),
                stepEntity.getCost(),
                stepEntity.getRecommendations()
            )).toList()
    );
  }
}
