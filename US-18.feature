# User Story: US-18 - Validación de datos de registro
Feature: Validación de datos de registro

  Scenario: Validación de formato de correo electrónico
    Given que un usuario está completando el formulario de registro
    When ingresa un texto en el campo de correo electrónico que no tiene un formato válido
      | Texto Ingresado     | Error Esperado             |
      | correosinusuario.com| Formato de correo no válido|
      | juan@empresa        | Formato de correo no válido|
    Then el sistema le informa que el formato del correo no es válido

  Scenario: Validación de correo electrónico ya registrado
    Given que un usuario está en el formulario de registro
    When ingresa un correo electrónico que ya está registrado en el sistema
      | Correo Duplicado       |
      | ya.existente@gmail.com |
    Then el sistema le informa que la dirección de correo ya está en uso