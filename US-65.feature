# User Story: US-65 - Visualización de Calificaciones y Reseñas
Feature: Visualización de Calificaciones y Reseñas

  Scenario: Consulta de la reputación de un técnico
    Given que un Propietario está explorando el perfil de un Técnico
    When accede a la sección de reseñas
    Then visualiza la calificación promedio y los comentarios dejados por otros usuarios
      | Promedio Global | Muestra Reseñas Totales | Comentario Destacado                      |
      | 4.8 / 5.0       | 24 valoraciones         | Trabajo técnico impecable en cortocorticuit|

  Scenario: Vista de perfil técnico que no ostenta calificaciones previas
    Given que un Propietario ingresa a la ficha pública de un Técnico recién registrado
    When carga el apartado asignado a la reputación comercial del especialista
      | ID Especialista | Evaluaciones en Base de Datos |
      | TECH-NEW-01     | 0                             |
    Then la interfaz muestra una etiqueta neutra indicando perfil sin opiniones registradas
    And oculta los marcadores y promedios globales de estrellas de la sección