# User Story: US-34 - Registro de Propiedad (Propietario)
Feature: Registro de Propiedad (Propietario)

  Scenario: Añadir una nueva propiedad
    Given que un Propietario está gestionando sus activos
    When proporciona la información de una nueva propiedad, incluyendo su dirección
      | Tipo Propiedad | Dirección                   | Ciudad | Geolocalización     |
      | Departamento   | Av. Larco 456, Int 302      | Lima   | -12.1254, -77.0312  |
    Then el sistema registra la propiedad y la asocia a su cuenta
    And la propiedad queda disponible para solicitar servicios

  Scenario: Editar la información de una propiedad existente
    Given que un Propietario tiene una propiedad registrada
    When actualiza la información de la propiedad, como la dirección o la geolocalización
      | Tipo Propiedad | Dirección                    | Ciudad | Geolocalización      |
      | Departamento   | Av. Marina 456, Int 302      | Lima   | -12.1254, -77.0312  |
    Then el sistema actualiza la información de la propiedad en su cuenta
    And los cambios se reflejan en las solicitudes de servicios asociadas a esa propiedad