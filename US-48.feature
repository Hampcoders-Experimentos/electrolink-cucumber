# User Story: US-48 - Configurar Horarios de Trabajo Semanales
Feature: Configurar Horarios de Trabajo Semanales

  Scenario: Establecer disponibilidad semanal
    Given que un Técnico está configurando su agenda
    When define sus horas de trabajo para cada día de la semana
      | Día Semana | Hora Inicio | Hora Fin  | Tipo Turno  |
      | Lunes      | 08:00 AM    | 05:00 PM  | Completo    |
      | Miércoles  | 08:00 AM    | 01:00 PM  | Medio Turno |
      | Viernes    | 08:00 AM    | 05:00 PM  | Completo    |
    Then el sistema guarda esta disponibilidad como su horario laboral estándar
    And lo usará como criterio para la asignación automática de servicios

  Scenario: Configuración de jornada con cruce de horas inválido
    Given que un Técnico define sus rangos horarios semanales
    When introduce una hora de finalización menor a la hora de inicio
      | Día Semana | Hora Inicio | Hora Fin  |
      | Martes     | 09:00 AM    | 07:00 AM  |
      | Jueves     | 08:00 AM    | 06:00 PM  |
    Then el sistema rechaza la configuración del cronograma
    And despliega una alerta indicando inconsistencia en la duración de la jornada