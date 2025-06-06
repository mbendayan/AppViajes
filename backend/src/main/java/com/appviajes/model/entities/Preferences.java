package com.appviajes.model.entities;

import com.appviajes.model.enums.PresupuestoEnum;
import com.appviajes.model.enums.TipoAlojamientoEnum;
import com.appviajes.model.enums.TipoTransporteEnum;
import com.appviajes.model.enums.TipoViajeEnum;
import lombok.*;
import jakarta.persistence.*;

@Embeddable
@Data // incluye @Getter, @Setter, @ToString, etc.
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "preferences")
public class Preferences {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String presupuesto; // solo si elige PERSONALIZADO


    private String tipoViaje;


    private String tipoAlojamiento;


    private String tipoTransporte;
}
