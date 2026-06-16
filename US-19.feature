# User Story: US-19 - Mensajes de éxito retroalimentación de registro
Feature: Mensajes de éxito retroalimentación de registro

  Scenario: Mensaje de éxito al completar el registro
    Given el usuario ha completado correctamente el proceso de registro
    When el sistema procesa la solicitud con éxito
    Then el sistema muestra un mensaje de confirmación
      | Componente UI | Texto Visualizado                                              | Clase CSS     |
      | Alerta Éxito  | ¡Registro completado con éxito! Por favor verifique su correo. | alert-success |
    And informa sobre el siguiente paso (verificación de correo)

  Scenario: Mensaje de éxito al actualizar perfil
    Given el usuario ha actualizado su perfil correctamente
    When el sistema procesa la actualización con éxito
    Then el sistema muestra un mensaje de confirmación
      | Componente UI | Texto Visualizado              |
      | Alerta Éxito  | ¡Perfil actualizado con éxito! |