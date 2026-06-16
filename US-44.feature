# User Story: US-44 - Selección de Servicio Específico del Catálogo
Feature: Selección de Servicio Específico del Catálogo

  Scenario: Selección de un servicio del catálogo
    Given que un Propietario ha seleccionado la propiedad para el servicio
    When el sistema le presenta el catálogo de servicios disponibles en su zona
      | ID Catálogo | Nombre Servicio                   | Tiempo Estimado | Precio Base |
      | SERV-CAT-01 | Instalación de Luminarias         | 1 hora          | $25.00      |
      | SERV-CAT-02 | Cambio de Llave Termomagnética    | 1.5 horas       | $40.00      |
    Then puede seleccionar un servicio específico de la lista
    And la solicitud queda vinculada a ese servicio del catálogo

  Scenario: Búsqueda sin resultados en el catálogo por zona
    Given que un Propietario se ubica en una zona rural no mapeada
    When el sistema intenta cargar el catálogo de servicios disponibles
      | Zona Geográfica    | Filtro Categoría |
      | Sector KM 45 Norte | Todo             |
    Then el catálogo se muestra vacío de opciones de asignación automática
    And el sistema ofrece una alternativa de asistencia de soporte manual