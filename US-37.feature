# User Story: US-37 - Registro de Inventario de Componentes (Técnico)
Feature: Registro de Inventario de Componentes (Técnico)

  Scenario: Añadir un componente al inventario con stock
    Given que un Técnico está gestionando su inventario
    When registra un nuevo tipo de componente y especifica la cantidad inicial y el costo
      | SKU       | Nombre              | Cantidad Inicial | Costo Unitario |
      | CABLE-01  | Cable Cobre 14 AWG  | 50 metros        | $1.50          |
    Then el componente se añade a su inventario con el stock correspondiente

  Scenario: Registro de un componente con stock inicial en cero
    Given que un Técnico inicia el registro de un material sin existencias físicas
    When ingresa los datos del componente con cantidad en cero
      | SKU       | Nombre               | Cantidad Inicial | Costo Unitario |
      | TERM-02   | Llave Diferencial 40A| 0 unidades       | $12.00         |
    Then el sistema registra el componente en el catálogo del técnico
    And el estado del stock se muestra como agotado