# User Story: US-49 - Modificar Horarios de Trabajo Existentes
Feature: Modificar Horarios de Trabajo Existentes

  Scenario: Ajustar disponibilidad semanal
    Given que un Técnico tiene un horario de trabajo configurado
    When modifica las horas de inicio o fin de un día laboral y guarda los cambios
      | Día Semana | Campo Modificado | Valor Anterior | Valor Nuevo |
      | Lunes      | Hora Fin         | 05:00 PM       | 07:00 PM    |
      | Miércoles  | Hora Inicio      | 08:00 AM       | 09:00 AM    |
    Then el sistema actualiza su horario laboral estándar

  Scenario: Remoción completa de un día laboral de la agenda activa
    Given que un Técnico se encuentra operativo de lunes a viernes
    When edita su configuración para eliminar los días viernes de su grilla laboral
      | Día Modificado | Acción    | Estado Final  |
      | Viernes        | Desmarcar | No disponible |
      | Sábado         | Desmarcar | No disponible |
    Then el sistema actualiza su disponibilidad horaria en tiempo real
    And el motor de asignación bloquea ese día para futuras solicitudes automáticas