# User Story: US-07 - Visualización del Pie de página
Feature: Visualización del Pie de página

  Scenario: Contenido completo del pie de página
    Given que un visitante se desplaza hasta el final de la plataforma informativa
    When llega al pie de página
    Then debe ver una sección con enlaces a Términos y Condiciones y Política de Privacidad
      | Documento Legales     | Enlace            |
      | Términos y Condiciones| /legal/terms      |
      | Política de Privacidad| /legal/privacy    |
    And debe encontrar información de contacto
      | Medio      | Detalle                      |
      | Correo     | contacto@electrolink.com     |
      | Teléfono   | +51 1 2345678                |
    And enlaces a las redes sociales de la empresa
      | Red Social | URL                          |
      | Facebook   | facebook.com/electrolink     |

  Scenario: Diseño claro y accesible del pie de página
    Given que un visitante visualiza el pie de página
    When revisa su diseño
    Then el pie de página debe tener un diseño claro y accesible
      | Elemento UI | Requisitos de Diseño                                          |
      | Fondo       | Color de fondo contrastante para destacar la sección          |
      | Texto       | Fuente legible, tamaño adecuado, color complementario         |
      | Enlaces     | Claramente identificables, con suficiente espacio entre ellos |
    And debe ser fácilmente accesible desde cualquier sección de la plataforma