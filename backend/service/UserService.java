package com.appviajes.backend.service;

import com.appviajes.backend.dto.RegisterRequest;
import com.appviajes.backend.model.User;
import com.appviajes.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository; 

   
    public boolean createUser(RegisterRequest registerRequest) {
        
        User newUser = new User();
        newUser.setEmail(registerRequest.getEmail());
        newUser.setPassword(registerRequest.getPassword()); //dsps encriptar

        
        userRepository.save(newUser);

        return true; 
    }
}
