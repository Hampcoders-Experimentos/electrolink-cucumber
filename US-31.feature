# User Story: US-31 - Crear Componente Eléctrico
Feature: Crear Componente Eléctrico

  Scenario: Registro de un nuevo componente
    Given que un Técnico está gestionando su inventario
    When proporciona la información de un nuevo componente (nombre, marca, etc.)
      | ID Interno | Nombre Componente | Marca     | Modelo    | Especificación Técnica |
      | COMP-101   | Disyuntor 16A     | Schneider | Easy9     | Monofásico, 230V       |
    Then el sistema registra el nuevo componente en el inventario del técnico

  Scenario: Validación de campos obligatorios
    Given que un Técnico está gestionando su inventario
    When intenta registrar un nuevo componente sin proporcionar toda la información requerida
      | ID Interno | Nombre Componente | Marca     | Modelo    | Especificación Técnica |
      | COMP-102   |                   | Schneider | Easy9     | Monofásico, 230V       |
    Then el sistema muestra un mensaje de error indicando que el campo "Nombre Componente" es obligatorio