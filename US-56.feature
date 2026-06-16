# User Story: US-56 - Establecimiento de Precios por Tipo de Servicio y Zona
Feature: Establecimiento Precios por Tipo de Servicio y Zona

  Scenario: Definir precio de un servicio
    Given que un Técnico está creando o editando un servicio
    When establece un precio base para dicho servicio
      | ID Servicio | Nombre Servicio           | Precio Base (USD) |
      | SERV-CAT-01 | Instalación de Luminarias | 25.00             |
    Then ese precio se mostrará a los clientes como referencia

  Scenario: Definir precio diferenciado por zona (opcional)
    Given que un Técnico ha definido múltiples zonas de cobertura
    When edita un servicio
      | ID Servicio | Zona Cobertura Específica | Recargo Adicional | Precio Zona Final |
      | SERV-CAT-01 | Zona Sur Alejada          | 10.00             | 35.00             |
    Then puede opcionalmente establecer un precio diferente para una zona específica