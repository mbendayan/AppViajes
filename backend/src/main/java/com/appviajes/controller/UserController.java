package com.appviajes.controller;


import com.appviajes.model.dtos.LoginRequest;
import com.appviajes.model.dtos.PreferenciasRequest;
import com.appviajes.model.dtos.RegisterRequest;
import com.appviajes.model.dtos.RespondInviteRequest;
import com.appviajes.model.entities.TravelInvitationEntity;
import com.appviajes.model.entities.UserEntity;
import com.appviajes.repository.UserRepository;
import com.appviajes.service.TravelService;
import com.appviajes.service.UserService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/users")
public class UserController {
   
 

    @Autowired
    private UserService userService;
    
    @Autowired
    private UserRepository userRepository;
  
      
    @Autowired
    private TravelService travelService;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest registerRequest) {
        try {
            UserEntity newUser = userService.createUser(registerRequest);
            return ResponseEntity.ok(newUser);
        } catch (RuntimeException e) {
            return ResponseEntity
                    .status(HttpStatus.CONFLICT)
                    .body(e.getMessage());
        }
    }

   @PostMapping("/login")
public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
    try {
        boolean valid = userService.validateCredentials(loginRequest.getEmail(), loginRequest.getPassword());
        if (!valid) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Credenciales incorrectas");
        }

       
                UserEntity user = userRepository.findByEmail(loginRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Map<String, Object> response = new HashMap<>();
        response.put("id", user.getId());
        response.put("email", user.getEmail());

        return ResponseEntity.ok(response);

    } catch (Exception ex) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Error de autenticación");
    }
}

    @GetMapping("/{userId}/preferences")
    public ResponseEntity<?> getUserPreferences(@PathVariable Long userId) {
        PreferenciasRequest preferencesDTO = userService.getUserPreferences(userId);
        return ResponseEntity.ok(preferencesDTO);
    }

     
    @PostMapping("/{userId}/preferences")
    public ResponseEntity<?> setUserPreferences(@PathVariable Long userId,@RequestBody PreferenciasRequest request) {
        try {
            userService.setUserPreferences(userId, request);
            return ResponseEntity.ok("Preferencias actualizadas correctamente");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    
    }

    @DeleteMapping("/{userId}/deletepreferences")
    public ResponseEntity<?> clearUserPreferences(@PathVariable Long userId) {
    try {
        userService.clearUserPreferences(userId);
        return ResponseEntity.ok("Preferencias eliminadas correctamente");
    } catch (RuntimeException e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
    }
}

    
    @PostMapping("/{userId}/savetravel/{travelId}")
    public ResponseEntity<?> saveTravelToUser(@PathVariable Long userId, @PathVariable Long travelId) {
        try {
            userService.guardarViajeParaUsuario(userId, travelId);
            return ResponseEntity.ok("Viaje guardado para el usuario");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PostMapping("/{userId}/invitations/{invitationId}/respond")
public ResponseEntity<?> respondToInvitation(@PathVariable Long userId, @PathVariable Long invitationId, @RequestBody RespondInviteRequest request) {
    try {
        travelService.responderInvitacion(userId, invitationId, request.getResponse());
        return ResponseEntity.ok("Respuesta registrada correctamente.");
    } catch (RuntimeException e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
    }
}
@GetMapping("/{userId}/invitations/received")
public ResponseEntity<List<TravelInvitationEntity>> getReceivedInvitations(@PathVariable Long userId) {
    List<TravelInvitationEntity> invitations = userService.getReceivedInvitations(userId);
    return ResponseEntity.ok(invitations);
}

@GetMapping("/{userId}/invitations/sent")
public ResponseEntity<List<TravelInvitationEntity>> getSentInvitations(@PathVariable Long userId) {
    List<TravelInvitationEntity> invitations = userService.getSentInvitations(userId);
    return ResponseEntity.ok(invitations);
}



}
