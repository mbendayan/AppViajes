package com.appviajes.model.dtos;

import lombok.Data;

@Data
public class InviteRequest {
    private Long travelId;
    private String invitedUserEmail;
}
