# User Story: US-64 - Sistema de Calificación Post-Servicio
Feature: Sistema de Calificación Post-Servicio

  Scenario: Calificación del servicio
    Given que un Propietario ha recibido un servicio que ya fue marcado como "Completado"
    When completa el formulario de calificación (puntuación y comentarios)
      | ID Servicio | Puntaje Asignado | Comentario Reseña                              |
      | SRV-4402    | 5 estrellas      | Excelente trato, puntualidad y reporte limpio. |
    Then el sistema registra su calificación y la asocia al servicio y al perfil del Técnico

  Scenario: Envío de reseña omitiendo el puntaje de estrellas
    Given que un Propietario procede a evaluar la labor de un especialista
    When envía el formulario incluyendo solo un comentario textual
      | Puntaje Asignado | Comentario Reseña              |
      | [Sin Seleccionar]| Cumplió con lo solicitado.     |
    Then el validador detiene la publicación de la opinión
    And exige la marcación de estrellas de desempeño de forma obligatoria