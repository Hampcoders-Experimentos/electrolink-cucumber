# User Story: US-62 - Actualización Automática de Inventario Post-Servicio
Feature: Actualización Automática de Inventario Post-Servicio

  Scenario: Descuento automático de stock
    Given que un Técnico ha completado un servicio que tenía una "receta" de componentes
      | SKU Componente | Nombre Componente | Stock Antes Servicio |
      | COMP-101       | Disyuntor 16A     | 5 unidades           |
      | CABLE-01       | Cable Cobre 14 AWG| 100 metros           |
    When marca el servicio como "Completado" y confirma los componentes utilizados en el reporte
      | SKU Utilizado  | Cantidad Consumida |
      | COMP-101       | 1 unidad           |
      | CABLE-01       | 5 metros           |
    Then el sistema descuenta automáticamente las cantidades de esos componentes de su inventario

  Scenario: Intento de descuento automático generando inconsistencia o stock negativo
    Given que una orden consumió una cantidad de repuestos superior al inventario registrado
      | SKU Componente | Stock en Sistema | Cantidad Declarada en Uso |
      | COMP-101       | 1 unidad         | 3 unidades                |
    When el Técnico cierra la orden de servicio como completada
    Then el sistema detiene el ajuste automático del inventario
    And genera una alerta de auditoría para regularizar las existencias manualmente