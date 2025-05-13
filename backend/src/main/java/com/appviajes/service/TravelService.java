package com.appviajes.service;

import static com.appviajes.model.enums.ErrorEnum.TRAVEL_NOT_FOUND;
import static java.lang.String.join;

import com.appviajes.client.AIClient;
import com.appviajes.exception.RestException;
import com.appviajes.model.dtos.CreateTravelRequest;
import com.appviajes.model.entities.TravelEntity;
import com.appviajes.model.entities.TravelStepEntity;
import com.appviajes.repository.TravelJpaRepository;
import java.time.LocalDateTime;
import java.util.LinkedList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class TravelService {

  private final AIClient aiClient;
  private final TravelJpaRepository travelRepository;

  public TravelEntity findTravel(Long id) {
    return travelRepository
        .findWithStepsById(id)
        .orElseThrow(() -> new RestException(TRAVEL_NOT_FOUND));
  }

  // TODO: TODO: add user id findByNameAndUserId
  public TravelEntity createTravel(CreateTravelRequest request) {
    return travelRepository.findByName(request.name())
        .orElseGet(() -> {
          TravelEntity travelEntity = buildTravelEntity(request);
          travelEntity.setSteps(buildTravelStepEntity(travelEntity));
          return travelRepository.save(travelEntity);
        });
  }

  private List<TravelStepEntity> buildTravelStepEntity(TravelEntity travelEntity) {
    return aiClient.generateTravelSteps(travelEntity);
  }

  private TravelEntity buildTravelEntity(CreateTravelRequest request) {
    TravelEntity travelEntity = new TravelEntity();
    travelEntity.setName(request.name());
    travelEntity.setPreferences(join(", ", request.preferences()));
    travelEntity.setDestination(request.destination());
    travelEntity.setCreationDate(LocalDateTime.now());
    travelEntity.setStartDate(request.startDate());
    travelEntity.setEndDate(request.endDate());
    travelEntity.setSteps(new LinkedList<>());
    log.info("Travel built successfully");
    return travelEntity;
  }
}
