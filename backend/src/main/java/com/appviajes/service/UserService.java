package com.appviajes.service;

import com.appviajes.model.dtos.RegisterRequest;
import com.appviajes.model.entities.UserEntity;
import com.appviajes.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository; 

   
    public UserEntity createUser(RegisterRequest registerRequest) {

        if (userRepository.findByEmail(registerRequest.getEmail()).isPresent()) {
            throw new RuntimeException("El usuario ya existe");
        }
        
        UserEntity newUser = new UserEntity();
        newUser.setEmail(registerRequest.getEmail());
        newUser.setPassword(registerRequest.getPassword()); //dsps encriptar

        
        userRepository.save(newUser);

        return newUser;
    }
}
