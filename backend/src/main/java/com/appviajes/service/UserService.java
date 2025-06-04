package com.appviajes.service;

import com.appviajes.model.dtos.PreferenciasRequest;
import com.appviajes.model.dtos.RegisterRequest;
import com.appviajes.model.entities.Preferences;
import com.appviajes.model.entities.TravelEntity;
import com.appviajes.model.entities.TravelInvitationEntity;
import com.appviajes.model.entities.UserEntity;
import com.appviajes.model.enums.PresupuestoEnum;
import com.appviajes.model.enums.TipoAlojamientoEnum;
import com.appviajes.model.enums.TipoTransporteEnum;
import com.appviajes.model.enums.TipoViajeEnum;
import com.appviajes.repository.TravelInvitationRepository;
import com.appviajes.repository.TravelJpaRepository;
import com.appviajes.repository.UserRepository;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TravelJpaRepository travelRepository;

    @Autowired
    private TravelInvitationRepository invitationRepository;

    public UserEntity createUser(RegisterRequest registerRequest) {
        if (userRepository.findByEmail(registerRequest.getEmail()).isPresent()) {
            throw new RuntimeException("El usuario ya existe");
        }

        UserEntity newUser = new UserEntity();
        newUser.setEmail(registerRequest.getEmail());
        newUser.setPassword(registerRequest.getPassword()); 

        userRepository.save(newUser);
        return newUser;
    }

    public boolean validateCredentials(String email, String password) {
        Optional<UserEntity> userOpt = userRepository.findByEmail(email);
        return userOpt.isPresent() && userOpt.get().getPassword().equals(password);
    }

    public PreferenciasRequest getUserPreferences(Long userId) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        return mapPreferencesToDTO(user.getPreferencias());
    }

    public void setUserPreferences(Long userId, PreferenciasRequest request) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Preferences preferences = new Preferences();

        try {
            preferences.setPresupuesto(PresupuestoEnum.valueOf(request.getPresupuesto()));
            preferences.setMontoPersonalizado(request.getMontoPersonalizado());
            preferences.setTipoViaje(TipoViajeEnum.valueOf(request.getTipoViaje()));
            preferences.setTipoAlojamiento(TipoAlojamientoEnum.valueOf(request.getTipoAlojamiento()));
            preferences.setTipoTransporte(TipoTransporteEnum.valueOf(request.getTipoTransporte()));
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Valor inválido en las preferencias: " + e.getMessage());
        }

        user.setPreferencias(preferences);
        userRepository.save(user);
    }

    public void clearUserPreferences(Long userId) {
        UserEntity user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    
        Preferences prefs = user.getPreferencias();
        if (prefs != null) {
            prefs.setPresupuesto(null);
            prefs.setMontoPersonalizado(null);
            prefs.setTipoViaje(null);
            prefs.setTipoAlojamiento(null);
            prefs.setTipoTransporte(null);
        }
    
        userRepository.save(user);
    }
    

    public List<TravelEntity> getTravels(Long userId) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        return user.getTravels();
    }

    private PreferenciasRequest mapPreferencesToDTO(Preferences preferences) {
        PreferenciasRequest dto = new PreferenciasRequest();
    
        if (preferences == null) {
            dto.setPresupuesto(null);
            dto.setMontoPersonalizado(0.0);
            dto.setTipoViaje(null);
            dto.setTipoAlojamiento(null);
            dto.setTipoTransporte(null);
            return dto;
        }
    
        dto.setPresupuesto(preferences.getPresupuesto() != null ? preferences.getPresupuesto().name() : null);
        dto.setMontoPersonalizado(preferences.getMontoPersonalizado() != null ? preferences.getMontoPersonalizado() : 0.0);
        dto.setTipoViaje(preferences.getTipoViaje() != null ? preferences.getTipoViaje().name() : null);
        dto.setTipoAlojamiento(preferences.getTipoAlojamiento() != null ? preferences.getTipoAlojamiento().name() : null);
        dto.setTipoTransporte(preferences.getTipoTransporte() != null ? preferences.getTipoTransporte().name() : null);
    
        return dto;
    }
    
    

    public void guardarViajeParaUsuario(Long userId, Long travelId) {
        UserEntity user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    
        TravelEntity travel = travelRepository.findById(travelId)
            .orElseThrow(() -> new RuntimeException("Viaje no encontrado"));
    
        if (!user.getTravels().contains(travel)) {
            user.getTravels().add(travel);
            travel.getSavedByUsers().add(user); 
            userRepository.save(user); 
        }
    }

    public List<TravelInvitationEntity> getReceivedInvitations(Long userId) {
  return invitationRepository.findByInvitedId(userId);
}

public List<TravelInvitationEntity> getSentInvitations(Long userId) {
  return invitationRepository.findByInviterId(userId);
}
}