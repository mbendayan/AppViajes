package com.appviajes.backend.controller;

import com.appviajes.backend.dto.RegisterRequest;
import com.appviajes.backend.model.User;
import com.appviajes.backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public User register(@RequestBody RegisterRequest registerRequest) {
        return userService.createUser(registerRequest); 
    }
}
