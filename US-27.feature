# User Story: US-27 - Entrar a un dashboard Personalizado
Feature: Entrar a un dashboard Personalizado

  Scenario: Visualización del dashboard para Propietario
    Given que un Propietario inicia sesión
    When accede a su panel principal
    Then visualiza un resumen de sus servicios activos, sus próximas citas y notificaciones recientes
      | Componente Dashboard | Muestra                              | Cantidad |
      | Servicios Activos    | Reparación de tablero principal      | 1        |
      | Próximas Citas       | Mantenimiento preventivo 20/06/2026  | 1        |
      | Notificaciones       | Alerta de asignación de técnico      | 3        |

  Scenario: Visualización del dashboard para Técnico
    Given que un Técnico inicia sesión
    When accede a su panel principal
    Then visualiza su agenda de servicios del día, solicitudes pendientes y un resumen de sus estadísticas recientes
      | Componente Dashboard | Muestra                              | Estado    |
      | Agenda del Día       | 2 Instalaciones domésticas           | Pendiente |
      | Solicitudes          | Revisión de cortocircuito comercial  | Nueva     |