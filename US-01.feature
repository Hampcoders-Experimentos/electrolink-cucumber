# User Story: US-01 - Visualización de Características y Beneficios
Feature: Visualización de Características y Beneficios

  Scenario: Visualización de beneficios para usuarios
    Given que un visitante se encuentra explorando la plataforma informativa
    When revisa la sección de propuestas de valor
    Then debe identificar claramente los beneficios específicos para Propietarios y Técnicos
      | Rol         | Beneficio                               | Descripción                                  |
      | Propietario | Gestión estructurada de servicios       | Contratación paso a paso de forma segura.    |
      | Técnico     | Control de operaciones y oportunidades  | Administración de agenda, servicios y pagos. |
    And cada beneficio debe tener una descripción breve y clara

  Scenario: Visualización de características principales
    Given que un visitante se encuentra en la plataforma informativa
    When explora la sección de características
    Then debe ver las funcionalidades destacadas de la plataforma
      | Característica      | Título Descriptivo                  | Explicación Concisa                        |
      | Asignación          | Asignación Automática               | Conexión inmediata con técnicos de la zona |
      | Inventario          | Gestión de Stock                    | Control automatizado de componentes.       |
    And cada característica debe tener un título descriptivo y una explicación concisa de su funcionamiento