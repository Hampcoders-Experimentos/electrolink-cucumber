# User Story: US-20 - Mensajes de error retroalimentación de registro
Feature: Mensajes de error retroalimentación de registro

  Scenario: Mensaje de error por problemas del sistema
    Given que el usuario ha solicitado completar su registro
    When ocurre un error del sistema durante el procesamiento
      | Código Error | Origen       |
      | ERR_500      | Base de Datos|
    Then el sistema muestra un mensaje de error genérico
      | Componente UI | Texto Visualizado                                                     |
      | Alerta Error  | Ha ocurrido un problema en el sistema. Por favor, inténtelo de nuevo. |
    And informa que puede intentarlo de nuevo
    And los datos ingresados se conservan para facilitar un nuevo intento
      | Campo Nombre | Valor Conservado |
      | Nombres      | Alejandro        |
      | Correo       | alex@example.com |

  Scenario: Mensaje de error por validación de datos
    Given que el usuario ha ingresado datos para completar su registro
      | Campo Nombre | Valor Ingresado  |
      | Nombres      | Juan             |
      | Correo       | juanexample.com  |
      | Contraseña   | pass123          |
    When el sistema valida los datos ingresados
    Then el sistema muestra mensajes de error específicos para cada campo con problemas
      | Campo Nombre | Texto Visualizado                                  |
      | Correo       | El correo electrónico no es válido.                |
      | Contraseña   | La contraseña debe tener al menos 8 caracteres.    |