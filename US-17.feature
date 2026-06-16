# User Story: US-17 - Inicio de sesión de usuarios
Feature: Inicio de sesión de usuarios

  Scenario: Inicio de sesión exitoso con credenciales válidas
    Given que un usuario registrado y verificado se encuentra en la funcionalidad de acceso
    When ingresa sus credenciales correctas y solicita el acceso
      | Parámetro  | Valor                   |
      | Correo     | login.valid@example.com |
      | Contraseña | UserAuthPass1!          |
    Then el sistema valida las credenciales
    And le concede acceso a su panel personalizado según su rol
      | Rol Encontrado | Panel Redirección |
      | Propietario    | /owner/dashboard  |

  Scenario: Intento de inicio de sesión con credenciales inválidas
    Given que un usuario se encuentra en la funcionalidad de acceso
    When ingresa un correo electrónico y/o contraseña incorrectos
      | Parámetro  | Valor                     |
      | Correo     | login.wrong@example.com   |
      | Contraseña | Incorrecta999             |
    Then el sistema le niega el acceso
    And le informa que las credenciales son inválidas