# User Story: US-43 - Descripción Detallada del Problema Eléctrico
Feature: Descripción Detallada del Problema Eléctrico

  Scenario: Añadir detalles a la solicitud
    Given que un Propietario está creando una solicitud de servicio
    When proporciona texto adicional describiendo el problema
      | Campo Formulario      | Texto Introducido                                                                  |
      | Detalles del Problema | Al encender la terma eléctrica, las luces de la cocina parpadean y salta la llave. |
    Then esta descripción se adjunta a la solicitud y será visible para el técnico que sea asignado

  Scenario: Solicitud con descripción del problema en el límite de caracteres
    Given que un Propietario redacta una explicación muy breve del desperfecto
    When guarda el campo de descripción con la longitud mínima requerida
      | Campo Formulario      | Texto Introducido     | Longitud |
      | Detalles del Problema | Fuga en tomacorriente | 21 chars |
    Then el sistema acepta la descripción adjunta por cumplir con las validaciones de texto