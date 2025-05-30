package com.appviajes.controller;

import com.appviajes.model.dtos.CreateTravelRequest;
import com.appviajes.model.dtos.CreateTravelResponse;
import com.appviajes.model.entities.TravelEntity;
import com.appviajes.service.TravelService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/travels")
@RequiredArgsConstructor
// TODO: fix
public class TravelController {

  private final TravelService travelService;

  @PostMapping("/create")
  public ResponseEntity<CreateTravelResponse> createTravel(
      @RequestBody CreateTravelRequest request) {
    TravelEntity entity = travelService.createTravel(request);
    return ResponseEntity.ok(new CreateTravelResponse(entity));
  }

  @GetMapping("/{travel_id}")
  public ResponseEntity<CreateTravelResponse> findTravel(
      @PathVariable(value = "travel_id") Long id) {
    TravelEntity entity = travelService.findTravel(id);
    return ResponseEntity.ok(new CreateTravelResponse(entity));
  }
}
