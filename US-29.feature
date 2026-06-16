# User Story: US-29 - Configuración de Zona de Cobertura Geográfica
Feature: Configuración de Zona de Cobertura Geográfica

  Scenario: Definición de una zona de cobertura
    Given que un Técnico está configurando su perfil operativo
    When define una o más áreas geográficas donde presta servicios
      | Región / Distrito | Radio Acción | Coordenadas Centro |
      | Miraflores        | 5 km         | -12.1211, -77.0297 |
      | San Isidro        | 3 km         | -12.0974, -77.0348 |
    Then el sistema almacena estas zonas
    And las utilizará para filtrar las solicitudes de servicio que puede recibir

  Scenario: Modificación de una zona de cobertura
    Given que un Técnico tiene zonas de cobertura definidas
    When modifica el radio de acción de una zona existente
      | Región / Distrito | Nuevo Radio Acción |
      | Miraflores        | 7 km               |
      | San Isidro        | 4 km               |
    Then el sistema actualiza la zona de cobertura con el nuevo radio
    And las solicitudes de servicio se filtrarán según la nueva configuración