# User Story: US-55 - Eliminar Servicios del Catálogo
Feature: Eliminar Servicios del Catálogo

  Scenario: Eliminación de un servicio
    Given que un Técnico visualiza su catálogo de servicios
    When selecciona un servicio y solicita su eliminación
      | ID Catálogo Servicio | Nombre Servicio                |
      | SERV-CAT-02          | Cambio de Llave Antigua Plomo  |
      | SERV-CAT-03          | Cambio de Llave Antigua Bronce |
    Then el servicio se elimina y ya no será ofrecido a los clientes

  Scenario: Intento de eliminación de un servicio con asignaciones automáticas activas
    Given que un Técnico posee una orden agendada vinculada a una prestación técnica específica
      | ID Catálogo Servicio | ID Orden Pendiente |
      | SERV-CAT-02          | SRV-99120          |
      | SERV-CAT-03          | SRV-99121          |
    When intenta remover dicho servicio de su catálogo comercial
    Then el sistema restringe el borrado directo de la opción técnica
    And informa que debe finalizar o delegar los servicios vigentes asociados