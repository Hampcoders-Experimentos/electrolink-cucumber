# User Story: US-21 - Recuperación de Contraseña
Feature: Recuperación de Contraseña

  Scenario: Solicitud de recuperación con correo válido
    Given que un usuario se encuentra en la página de recuperación de contraseña
    When ingresa el correo electrónico asociado a su cuenta
      | Campo Correo | Valor                   |
      | email        | usuario@electrolink.com |
    Then el sistema envía un correo con instrucciones y un enlace único de restablecimiento
    And muestra un mensaje de confirmación indicando que revise su correo

  Scenario: Finalización exitosa del restablecimiento
    Given que un usuario ha seguido el enlace de restablecimiento
    When ingresa y confirma una nueva contraseña que cumple los requisitos de seguridad
      | Nueva Contraseña   | Confirmación       |
      | NewSecurePass2026! | NewSecurePass2026! |
    Then la contraseña es actualizada en el sistema
    And recibe un mensaje de confirmación del cambio exitoso