# User Story: US-38 - Actualización de Stock de Componentes (Técnico)
Feature: Actualización de Stock de Componentes (Técnico)

  Scenario: Ajuste manual de stock
    Given que un Técnico está gestionando su inventario
    When selecciona un componente y ajusta la cantidad de stock manualmente (ej. por una nueva compra)
      | SKU       | Nombre              | Acción   | Cantidad Ingresada | Stock Resultante |
      | CABLE-01  | Cable Cobre 14 AWG  | Adicionar| 100 metros         | 150 metros       |
    Then la cantidad de stock del componente se actualiza

  Scenario: Disminución manual de stock por descarte de material dañando
    Given que un Técnico inspecciona sus materiales en inventario
    When disminuye el stock manualmente por concepto de merma
      | SKU       | Nombre              | Acción   | Cantidad Restada | Stock Resultante |
      | CABLE-01  | Cable Cobre 14 AWG  | Sustraer | 10 metros        | 140 metros       |
    Then el sistema procesa el descuento del stock del componente