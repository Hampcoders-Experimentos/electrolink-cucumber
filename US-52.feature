# User Story: US-52 - Configurar Tiempo de Traslado Entre Servicios
Feature: Configurar Tiempo de Traslado Entre Servicios

  Scenario: Configurar buffer de traslado
    Given que un Técnico está configurando su agenda
    When define un tiempo promedio de traslado (ej. 30 minutos)
      | Parámetro Operativo       | Valor Asignado | Unidad  |
      | Buffer de Desplazamiento  | 30             | Minutos |
    Then el sistema considerará este intervalo de tiempo entre servicios consecutivos al momento de la asignación automática

  Scenario: Actualización del buffer técnico ante contingencias viales
    Given que un Técnico tiene un margen de viaje preestablecido
    When incrementa el tiempo de traslado por aumento de tráfico en su área operativa
      | Parámetro Operativo       | Valor Previo | Nuevo Valor Asignado |
      | Buffer de Desplazamiento  | 30 minutos   | 60 minutos           |
    Then el sistema guarda el nuevo parámetro operativo
    And recalcula los espacios disponibles para citas automáticas subsecuentes