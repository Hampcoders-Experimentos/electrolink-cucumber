# User Story: US-06 - Navegación mediante Encabezado
Feature: Navegación mediante Encabezado

  Scenario: Acceso a secciones desde el encabezado
    Given que un visitante explora la plataforma informativa
    When utiliza las opciones de navegación en el encabezado
      | Opción Seleccionada | Sección Destino |
      | Características     | #features       |
      | Planes              | #pricing        |
      | Nosotros            | #about-us       |
    Then puede desplazarse a las diferentes secciones informativas
    And el encabezado permanece accesible durante el desplazamiento

  Scenario: Navegación en dispositivos de pantalla pequeña
    Given que un visitante accede desde un dispositivo móvil
    When interactúa con la opción de menú principal
      | Botón            | Acción    |
      | Menú Hamburguesa | Clic      |
    Then se despliegan las opciones de navegación a las distintas secciones
      | Opción Desplegada |
      | Inicio            |
      | Servicios         |
      | Soporte           |