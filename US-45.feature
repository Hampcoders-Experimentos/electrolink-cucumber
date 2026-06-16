# User Story: US-45 - Cancelación de servicios programados
Feature: Cancelación de servicios programados

  Scenario: Cancelación dentro del plazo permitido
    Given que un Propietario tiene un servicio programado
      | ID Servicio | Fecha Programada | Horario          | Horas de Anticipación |
      | SRV-20234   | 25/06/2026       | 09:00 - 11:00 AM | 48 horas              |
    When solicita cancelarlo dentro del plazo permitido por las políticas
    Then el sistema procesa la cancelación sin penalización
    And notifica tanto al Propietario como al Técnico asignado
      | Destinatario | Canal Notificación | Tipo Mensaje             |
      | Propietario  | Push, Email        | Confirmación Cancelación |
      | Técnico      | SMS, Push          | Alerta Agenda Liberada   |

  Scenario: Intento de cancelación fuera del plazo establecido
    Given que un Propietario cuenta con una cita técnica programada para el mismo día
      | ID Servicio | Fecha Programada | Horario          | Tiempo Restante |
      | SRV-20234   | 15/06/2026       | 11:00 PM         | 26 minutos      |
    When solicita la cancelación del servicio técnico
    Then el sistema procesa la cancelación aplicando una penalidad por incumplimiento
    And notifica al usuario sobre el recargo administrativo en su cuenta