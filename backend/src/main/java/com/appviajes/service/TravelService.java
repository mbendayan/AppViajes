package com.appviajes.service;

import static com.appviajes.model.enums.ErrorEnum.TRAVEL_NOT_FOUND;
import static java.lang.String.join;

import com.appviajes.client.AIClient;
import com.appviajes.exception.RestException;
import com.appviajes.model.dtos.CreateTravelRequest;
import com.appviajes.model.dtos.InviteRequest;
import com.appviajes.model.dtos.PreferenciasRequest;
import com.appviajes.model.dtos.TravelStepRequest;
import com.appviajes.model.dtos.TravelStepsRequest;
import com.appviajes.model.entities.Preferences;
import com.appviajes.model.entities.TravelEntity;
import com.appviajes.model.entities.TravelInvitationEntity;
import com.appviajes.model.entities.TravelStepEntity;
import com.appviajes.model.entities.UserEntity;
import com.appviajes.model.enums.PresupuestoEnum;
import com.appviajes.model.enums.TipoAlojamientoEnum;
import com.appviajes.model.enums.TipoTransporteEnum;
import com.appviajes.model.enums.TipoViajeEnum;
import com.appviajes.repository.TravelInvitationRepository;
import com.appviajes.repository.TravelJpaRepository;
import com.appviajes.repository.TravelStepRepository;
import com.appviajes.repository.UserRepository;

import jakarta.transaction.Transactional;

import java.time.LocalDateTime;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class TravelService {

  private final AIClient aiClient;
  @Autowired
  private final TravelJpaRepository travelRepository;
  @Autowired
  private final TravelStepRepository travelStepRepository;
  @Autowired
  private UserRepository userRepository;
  @Autowired
  private TravelInvitationRepository invitationRepository;


  public TravelEntity findTravel(Long id) {
    return travelRepository
        .findWithStepsById(id)
        .orElseThrow(() -> new RestException(TRAVEL_NOT_FOUND));
  }

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
    travelEntity.setPreferences(mapToPreferences(request.preferences()));
    travelEntity.setDestination(request.destination());
    travelEntity.setCreationDate(LocalDateTime.now());
    travelEntity.setStartDate(request.startDate());
    travelEntity.setEndDate(request.endDate());
    travelEntity.setSteps(new LinkedList<>());
    log.info("Travel built successfully");
    return travelEntity;
  }

  public TravelStepRequest getTravelStepById(Long stepId) {

    TravelStepEntity step = travelStepRepository.findById(stepId)
        .orElseThrow(() -> new RuntimeException("Travel step no encontrado"));

    return new TravelStepRequest(
        step.getId(),
        step.getName(),
        step.getDescription(),
        step.getLocation(),
        step.getStartDate(),
        step.getEndDate(),
        step.getCost(),
        step.getRecommendations()
    );
}
public TravelStepsRequest getTravelStepsById(Long id) {
    TravelEntity travel = travelRepository.findWithStepsById(id)
        .orElseThrow(() -> new RuntimeException("Travel steps no encontrados"));

   
    List<TravelStepRequest> stepRequests = travel.getSteps().stream()
        .map(step -> new TravelStepRequest(
            step.getId(),
            step.getName(),
            step.getDescription(),
            step.getLocation(),
            step.getStartDate(),
            step.getEndDate(),
            step.getCost(),
            step.getRecommendations()
        ))
        .collect(Collectors.toList());

    
    return new TravelStepsRequest(stepRequests);
}

private Preferences mapToPreferences(PreferenciasRequest request) {
    Preferences preferences = new Preferences();
    preferences.setPresupuesto(PresupuestoEnum.valueOf(request.getPresupuesto().toUpperCase()));
    preferences.setMontoPersonalizado(request.getMontoPersonalizado());
    preferences.setTipoViaje(TipoViajeEnum.valueOf(request.getTipoViaje().toUpperCase()));
    preferences.setTipoAlojamiento(TipoAlojamientoEnum.valueOf(request.getTipoAlojamiento().toUpperCase()));
    preferences.setTipoTransporte(TipoTransporteEnum.valueOf(request.getTipoTransporte().toUpperCase()));
    return preferences;
}
public void enviarInvitacion(Long invitadorId, InviteRequest request) {
    UserEntity invitador = userRepository.findById(invitadorId)
        .orElseThrow(() -> new RuntimeException("Usuario que invita no encontrado"));

    UserEntity invitado = userRepository.findByEmail(request.getInvitedUserEmail())
        .orElseThrow(() -> new RuntimeException("Usuario invitado no encontrado"));

    TravelEntity viaje = travelRepository.findById(request.getTravelId())
        .orElseThrow(() -> new RuntimeException("Viaje no encontrado"));

    TravelInvitationEntity invitacion = new TravelInvitationEntity();
    invitacion.setInviter(invitador);
    invitacion.setInvited(invitado);
    invitacion.setTravel(viaje);
    invitacion.setStatus("PENDING");

    invitationRepository.save(invitacion);
}
@Transactional
public void responderInvitacion(Long userId, Long invitationId, String response) {
    TravelInvitationEntity invitation = invitationRepository.findById(invitationId)
        .orElseThrow(() -> new RuntimeException("Invitación no encontrada"));

    if (!invitation.getInvited().getId().equals(userId)) {
        throw new RuntimeException("No estás autorizado para responder esta invitación");
    }

    String respuesta = response.toUpperCase();
    if (!respuesta.equals("ACCEPTED") && !respuesta.equals("REJECTED")) {
        throw new RuntimeException("Respuesta inválida. Usa ACCEPTED o REJECTED.");
    }

    invitation.setStatus(respuesta);

    if (respuesta.equals("ACCEPTED")) {
        TravelEntity travel = invitation.getTravel();
        UserEntity user = invitation.getInvited();

        user.getTravels().add(travel);
        travel.getSavedByUsers().add(user);

        userRepository.save(user);
        travelRepository.save(travel);
    }

    invitationRepository.save(invitation);
}




}
