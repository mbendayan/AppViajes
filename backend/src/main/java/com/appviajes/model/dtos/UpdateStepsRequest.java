package com.appviajes.model.dtos;

import java.util.List;

import lombok.Data;

@Data
public class UpdateStepsRequest {
    private List<TravelStepRequest> steps;
}
