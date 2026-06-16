# User Story: US-58 - Notificación de Límite de Solicitudes Alcanzado
Feature: Notificación de Límite de Solicitudes Alcanzado

  Scenario: Bloqueo por límite de solicitudes
    Given que un Propietario con plan Básico ya ha alcanzado su límite de solicitudes mensuales
      | ID Cuenta | Plan   | Solicitudes Mes Actual | Límite Permitido |
      | BASIC-002 | Básico | 2                      | 2                |
    When intenta crear una nueva solicitud de servicio
    Then el sistema le impide continuar
    And le informa que ha alcanzado su límite
    And le presenta la opción de actualizar a un plan superior

  Scenario: Solicitud exitosa en plan Básico sin exceder la cuota mensual
    Given que un suscriptor de cuenta básica requiere asistencia técnica comercial
      | ID Cuenta | Plan   | Solicitudes Mes Actual | Límite Permitido |
      | BASIC-055 | Básico | 1                      | 2                |
    When procesa un requerimiento mediante el asistente interactivo
    Then el sistema aprueba la orden técnica de trabajo de manera ordinaria
    And incrementa el contador mensual de consumos de solicitudes del cliente