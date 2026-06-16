# User Story: US-53 - Crear Servicios en Catálogo con Recetas de Componentes
Feature: Crear Servicios en Catálogo con Recetas de Componentes

  Scenario: Crear un servicio con receta
    Given que un Técnico está gestionando su catálogo
    When crea un nuevo servicio y le asocia una "receta" (lista de componentes y cantidades de su inventario)
      | Nombre Servicio            | SKU Componente | Cantidad Requerida | Unidad |
      | Cambio Termomagnética Dual | COMP-101       | 1                  | Unidad |
      | Cambio Termomagnética Dual | CABLE-01       | 2                  | Metros |
    Then el servicio se guarda con su receta de componentes asociada
    And el sistema usará esta receta para validar el stock antes de la asignación

  Scenario: Intento de creación de servicio utilizando un componente inexistente
    Given que un Técnico define la lista de materiales para una prestación nueva
    When asocia un código de insumo no registrado en su módulo de inventario
      | Nombre Servicio       | SKU Componente Erróneo | Cantidad |
      | Instalación Reflector | SKU-NOT-FOUND          | 1        |
      | Instalación Reflector | CABLE-01               | 1        |
    Then el sistema bloquea el guardado del servicio técnico
    And emite un mensaje notificando la necesidad de dar de alta el componente previamente