# User Story: US-23 - Visualización de Perfil de Propietario
Feature: Visualización de Perfil de Propietario

  Scenario: Acceso al perfil personal
    Given que un Propietario está autenticado en el sistema
    When solicita visualizar su perfil
    Then se le presenta su información personal registrada, como nombre, correo y teléfono
      | Campo    | Datos de Usuario        |
      | Nombre   | Roberto Carlos          |
      | Correo   | roberto@electrolink.com |
      | Teléfono | 912345678               |
    And visualiza sus preferencias de notificación configuradas
      | Canal | Estado        |
      | Email | Habilitado    |
      | Push  | Deshabilitado |

  Scenario: Edición de información personal
    Given que un Propietario está autenticado en el sistema
    When solicita editar su información personal
    Then se le permite modificar su nombre, correo y teléfono
      | Campo    | Datos de Usuario          |
      | Nombre   | Roberto Carlos            |
      | Correo   | robert.carlos@hotmail.com |
      | Teléfono | 987654321                 |
    And se le solicita confirmar los cambios realizados
    When confirma los cambios
    Then su perfil se actualiza con la nueva información y se muestra un mensaje de éxito