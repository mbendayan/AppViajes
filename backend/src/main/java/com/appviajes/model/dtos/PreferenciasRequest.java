package com.appviajes.model.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PreferenciasRequest {

    private String presupuesto;
    private String tipoViaje;          
    private String tipoAlojamiento;    
    private String tipoTransporte;     
}
