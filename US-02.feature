# User Story: US-02 - Visualización de Testimonios
Feature: Visualización de Testimonios

  Scenario: Visualización de testimonios diversos
    Given que el visitante explora la plataforma informativa
    When accede a la sección de testimonios
    Then debe ver al menos 3 testimonios diferentes
      | Nombre         | Tipo Usuario | Calificación | Comentario                               |
      | Juan Pérez     | Propietario  | 5 estrellas  | Excelente servicio y muy rápido.         |
      | Carlos Mendoza | Técnico      | 4 estrellas  | Gran plataforma para conseguir clientes. |
      | Ana Gómez      | Propietario  | 5 estrellas  | Muy seguro y transparente todo.          |
    And las calificaciones deben ser visualmente claras

Scenario: Testimonios con detalles específicos
    Given que el visitante accede a la sección de testimonios
    When revisa cada testimonio
    Then debe ver detalles específicos como el nombre del usuario, tipo de usuario, calificación y un comentario breve
      | Nombre         | Tipo Usuario | Calificación | Comentario                               |
      | Juan Pérez     | Propietario  | 5 estrellas  | Excelente servicio y muy rápido.         |
      | Carlos Mendoza | Técnico      | 4 estrellas  | Gran plataforma para conseguir clientes. |
      | Ana Gómez      | Propietario  | 5 estrellas  | Muy seguro y transparente todo.          |