package com.appviajes.model.dtos;

import com.appviajes.model.entities.Preferences;

public record PreferenciasResponse(
    String presupuesto,
    Double montoPersonalizado,
    String tipoViaje,
    String tipoAlojamiento,
    String tipoTransporte
) {
    public PreferenciasResponse(Preferences preferences) {
        this(
            preferences.getPresupuesto().name(),
            preferences.getMontoPersonalizado(),
            preferences.getTipoViaje().name(),
            preferences.getTipoAlojamiento().name(),
            preferences.getTipoTransporte().name()
        );
    }
}
