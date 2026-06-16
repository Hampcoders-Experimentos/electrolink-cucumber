# User Story: US-04 - Visualización de una Sección Principal
Feature: Visualización de una Sección Principal

  Scenario: Presentación del propósito de la plataforma
    Given que un visitante accede a la plataforma informativa
    When la carga inicial se completa
    Then se muestra una sección principal con un título que explica el propósito del sistema
      | Elemento UI | Texto Requerido                                         |
      | Título      | Conectando Soluciones Eléctricas de Forma Segura        |
      | Subtítulo   | Encuentra técnicos calificados y gestiona tus servicios |
    And se incluye un subtítulo que resume el valor principal del servicio
    And se presenta una llamada a la acción principal para invitar al registro
      | Botón CTA          | Destino             |
      | Regístrate Aquí    | /auth/register      |

Scenario: Diseño atractivo y profesional
    Given que un visitante accede a la plataforma informativa
    When visualiza la sección principal
      | Elemento UI | Requisitos de Diseño                                       |
      | Título      | Fuente grande, negrita, color destacado                    |
      | Subtítulo   | Fuente legible, tamaño mediano, color complementario       |
      | Fondo       | Imagen o color de fondo que refleje profesionalismo        |
    Then el diseño general de la sección principal debe ser atractivo y profesional
    And debe transmitir confianza y seguridad a los visitantes