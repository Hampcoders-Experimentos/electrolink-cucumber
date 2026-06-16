# User Story: US-28 - Crear Portafolio Digital con Evidencias de Trabajo
Feature: Crear Portafolio Digital con Evidencias de Trabajo

  Scenario: Añadir un nuevo trabajo al portafolio
    Given que un Técnico está gestionando su perfil
    When accede a la sección de Portafolio y añade un nuevo trabajo con imágenes y descripción
      | Título Proyecto  | Descripción Proyecto                          | Imagen Evidencia   |
      | Cableado PYME    | Instalación de ductos y cableado estructurado | cableado_pyme.jpg  |
    Then el trabajo se guarda y se muestra en su perfil público

  Scenario: Organización del portafolio
    Given que un Técnico tiene varios trabajos en su portafolio
    When organiza sus trabajos por categorías
      | ID Proyecto | Categoría Asignada |
      | PROJ-001    | Residencial        |
      | PROJ-002    | Industrial         |
    Then los cambios se reflejan en la vista pública, permitiendo a los clientes filtrar por dichas categorías