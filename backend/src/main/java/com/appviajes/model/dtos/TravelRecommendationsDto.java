package com.appviajes.model.dtos;

import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
@Data
@AllArgsConstructor
public class TravelRecommendationsDto {
    private List<String> clothing;
    private List<String> essentials;
    private List<String> transport;
    private List<String> activities;
    private List<String> gastronomy;
    private String temperature;

public TravelRecommendationsDto() {
    this.clothing = new ArrayList<>();
    this.essentials = new ArrayList<>();
    this.transport = new ArrayList<>();
    this.activities = new ArrayList<>();
    this.gastronomy = new ArrayList<>();
    this.temperature = "";
}

    
}
