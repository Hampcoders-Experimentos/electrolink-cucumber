# User Story: US-40 - Contratación de Servicios Eléctricos mediante Wizard
Feature: Contratación de Servicios Eléctricos mediante Wizard

  Scenario: Completar proceso guiado
    Given que un Propietario inicia el proceso de contratación
    When completa todos los pasos requeridos en el asistente (selección de propiedad, servicio, etc.)
      | Paso Asistente | Selección / Entrada            |
      | 1. Propiedad   | Departamento San Isidro        |
      | 2. Servicio    | Diagnóstico de Cortocircuito   |
      | 3. Fecha/Hora  | 22/06/2026 - 10:00 AM          |
    Then el sistema genera una solicitud de servicio
    And le confirma que la solicitud ha sido creada y está pendiente de asignación

  Scenario: Abandono del asistente de contratación
    Given que un Propietario se encuentra a mitad del flujo del wizard
    When cancela el proceso en el paso de selección de fecha y hora
      | Paso Actual    | Acción    |
      | 3. Fecha/Hora  | Cancelar  |
    Then el sistema interrumpe la creación de la solicitud
    And no se genera ningún registro de orden de servicio pendiente