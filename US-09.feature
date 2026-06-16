# User Story: US-09 - Conocer la Misión de la Startup
Feature: Conocer la Misión de la Startup

  Scenario: Visibilidad de la declaración de misión
    Given que un visitante navega por la sección sobre la empresa
    When busca información sobre los propósitos de la empresa
    Then debe encontrar claramente destacada la declaración de misión
      | Sección | Texto de Misión                                                             |
      | Misión  | Ofrecer un ecosistema eléctrico transparente, seguro y altamente eficiente. |
    And esta debe estar redactada de forma concisa y comprensible para el público general

  Scenario: Coherencia con los valores de la empresa
    Given que un visitante está interesado en los valores de la empresa
    When revisa la sección de misión y valores
    Then debe encontrar que la misión está alineada con los valores corporativos
      | Valor         | Descripción del Valor                          |
      | Transparencia | Compromiso con la claridad y honestidad en todas las operaciones.     |
      | Innovación    | Fomento de soluciones creativas para mejorar el ecosistema eléctrico. |
    And la misión debe reflejar el compromiso de la empresa con sus valores fundamentales