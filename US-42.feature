# User Story: US-42 - Carga Manual de Datos de Recibos Eléctricos (3-6 recibos)
Feature: Carga Manual de Datos de Recibos Eléctricos (3-6 recibos)

  Scenario: Ingreso de datos del recibo
    Given que un Propietario está en el proceso de solicitar un servicio
    When ingresa los datos de consumo (kWh, monto, período) de su recibo eléctrico
      | Mes Período | Consumo kWh | Monto Total (PEN) | Empresa Proveedora |
      | Marzo 2026  | 250         | 180.00            | Luz del Sur        |
      | Abril 2026  | 270         | 200.00            | Luz del Sur        |
      | Mayo 2026   | 240         | 175.00            | Luz del Sur        |
    Then el sistema valida y asocia esta información a la solicitud
    And los datos quedan almacenados para su futuro análisis de consumo

  Scenario: Validación de valores numéricos negativos en el recibo
    Given que un Propietario introduce datos en el formulario de consumo
    When intenta guardar un registro con un monto total erróneo o negativo
      | Mes Período | Consumo kWh | Monto Total (PEN) |
      | Junio 2026  | 190         | -50.00            |
    Then el sistema rechaza la inserción de la fila
    And muestra un mensaje de error indicando parámetros numéricos inválidos