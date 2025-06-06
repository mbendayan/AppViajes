package com.appviajes.model.dtos;

import com.appviajes.model.entities.Preferences;

public record PreferenciasResponse(
    String presupuesto,
    String tipoViaje,
    String tipoAlojamiento,
    String tipoTransporte
) {
    public PreferenciasResponse(Preferences preferences) {
        this(
            preferences.getPresupuesto(),
            preferences.getTipoViaje(),
            preferences.getTipoAlojamiento(),
            preferences.getTipoTransporte()
        );
    }
}
