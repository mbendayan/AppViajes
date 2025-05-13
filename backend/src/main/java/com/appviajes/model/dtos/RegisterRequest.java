package com.appviajes.model.dtos;

import lombok.Data;

@Data
public class RegisterRequest {
    private String email;
    private String password;
}

