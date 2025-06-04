package com.appviajes.model.dtos;

import lombok.Data;

@Data
public class RespondInviteRequest {
    private String response; // "ACCEPTED" o "REJECTED"
}

