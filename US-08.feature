# User Story: US-08 - Ver Información del Startup
Feature: Ver Información del Startup

  Scenario: Acceso a información corporativa
    Given que un visitante navega por la plataforma informativa
    When se desplaza a la sección sobre la empresa
    Then debe encontrar información clara sobre la startup y el equipo fundador
      | Startup     | Equipo Fundador | Descripción Profesional                      |
      | Hampcoders  | Fundador A      | Ingeniero de Software con 10 años de exp.    |
      | Hampcoders  | Fundador B      | Especialista en Soluciones Energéticas       |
    And la información debe transmitir profesionalidad y confianza

  Scenario: Enlaces a redes sociales y contacto
    Given que un visitante está interesado en conocer más sobre la empresa
    When revisa la sección de contacto y redes sociales
    Then debe encontrar enlaces a las redes sociales de la empresa
      | Red Social | URL                              |
      | Facebook   | facebook.com/electrolink         |
      | LinkedIn   | linkedin.com/company/electrolink |
    And debe ver información de contacto clara y accesible
      | Medio      | Detalle                          |
      | Correo     | contacto@electrolink.com         |
      | Teléfono   | +51 1 2345678                    |