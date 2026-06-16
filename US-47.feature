# User Story: US-47 - Historial de servicios contratados
Feature: Historial de servicios contratados

  Scenario: Visualización de historial de servicios
    Given que un Propietario accede a su historial de servicios
    When no aplica ningún filtro
    Then visualiza todos los servicios contratados ordenados cronológicamente
      | Fecha Servicio | ID Servicio | Técnico Asignado | Tipo Servicio       | Estado     |
      | 15/01/2026     | SRV-10022   | Marcos Díaz      | Cambio de cables    | Completado |
      | 03/04/2026     | SRV-10991   | Carlos Mendoza   | Revisión pozotierra | Completado |
    And para cada servicio puede ver detalles como fecha, técnico y estado

  Scenario: Filtrado del historial de servicios por estado específico
    Given que un Propietario se encuentra revisando su bitácora técnica
    When aplica un filtro para mostrar únicamente servicios cancelados
      | Filtro Estado |
      | Cancelado     |
    Then el sistema actualiza la lista mostrando exclusivamente los registros coincidentes
      | Fecha Servicio | ID Servicio | Motivo Cancelación     |
      | 12/05/2026     | SRV-10554   | Solicitado por cliente |