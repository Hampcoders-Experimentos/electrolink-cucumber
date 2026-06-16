# User Story: US-39 - Configuración de Alertas de Stock Mínimo (Técnico)
Feature: Configuración de Alertas de Stock Mínimo (Técnico)

  Scenario: Establecer un umbral de stock mínimo
    Given que un Técnico está gesticulando un componente en su inventario
    When establece un umbral numérico de stock mínimo para ese componente
      | SKU       | Nombre              | Umbral Mínimo |
      | CABLE-01  | Cable Cobre 14 AWG  | 20 metros     |
    Then el sistema guarda esta configuración

  Scenario: Recepción de alerta
    Given que un componente tiene un umbral de stock mínimo configurado
      | SKU       | Nombre              | Umbral Mínimo | Stock Real Actual |
      | CABLE-01  | Cable Cobre 14 AWG  | 20 metros     | 15 metros         |
    When el stock de ese componente baja hasta o por debajo del umbral
    Then el sistema envía una notificación al Técnico informando de la situación