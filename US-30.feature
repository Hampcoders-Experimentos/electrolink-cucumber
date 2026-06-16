# User Story: US-30 - Configuración de Notificaciones Personalizadas
Feature: Configuración de Notificaciones Personalizadas

  Scenario: Ajuste de preferencias de notificación
    Given que un usuario (Propietario o Técnico) está en la configuración de su cuenta
    When ajusta qué tipo de notificaciones desea recibir y por qué canal (ej. email)
      | Tipo Notificación | Canal SMS | Canal Email | Canal Push | Frecuencia  |
      | Asignación Trabajo| Sí        | Sí          | Sí         | Instantánea |
      | Resumen Mensual   | No        | Sí          | No         | Mensual     |
    Then el sistema guarda sus preferencias
    And las futuras notificaciones se enviarán de acuerdo a esta configuración

  Scenario: Actualización de preferencias de notificación
    Given que un usuario (Propietario o Técnico) tiene preferencias de notificación previamente configuradas
    When decide cambiar sus preferencias para un tipo de notificación específico
      | Tipo Notificación | Canal SMS | Canal Email | Canal Push | Frecuencia  |
      | Asignación Trabajo| No        | Sí          | No         | Instantánea |
    Then el sistema actualiza sus preferencias
    And las futuras notificaciones se enviarán de acuerdo a esta nueva configuración