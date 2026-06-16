# User Story: US-14 - Registro de cuentas como Dueño de Empresa
Feature: Registro de cuentas como Dueño de Empresa

  Scenario: Selección de rol de usuario
    Given que una persona no registrada accede a la funcionalidad de registro
    When selecciona el rol "Dueño de Empresa"
    Then el sistema le presenta los campos requeridos para ese rol, incluyendo el nombre de la empresa
      | Campo             | Tipo  | Obligatorio |
      | Razón Social      | Texto | Sí          |
      | RUC               | Texto | Sí          |
      | Nombre Comercial  | Texto | Sí          |

  Scenario: Registro exitoso con datos válidos
    Given que un futuro dueño de empresa ha completado todos los campos obligatorios con información válida
      | Campo             | Valor                  |
      | Razón Social      | Inversiones Electro SA |
      | RUC               | 20123456789            |
      | Correo Corporativo| contacto@inelectro.com |
      | Contraseña        | Empresa456!            |
    When solicita el registro de su cuenta
    Then el sistema crea una cuenta de usuario con el rol "Propietario" de tipo PYME
    And le informa que se ha enviado una comunicación para verificar su cuenta