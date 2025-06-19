package com.appviajes.model.dtos;

import com.appviajes.model.entities.TravelEntity;
import com.appviajes.model.entities.TravelInvitationEntity;
import com.appviajes.model.entities.TravelStepEntity;
import com.appviajes.model.entities.UserEntity;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class InvitationDto {

	    private Long id;
	    private String travelName;
	    private Long travelId;
	    private Long inviterId;
	    private Long invitedId;
	    private String status;
	    
    public static InvitationDto from(TravelInvitationEntity invitation){
        InvitationDto invitationDto = new InvitationDto();
        invitationDto.setId(invitation.getId());
        invitationDto.setInvitedId(invitation.getInvited().getId());
        invitationDto.setInviterId(invitation.getInviter().getId());
        invitationDto.setTravelName(invitation.getTravel().getName());
        invitationDto.setTravelId(invitation.getTravel().getId());
        invitationDto.setStatus(invitation.getStatus());
        return invitationDto;
    }
}
