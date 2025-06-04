package com.appviajes.controller;

import com.appviajes.model.dtos.CreateTravelRequest;
import com.appviajes.model.dtos.CreateTravelResponse;
import com.appviajes.model.dtos.InviteRequest;
import com.appviajes.model.dtos.TravelStepRequest;
import com.appviajes.model.dtos.TravelStepsRequest;
import com.appviajes.model.entities.TravelEntity;
import com.appviajes.service.TravelService;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/travels")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
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

  @GetMapping("/steps")
  public ResponseEntity<TravelStepsRequest> getTravelSteps(@PathVariable("travel_id") Long Id) {
    TravelStepsRequest steps = travelService.getTravelStepsById(Id);
      return ResponseEntity.ok(steps);
  }
  @GetMapping("/steps/{step_id}")
public ResponseEntity<TravelStepRequest> getTravelStep(@PathVariable("step_id") Long stepId) {
  TravelStepRequest step = travelService.getTravelStepById(stepId);
    return ResponseEntity.ok(step);
}
@PostMapping("/{userId}/invite")
public ResponseEntity<?> invitarUsuario(@PathVariable Long userId, @RequestBody InviteRequest request) {
    try {
        travelService.enviarInvitacion(userId, request);
        return ResponseEntity.ok("Invitación enviada con éxito");
    } catch (RuntimeException e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
    }
}

}
