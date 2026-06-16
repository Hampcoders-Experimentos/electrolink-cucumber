# User Story: US-60 - Registro Fotográfico de Trabajos (Antes/Después)
Feature: Registro Fotográfico de Trabajos (Antes/Después)

  Scenario: Adjuntar evidencia fotográfica
    Given que un Técnico está gestionando un servicio activo
    When sube fotografías correspondientes al "antes" y "después" del trabajo
      | Tipo Captura | Nombre Archivo | Formato | Dimensión |
      | Antes        | tablero_quemado.jpg| JPEG    | 1920x1080 |
      | Después      | tablero_nuevo.jpg  | JPEG    | 1920x1080 |
    Then las imágenes quedan asociadas al registro del servicio como evidencia

  Scenario: Carga fallida de evidencia técnica por formato incompatible
    Given que un Técnico intenta añadir un archivo de extensión inválida como prueba de labor
    When sube el recurso a la orden de servicio en ejecución
      | Tipo Captura | Nombre Archivo      | Formato Incompatible |
      | Antes        | documento_notas.exe | EXE                  |
    Then el cargador de archivos interrumpe la transferencia del recurso
    And muestra una alerta restrictiva indicando los formatos admitidos (JPG, PNG)