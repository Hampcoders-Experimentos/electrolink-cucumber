# User Story: US-50 - Bloquear Fechas y Horarios Específicos
Feature: Bloquear Fechas y Horarios Específicos

  Scenario: Bloquear un período de tiempo
    Given que un Técnico está gestionando su agenda
    When selecciona una fecha o un rango de horas y lo marca como no disponible
      | Fecha Bloqueo | Hora Inicio | Hora Fin  | Motivo Bloqueo     |
      | 28/07/2026    | 08:00 AM    | 06:00 PM  | Feriado Nacional   |
    Then el sistema registra este bloqueo
    And no le asignará servicios durante ese período

  Scenario: Bloqueo de franja horaria en un día con citas previamente pactadas
    Given que un Técnico tiene un servicio agendado para un bloque específico
      | Fecha Día  | Hora Bloque Asignado | ID Orden Relacionada |
      | 20/06/2026 | 10:00 AM - 12:00 PM  | SRV-8812             |
    When intenta realizar un bloqueo manual sobre ese mismo rango horario
      | Fecha Solicitada | Hora Inicio | Hora Fin  |
      | 20/06/2026       | 09:30 AM    | 01:00 PM  |
    Then el sistema advierte sobre la existencia de un conflicto de asignación
    And solicita la reubicación previa de la cita antes de confirmar el bloqueo técnico