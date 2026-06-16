# User Story: US-16 - Verificación de cuenta por correo electrónico
Feature: Verificación de cuenta por correo electrónico

  Scenario: Envío de comunicación de verificación
    Given que un usuario se ha registrado exitosamente
      | ID Usuario | Correo Destino          | Rol         |
      | USR-9901   | verif.user@example.com  | Propietario |
    When el proceso de registro finaliza
    Then el sistema envía una comunicación electrónica a la dirección proporcionada
    And la comunicación contiene una instrucción y un medio único para verificar la cuenta
      | Componente de Correo | Tipo            | Formato                        |
      | Enlace Único         | Token Seguridad | https://electrolink/v?t=xyz123 |

  Scenario: Verificación exitosa de cuenta
    Given que un usuario ha recibido la comunicación de verificación
    When utiliza el medio de verificación proporcionado
      | Token Utilizado | Origen Click |
      | xyz123          | Correo Inbox |
    Then su cuenta es marcada como verificada en el sistema
    And se le notifica que la verificación fue exitosa