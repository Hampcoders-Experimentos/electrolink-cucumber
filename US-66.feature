# User Story: US-66 - Retroalimentación directa de servicios
Feature: Retroalimentación directa de servicios

  Scenario: Revisión de valoraciones recibidas
    Given que un Técnico ha recibido valoraciones por sus servicios
    When accede a su sección de retroalimentación
    Then puede ver todas las valoraciones recibidas de sus clientes
      | Criterio Evaluado     | Puntaje Promedio | Estado Aspecto |
      | Puntualidad           | 4.9 / 5.0        | Fuerte         |
      | Claridad del Reporte  | 4.2 / 5.0        | A Mejorar      |
    And puede identificar los aspectos mejor y peor valorados

  Scenario: Consulta detallada de comentarios individuales por fecha
    Given que un Técnico inspecciona los desgloses de su módulo de calidad
    When filtra los comentarios individuales cronológicamente de forma descendente
      | Ordenamiento   | Rango Temporal |
      | Más Recientes  | Últimos 30 días|
    Then el sistema organiza las opiniones individuales exponiendo el detalle preciso
      | Fecha Registro | Puntuación | Comentario Técnico Recibido        |
      | 14/06/2026     | 5          | Solucionó el percance en minutos.  |