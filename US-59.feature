# User Story: US-59 - Seguimiento de Estados de Servicio en Tiempo Real
Feature: Seguimiento de Estados de Servicio en Tiempo Real

  Scenario: Visualización del estado del servicio
    Given que un servicio ha sido asignado
    When el Propietario o el Técnico consultan los detalles del servicio
      | Consulta Ejecutada por | ID Servicio | Estado Retornado |
      | Propietario            | SRV-4402    | Programado       |
      | Técnico                | SRV-4402    | Programado       |
    Then visualizan el estado actual del mismo (ej. "Programado")

  Scenario: Actualización del estado
    Given que un Técnico está ejecutando un servicio
    When actualiza el estado del servicio a "En Progreso"
      | ID Servicio | Estado Anterior | Estado Nuevo | Canal Sincronización |
      | SRV-4402    | Programado      | En Progreso  | WebSocket            |
    Then el nuevo estado es visible tanto para él como para el Propietario