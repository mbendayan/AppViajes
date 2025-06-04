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

    @Enumerated(EnumType.STRING)
    private PresupuestoEnum presupuesto;

    private Double montoPersonalizado; // solo si elige PERSONALIZADO

    @Enumerated(EnumType.STRING)
    private TipoViajeEnum tipoViaje;

    @Enumerated(EnumType.STRING)
    private TipoAlojamientoEnum tipoAlojamiento;

    @Enumerated(EnumType.STRING)
    private TipoTransporteEnum tipoTransporte;
}
