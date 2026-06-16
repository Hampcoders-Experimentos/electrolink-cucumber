# User Story: US-35 - Edición de Información de Propiedad (Propietario)
Feature: Edición de Información de Propiedad (Propietario)

  Scenario: Actualización de datos de una propiedad
    Given que un Propietario visualiza sus propiedades registradas
    When selecciona una propiedad y modifica su información
      | ID Propiedad | Campo a Modificar | Valor Anterior | Valor Nuevo            |
      | PROP-771     | Dirección         | Av. Larco 456  | Av. Larco 456, Int 501 |
    Then los cambios se guardan correctamente

  Scenario: Intento de actualización con datos inválidos
    Given que un Propietario se encuentra en el formulario de edición de propiedad
    When limpia el campo obligatorio de dirección física e intenta guardar
      | ID Propiedad | Dirección | Código Postal |
      | PROP-771     |           | 15074         |
    Then el sistema deniega la actualización
    And muestra un mensaje de error indicando que la dirección no puede estar vacía