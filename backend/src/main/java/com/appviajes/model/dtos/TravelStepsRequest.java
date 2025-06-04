package com.appviajes.model.dtos;

import java.util.List;

import com.appviajes.model.entities.TravelStepEntity;

import lombok.AllArgsConstructor;
import lombok.Data;
@Data
@AllArgsConstructor
public class TravelStepsRequest {
     private List<TravelStepRequest> steps;
}
