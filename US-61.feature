# User Story: US-61 - Generación de Reportes Técnicos Estructurados
Feature: Generación de Reportes Técnicos Estructurados

  Scenario: Generar un reporte de servicio
    Given que un Técnico ha completado un servicio
    When finaliza el trabajo y accede a la funcionalidad de reporte
      | Sección Reporte | Datos Cumplimentados                                         |
      | Componentes     | 1x Disyuntor Schneider 16A                                   |
      | Procedimiento   | Desmantelamiento de térmica dañada e instalación de repuesto.|
      | Recomendación   | Balancear las cargas de las fases en la caja principal.      |
    Then puede documentar los componentes utilizados, el trabajo realizado y las recomendaciones para el cliente
    And este reporte queda asociado al historial del servicio

  Scenario: Envío del reporte técnico omitiendo campos estructurales obligatorios
    Given que un Técnico genera el documento de cierre de servicio
    When intenta procesar la orden dejando la sección de procedimientos totalmente vacía
      | Sección Reporte | Datos Cumplimentados      |
      | Recomendación   | Se sugiere cambio total.  |
      | Procedimiento   |                           |
    Then el sistema frena la emisión del reporte de servicio
    And marca el recuadro pendiente en rojo exigiendo completar la descripción técnica