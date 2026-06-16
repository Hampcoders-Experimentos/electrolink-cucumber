# User Story: US-05 - Navegación sin errores
Feature: Navegación sin errores

  Scenario: Carga completa de la plataforma
    Given que un visitante accede a la plataforma informativa
    When la carga de la página se completa
    Then todos los elementos visuales e informativos se muestran correctamente
      | Elemento      | Estado esperado | Código HTTP |
      | Imágenes Hero | Cargado         | 200         |
      | Texto Misión  | Visible         | 200         |
    And no existen enlaces que dirijan a destinos incorrectos o inexistentes
      | Enlace             | Destino verificado |
      | /terminos          | Válido             |
      | /politicas         | Válido             |
    
    Scenario: Navegación fluida entre secciones
    Given que un visitante está explorando la plataforma informativa
    When hace clic en los enlaces de navegación
      | Enlace             | Sección Destino     |
      | Características     | /caracteristicas    |
      | Testimonios        | /testimonios       |
      | Contacto           | /contacto          |
    Then la plataforma debe cargar la sección correspondiente sin errores