# User Story: US-10 - Conocer la Visión de la Startup
Feature: Conocer la Visión de la Startup

  Scenario: Visibilidad de la declaración de visión
    Given que un visitante navega por la sección sobre la empresa
    When busca información sobre las metas futuras de la empresa
    Then debe encontrar claramente destacada la declaración de visión
      | Sección | Texto de Visión                                                                |
      | Visión  | Ser la plataforma líder de servicios eléctricos en Latinoamérica para el 2030. |
    And esta debe estar redactada de forma inspiradora y orientada al futuro

  Scenario: Coherencia entre visión y misión
    Given que un visitante ha leído la declaración de misión de la empresa
    When compara la declaración de visión con la misión
    Then debe encontrar que ambas declaraciones son coherentes y complementarias
      | Declaración  | Contenido                                                                      |
      | Misión       | Proveer servicios eléctricos confiables y sostenibles a nuestros clientes.     |
      | Visión       | Ser la plataforma líder de servicios eléctricos en Latinoamérica para el 2030. |