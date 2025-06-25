package com.appviajes.model.dtos;

import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
@Data
@AllArgsConstructor
public class TravelRecommendationsDto {
    private List<String> Vestimenta;
    private List<String> Esenciales;
    private List<String> Transporte;
    private List<String> Actividades;
    private List<String> Gastronomia;
    private String Temperatura;

public TravelRecommendationsDto() {
    this.Vestimenta = new ArrayList<>();
    this.Esenciales = new ArrayList<>();
    this.Transporte = new ArrayList<>();
    this.Actividades = new ArrayList<>();
    this.Gastronomia = new ArrayList<>();
    this.Temperatura = "";
}

}
