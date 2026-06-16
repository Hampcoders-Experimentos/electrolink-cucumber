# User Story: US-57 - Beneficio de Solicitud Prioritaria
Feature: Beneficio de Solicitud Prioritaria

  Scenario: Marcar solicitud como prioritaria
    Given que un Propietario con plan Premium está creando una solicitud
      | ID Cuenta | Nivel Suscripción | Cupos Prioritarios Usados |
      | PREM-8891 | Premium           | 0 / Ilimitado             |
    When activa la opción de solicitud prioritaria
    Then la solicitud es creada y marcada con alta prioridad para el proceso de asignación

  Scenario: Intento de uso de prioridad por un cliente del esquema regular
    Given que un Propietario bajo una suscripción básica inicia un flujo técnico
      | ID Cuenta | Nivel Suscripción |
      | BASIC-102 | Básico            |
    When el motor procesa el wizard e intenta forzar la bandera de prioridad alta
    Then el sistema restringe la activación de la casilla preferencial
    And sugiere al usuario realizar un upgrade de cuenta para gozar del beneficio