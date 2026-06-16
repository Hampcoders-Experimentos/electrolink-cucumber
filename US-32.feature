# User Story: US-32 - Editar Componente Eléctrico
Feature: Editar Componente Eléctrico

  Scenario: Actualización de datos técnicos
    Given que un Técnico visualiza su inventario
    When selecciona un componente y modifica sus características
      | ID Interno | Campo a Modificar | Valor Anterior   | Valor Nuevo      |
      | COMP-101   | Especificación    | Monofásico, 230V | Monofásico, 400V |
    Then los cambios se guardan correctamente

  Scenario: Validación de campos obligatorios
    Given que un Técnico visualiza su inventario
    When selecciona un componente y deja el campo "Especificación" vacío
    Then se muestra un mensaje de error indicando que el campo es obligatorio
      | Campo a Modificar | Valor Anterior   | Valor Nuevo   |
      | Especificación    | Monofásico, 230V |               |
    And el componente no se actualiza