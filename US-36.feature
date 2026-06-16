# User Story: US-36 - Eliminación de Propiedad (Propietario)
Feature: Eliminación de Propiedad (Propietario)

  Scenario: Eliminación de una propiedad
    Given que un Propietario visualiza sus propiedades registradas
    When selecciona una propiedad y solicita su eliminación
      | ID Propiedad | Ubicación               |
      | PROP-771     | Av. Larco 456, Int 501  |
    Then el sistema solicita confirmación
    And elimina la propiedad de su cuenta tras la confirmación

  Scenario: Cancelación del proceso de eliminación de propiedad
    Given que un Propietario ha solicitado la eliminación de una propiedad
    When el sistema solicita confirmación y el usuario selecciona cancelar
      | ID Propiedad | Acción Confirmación |
      | PROP-771     | Cancelar            |
    Then la propiedad no es eliminada del sistema
    And permanece visible en el listado de activos del propietario