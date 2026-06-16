# User Story: US-24 - Edición de Perfil de Propietario
Feature: Edición de Perfil de Propietario

  Scenario: Edición exitosa de información personal
    Given que un Propietario está en la funcionalidad de edición de perfil
    When modifica su información personal (ej. teléfono) y guarda los cambios
      | Campo    | Valor Anterior | Valor Nuevo |
      | Teléfono | 912345678      | 999888777   |
    Then sus cambios se almacenan en el sistema
    And observa un mensaje de confirmación
      | Componente UI      | Mensaje                          |
      | Toast Notificación | Perfil actualizado correctamente |

  Scenario: Edición fallida por formato de teléfono incorrecto
    Given que un Propietario está en la funcionalidad de edición de perfil
    When intenta modificar su número de teléfono con un formato incorrecto
      | Campo    | Valor Anterior | Valor Nuevo   |
      | Teléfono | 912345678      | 12345         |
    Then no se almacenan los cambios en el sistema
    And observa un mensaje de error
      | Componente UI      | Mensaje                      |
      | Toast Notificación | Formato de teléfono inválido |