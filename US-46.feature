# User Story: US-46 - Notificación de Asignación Automática de Técnico (Propietario)
Feature: Notificación de Asignación Automática de Técnico (Propietario)

  Scenario: Recepción de notificación de asignación
    Given que un Propietario ha creado una solicitud de servicio
    When el sistema asigna automáticamente un Técnico al servicio
      | ID Técnico | Nombre Técnico | Calificación Promedio | Nro Licencia |
      | TECH-882   | Marcos Díaz    | 4.9 / 5.0             | LIC-ELECT-99 |
    Then el Propietario recibe una notificación
    And la notificación contiene la información del perfil del Técnico asignado

  Scenario: Falla en el envío de notificación push por desconexión
    Given que el motor de asignación emparejó un servicio con un especialista técnico
    When el dispositivo móvil del Propietario no se encuentra conectado a la red de datos
      | Canal Intentado | Estado Red Dispositivo | ID Orden  |
      | Push Firebase   | Offline                | SRV-90111 |
    Then el sistema encola la notificación para su entrega inmediata al restablecer la conexión
    And despacha un respaldo por correo electrónico de manera simultánea