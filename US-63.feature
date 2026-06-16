# User Story: US-63 - Historial de Clientes Atendidos
Feature: Historial de Clientes Atendidos

  Scenario: Consulta de historial de clientes
    Given que un Técnico ha completado servicios
    When accede a su historial de clientes
    Then puede visualizar un listado de todos los clientes atendidos
      | ID Cliente | Nombre Contacto | Total Servicios Prestados | Última Fecha Atención |
      | CLI-0092   | Andrés Ramos    | 2                         | 12/05/2026            |
      | CLI-0511   | Tienda Alfa     | 1                         | 01/06/2026            |
    And para cada cliente, puede ver los servicios prestados

  Scenario: Búsqueda directa de un cliente en la bitácora técnica
    Given que un Técnico cuenta con un registro extenso de cuentas atendidas
    When ingresa el término exacto en la barra de consultas de su historial
      | Criterio Búsqueda |
      | Andrés Ramos      |
    Then la tabla filtra los resultados mostrando únicamente las coincidencias exactas