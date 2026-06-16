# User Story: US-13 - Registro de cuentas como Dueño de Hogar
Feature: Registro de cuentas como Dueño de Hogar

  Scenario: Selección de rol de usuario
    Given que una persona no registrada accede a la funcionalidad de registro
    When selecciona el rol "Dueño de Hogar"
    Then el sistema le presenta los campos requeridos para ese rol
      | Campo           | Tipo     | Obligatorio |
      | Nombres         | Texto    | Sí          |
      | Apellidos       | Texto    | Sí          |
      | Correo          | Email    | Sí          |
      | Teléfono        | Numérico | Sí          |

  Scenario: Registro exitoso con datos válidos
    Given que un futuro dueño de hogar ha completado todos los campos obligatorios con información válida
      | Campo           | Valor                  |
      | Nombres         | Juan                   |
      | Apellidos       | Pérez                  |
      | Correo          | juan.perez@example.com |
      | Teléfono        | 987654321              |
      | Contraseña      | Password123!           |
    When solicita el registro de su cuenta
    Then el sistema crea una cuenta de usuario con el rol "Propietario"
    And le informa que se ha enviado una comunicación para verificar su cuenta