# User Story: US-25 - Visualización de Perfil de Técnico
Feature: Visualización de Perfil de Técnico

  Scenario: Acceso al perfil profesional
    Given que un Técnico está autenticado en el sistema
    When solicita visualizar su perfil
    Then se le presenta su información profesional tal como la verían los clientes
    And puede revisar su descripción, certificaciones, portafolio y zonas de cobertura
      | Sección         | Contenido Detallado                          |
      | Descripción     | Especialista en instalaciones industriales.  |
      | Certificaciones | Certificado Técnico Interno A-1              |
      | Cobertura       | Radio de 15km desde Lima Centro              |

  Scenario: Edición de perfil profesional
    Given que un Técnico está autenticado en el sistema
    When solicita editar su perfil profesional
    Then se le permite modificar su descripción, certificaciones, portafolio y zonas de cobertura
    And los cambios se reflejan correctamente en la visualización del perfil
      | Sección        | Contenido Detallado                          |
      | Descripción    | Especialista en instalaciones industriales.  |
      | Certificaciones| Certificado Técnico Interno A-1              |
      | Cobertura      | Radio de 15km desde Lima Centro              |