package com.appviajes.controller;

import com.appviajes.model.dtos.RegisterRequest;
import com.appviajes.model.entities.UserEntity;
import com.appviajes.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public UserEntity register(@RequestBody RegisterRequest registerRequest) {
        return userService.createUser(registerRequest); 
    }
}
