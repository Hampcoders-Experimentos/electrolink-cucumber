# User Story: US-41 - Selección de Propiedad en Solicitud de Servicio Técnico
Feature: Selección de Propiedad

  Scenario: Selección de propiedad en la solicitud
    Given que un Propietario con más de una propiedad inicia una solicitud de servicio
      | ID Propiedad | Alias Propiedad | Dirección            |
      | PROP-101     | Casa Chorrillos | Malecón Grau 120     |
      | PROP-102     | Oficina San Borja| Av. Aviación 3400   |
    When el sistema le solicita indicar para qué propiedad es el servicio
      | Selección Efectuada |
      | PROP-102            |
    Then puede seleccionar una de sus propiedades registradas
    And la ubicación de esa propiedad será utilizada para la asignación del técnico

  Scenario: Intento de solicitud sin tener propiedades registradas
    Given que un Propietario nuevo no cuenta con inmuebles en su perfil
    When intenta iniciar un flujo de contratación de servicio técnico
      | Acción Inicial      | Cantidad Propiedades |
      | Contratar Servicio  | 0                    |
    Then el sistema interrumpe el asistente de contratación
    And solicita al usuario registrar una propiedad antes de continuar