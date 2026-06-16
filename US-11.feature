# User Story: US-11 - Conocer más a fondo los servicios que ofrecen
Feature: Conocer más a fondo los servicios que ofrecen

  Scenario: Visualización de la solución en acción
    Given que un visitante se encuentra en la sección de características o servicios
    When explora cómo funciona la plataforma
    Then visualiza representaciones gráficas o capturas de pantalla de la aplicación
      | Pantalla Ilustrada  | Recurso Gráfico      | Funcionalidad Clave                 |
      | Wizard Contratación | wizard_mockup.png    | Proceso guiado de servicio          |
      | Panel Inventario    | inventory_mockup.png | Control de stock para técnicos      |
    And estas imágenes ilustran las funcionalidades clave del sistema

  Scenario: Acceso a demostraciones o videos explicativos
    Given que un visitante se encuentra en la sección de características o servicios
    When busca información adicional sobre el funcionamiento de la plataforma
    Then encuentra enlaces a demostraciones en video o tutoriales explicativos
      | Recurso              | Descripción                                 |
      | Video Demostrativo   | Explicación paso a paso del proceso         |
      | Tutorial Interactivo | Guía práctica para explorar funcionalidades |
    And estos recursos proporcionan una comprensión más profunda de cómo utilizar la plataforma