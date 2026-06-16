# User Story: US-33 - Eliminar Componente Eléctrico
Feature: Eliminar Componente Eléctrico

  Scenario: Eliminación de componente
    Given que un Técnico visualiza su inventario
    When selecciona un componente y solicita su eliminación
      | ID Interno | Nombre Componente | Stock Actual |
      | COMP-101   | Disyuntor 16A     | 0 unidades   |
    Then el sistema solicita confirmación
    And elimina el componente del inventario activo tras la confirmación

  Scenario: Eliminación de componente con stock
    Given que un Técnico visualiza su inventario
    When selecciona un componente y solicita su eliminación
      | ID Interno | Nombre Componente | Stock Actual |
      | COMP-102   | Interruptor 10A   | 5 unidades   |
    Then el sistema muestra una advertencia sobre el stock existente
    And no permite eliminar el componente hasta que el stock sea cero