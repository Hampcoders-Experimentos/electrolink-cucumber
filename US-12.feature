# User Story: US-12 - Ver planes de suscripción disponibles
Feature: Ver planes de suscripción disponibles

  Scenario: Comparación de planes para Propietarios
    Given que un visitante está interesado en los planes para Propietarios
    When accedé a la sección de planes
    Then visualiza una comparativa entre el plan Básico y el plan Premium
      | Plan    | Límite Mensual | Precio | Beneficios Adicionales             |
      | Básico  | 2 solicitudes  | Free   | Acceso estándar al catálogo        |
      | Premium | Ilimitado      | $19.99 | Solicitud prioritaria, Analytics   |
    And puede identificar claramente los límites y beneficios de cada uno

  Scenario: Visualización de planes para Técnicos
    Given que un visitante está interesado en los planes para Técnicos
    When accedé a la sección de planes
    Then visualiza la oferta de planes de suscripción para su rol
      | Plan Técnico | Costo  | Características Incluidas                   |
      | Profesional  | $29.99 | Gestión de inventario, recetas de servicios |
    And comprende los beneficios asociados a cada nivel