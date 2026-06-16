# User Story: US-26 - Edición de Perfil de Técnico
Feature: Edición de Perfil de Técnico

  Scenario: Edición de información profesional
    Given que un Técnico está en la funcionalidad de edición de perfil
    When modifica su descripción, información de contacto o especialidades y guarda los cambios
      | Campo        | Nuevo Valor                                      |
      | Descripción  | Técnico electricista con 15 años de trayectoria. |
      | Especialidad | Automatización industrial                        |
    Then sus cambios se almacenan y se reflejan en su perfil público

  Scenario: Gestión de certificaciones
    Given que un Técnico está editando su perfil
    When añade una nueva certificación con su respectivo documento
      | Nombre Certificación | Archivo Adjunto   | Tamaño   |
      | Técnico Eléctrico II | certificado2.pdf  | 2.4 MB   |
    Then la certificación se añade a su perfil y queda pendiente de validación