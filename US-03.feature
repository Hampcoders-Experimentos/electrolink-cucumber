# User Story: US-03 - Adaptabilidad a Diferentes Dispositivos
Feature: Adaptabilidad a Diferentes Dispositivos

  Scenario: Experiencia en dispositivo móvil
    Given que un visitante accede a la plataforma informativa desde un dispositivo móvil
      | Marca  | Modelo     | Resolución | Orientation |
      | Apple  | iPhone 13  | 390x844    | Vertical    |
      | Google | Pixel 6    | 411x912    | Vertical    |
    When la información es presentada
    Then todos los elementos se reorganizan para adaptarse a una pantalla vertical
    And no requiere desplazamiento horizontal
    And todos los textos son legibles sin necesidad de ampliar la vista

  Scenario: Experiencia en tableta o escritorio
    Given que un visitante accede a la plataforma informativa desde una tableta o un ordenador
      | Tipo       | Resolución |
      | Tableta    | 768x1024   |
      | Escritorio | 1920x1080  |
    When la información es presentada
    Then el diseño aprovecha el espacio horizontal adicional
    And mantiene una experiencia de navegación fluida y atractiva