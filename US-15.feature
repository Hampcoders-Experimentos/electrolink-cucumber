# User Story: US-15 - Registro de cuentas para Técnicos
Feature: Registro de cuentas para Técnicos

  Scenario: Selección de rol de usuario
    Given que una persona no registrada accede a la funcionalidad de registro
    When selecciona el rol "Técnico"
    Then el sistema le presenta los campos requeridos para el perfil profesional
      | Campo          | Tipo  | Obligatorio |
      | Especialidad   | Texto | Sí          |
      | Código Licencia| Texto | No          |

  Scenario: Registro exitoso con datos válidos
    Given que un futuro técnico ha completado todos los campos obligatorios con información válida
      | Campo          | Valor                    |
      | Nombres        | Carlos                   |
      | Apellidos      | Mendoza                  |
      | Especialidad   | Redes de Alta Tensión    |
      | Correo         | carlos.tech@example.com  |
      | Contraseña     | TechSecure789!           |
    When solicita el registro de su cuenta
    Then el sistema crea una cuenta de usuario con el rol "Técnico"
    And le informa que se ha enviado una comunicación para verificar su cuenta