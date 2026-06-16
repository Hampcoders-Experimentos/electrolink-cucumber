# User Story: US-22 - Cierre de Sesión
Feature: Cierre de Sesión

  Scenario: Cierre de sesión voluntario
    Given que un usuario está autenticado en la aplicación
      | Token Sesión | Estado Activo |
      | jwt_67890    | Verdadero     |
    When selecciona la opción de cierre de sesión
    Then su sesión es terminada de forma segura
    And es redirigido a una pantalla pública (inicio de sesión o landing page)
      | Ruta Destino | Estado HTTP |
      | /login       | 200         |

  Scenario: Cierre de sesión por inactividad
    Given que un usuario está autenticado en la aplicación
      | Token Sesión | Estado Activo |
      | jwt_67890    | Verdadero     |
    When no realiza ninguna acción durante un período de tiempo definido (ej. 15 minutos)
    Then su sesión es terminada automáticamente por inactividad
    And es redirigido a una pantalla pública (inicio de sesión o landing page)
      | Ruta Destino | Estado HTTP |
      | /login       | 200         |