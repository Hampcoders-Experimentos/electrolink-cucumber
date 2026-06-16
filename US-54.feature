# User Story: US-54 - Modificar Servicios y sus Recetas de Componentes
Feature: Modificar Servicios y sus Recetas de Componentes

  Scenario: Actualizar una receta de servicio
    Given que un Técnico está editando un servicio existente con receta
    When modifica la lista de componentes o sus cantidades
      | Nombre Servicio            | SKU Componente | Tipo Modificación | Cantidad Nueva |
      | Cambio Termomagnética Dual | CABLE-01       | Actualizar        | 4 metros       |
    Then la receta del servicio se actualiza

  Scenario: Eliminación de un insumo de la receta de un servicio
    Given que un Técnico depura los requerimientos de una de sus prestaciones técnicas
    When retira un componente secundario de la estructura de materiales
      | Nombre Servicio            | SKU Componente a Remover | Acción |
      | Cambio Termomagnética Dual | INT-CINTA-01             | Borrar |
    Then el sistema descuenta el componente de la receta del servicio
    And guarda las modificaciones del catálogo operativo de manera exitosa