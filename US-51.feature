# User Story: US-51 - Visualizar Agenda de Trabajos Asignados Automáticamente
Feature: Visualizar Agenda de Trabajos Asignados Automáticamente

  Scenario: Vista de agenda con trabajos asignados
    Given que un Técnico accede a su agenda
    When tiene trabajos que le han sido asignados
    Then visualiza estos trabajos en una vista de calendario
      | Bloque Horario   | ID Servicio | Cliente       | Tipo Trabajo                     |
      | 09:00 - 11:30 AM | SRV-3011    | Tienda Alfa   | Mantenimiento Tablero Comercial  |
      | 02:00 - 04:00 PM | SRV-3012    | Andrés Ramos  | Cambio de Interruptor Diferencial|
    And puede ver los detalles de cada servicio programado

  Scenario: Consulta de la agenda en un día sin órdenes de trabajo
    Given que un Técnico abre su panel operativo semanal
    When cambia el foco visual del calendario hacia un día totalmente libre
      | Fecha Inspección | Citas Registradas |
      | 21/06/2026       | 0                 |
    Then el sistema renderiza la interfaz sin bloques de órdenes técnicos ocupados
    And muestra una leyenda informativa indicando disponibilidad total