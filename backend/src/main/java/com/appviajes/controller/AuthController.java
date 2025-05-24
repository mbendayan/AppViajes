package com.appviajes.controller;

import com.appviajes.model.dtos.CreateTravelRequest;
import com.appviajes.model.dtos.CreateTravelResponse;
import com.appviajes.model.dtos.LoginRequest;
import com.appviajes.model.dtos.RegisterRequest;
import com.appviajes.model.entities.JwtResponse;
import com.appviajes.model.entities.TravelEntity;
import com.appviajes.model.entities.UserEntity;
import com.appviajes.repository.UserRepository;
import com.appviajes.config.JwtUtil;
import com.appviajes.service.TravelService;
import com.appviajes.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {


    private final TravelService travelService;

    @Autowired
    private UserService userService;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        try {
            authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                    loginRequest.getEmail(),
                    loginRequest.getPassword()
                )
            );
           
            String token = jwtUtil.generateToken(loginRequest.getEmail());
            return ResponseEntity.ok(new JwtResponse(token));

        } catch (BadCredentialsException ex) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Credenciales incorrectas");
        }
    }
    @PostMapping("/register")
    public UserEntity register(@RequestBody RegisterRequest registerRequest) {
        return userService.createUser(registerRequest);
    }

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

