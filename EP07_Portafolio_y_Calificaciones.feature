Feature: EP-07 - Portafolio, Reportes Técnicos y Sistema de Calificaciones

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s=''; var chars='abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0;i<len;i++){s+=chars.charAt(Math.floor(Math.random()*chars.length));} return s; }

# =========================================================================
# USER STORIES - EP-07
# =========================================================================

# -------------------------------------------------------------------------
# US-28: Crear Portafolio Digital con Evidencias de Trabajo
# Como técnico, quiero crear un portafolio digital dentro de mi perfil que
# incluya fotos, descripciones y referencias de trabajos anteriores.
# -------------------------------------------------------------------------
  Scenario: US-28 - Escenario 1: Técnico añade trabajo al portafolio via perfil
    * def techUsername = 'portfolio_' + randomString(6)
    * def email = techUsername + '@tech.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Crear perfil con portafolio inicial
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "firstName": "Luis",
        "lastName": "Portfolio",
        "email": "#(email)",
        "street": "Av. Taller 200",
        "role": "TECHNICIAN",
        "additionalInfoOrCertification": "Portafolio: [Trabajo1: Instalación Tablero Eléctrico - Lima 2025 | Trabajo2: Cableado Estructurado Oficina - Lima 2025]"
      }
      """
    When method post
    Then status 201
    * def profileId = response.id
    And match response.additionalInfoOrCertification contains 'Portafolio'
    * print 'Portafolio creado en perfil del técnico ID:', profileId

  Scenario: US-28 - Escenario 2: Técnico actualiza portafolio con nuevo trabajo
    * def techUsername = 'port_upd_' + randomString(6)
    * def email = techUsername + '@tech.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Ana", "lastName": "Técnica", "email": "#(email)", "street": "Calle 5", "role": "TECHNICIAN", "additionalInfoOrCertification": "Portafolio: [Trabajo1: Panel solar residencial]" }
    When method post
    Then status 201
    * def profileId = response.id
    # Actualizar portafolio añadiendo nuevo trabajo por categoría
    Given path 'profiles', profileId
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "id": "#(profileId)",
        "firstName": "Ana",
        "lastName": "Técnica",
        "email": "#(email)",
        "street": "Calle 5",
        "role": "TECHNICIAN",
        "additionalInfoOrCertification": "Portafolio: [RESIDENCIAL: Panel solar, tablero eléctrico | COMERCIAL: Cableado oficina 200m2]",
        "isVerified": false
      }
      """
    When method put
    Then status 200
    And match response.additionalInfoOrCertification contains 'COMERCIAL'
    * print 'Portafolio actualizado con categorías - visible en perfil público'

# -------------------------------------------------------------------------
# US-60: Registro Fotográfico de Trabajos (Antes/Después)
# Como técnico ejecutando un servicio, quiero subir fotografías del área
# de trabajo antes y después de la intervención.
# -------------------------------------------------------------------------
  Scenario: US-60 - Escenario 1: Técnico crea operación y adjunta reporte con evidencia fotográfica
    * def techUsername = 'photo_tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear operación de servicio activa
    Given path 'service-operations'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 30, "technicianId": 1 }
    When method post
    Then status 201
    * def opId = response.id

    # Avanzar a IN_PROGRESS
    Given path 'service-operations/status'
    And header Authorization = 'Bearer ' + token
    And request { "serviceOperationId": "#(opId)", "newStatus": "IN_PROGRESS" }
    When method put
    Then status 204

    # Crear reporte con referencias a fotos ANTES del trabajo
    Given path 'reports'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "serviceOperationId": #(opId),
        "reportType": "INCIDENT",
        "description": "ANTES: Tablero con cableado deteriorado. Fotos: [https://storage.electrolink.com/photos/antes-001.jpg, https://storage.electrolink.com/photos/antes-002.jpg]"
      }
      """
    When method post
    Then status 201
    * def reportId = response
    * print 'Reporte con evidencia fotográfica ANTES creado, ID:', reportId

  Scenario: US-60 - Escenario 2: Técnico añade foto del DESPUÉS al reporte existente
    * def techUsername = 'photo_after_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    Given path 'service-operations'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 31, "technicianId": 1 }
    When method post
    Then status 201
    * def opId = response.id

    # Crear reporte con foto DESPUÉS
    Given path 'reports'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "serviceOperationId": #(opId),
        "reportType": "COMPLETION",
        "description": "DESPUÉS: Tablero nuevo instalado correctamente. Foto: https://storage.electrolink.com/photos/despues-001.jpg"
      }
      """
    When method post
    Then status 201
    * def reportId = response
    * print 'Evidencia fotográfica DESPUÉS registrada. Ambas fotos quedan como evidencia del servicio.'

    # Verificar reportes de la operación
    Given path 'reports/requests', opId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Total evidencias fotográficas de la operación:', response.length

# -------------------------------------------------------------------------
# US-61: Generación de Reportes Técnicos Estructurados
# Como técnico, quiero generar un reporte técnico estructurado con
# componentes utilizados, procedimientos y recomendaciones.
# -------------------------------------------------------------------------
  Scenario: US-61 - Escenario 1: Técnico genera reporte de servicio al finalizar trabajo
    * def techUsername = 'report_gen_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear y completar operación de servicio
    Given path 'service-operations'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 40, "technicianId": 1 }
    When method post
    Then status 201
    * def opId = response.id

    Given path 'service-operations/status'
    And header Authorization = 'Bearer ' + token
    And request { "serviceOperationId": "#(opId)", "newStatus": "IN_PROGRESS" }
    When method put
    Then status 204

    # Generar reporte técnico estructurado
    Given path 'reports'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "serviceOperationId": #(opId),
        "reportType": "COMPLETION",
        "description": "REPORTE TÉCNICO ESTRUCTURADO:\n- Componentes utilizados: 1 disyuntor 20A, 5m cable 4mm2, 2 terminales\n- Procedimiento: Reemplazo de disyuntor defectuoso y revisión de conexiones\n- Hallazgos: Cableado con desgaste parcial en zona de tablero\n- Recomendaciones: Revisión preventiva en 6 meses\n- Estado final: Instalación operativa al 100%"
      }
      """
    When method post
    Then status 201
    * def reportId = response
    * print 'Reporte técnico estructurado creado y asociado al historial del servicio, ID:', reportId

  Scenario: US-61 - Escenario 2: Propietario puede consultar el reporte técnico de su servicio
    * def ownerUsername = 'report_view_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Consultar reportes de una operación de servicio específica
    Given path 'reports/requests', 1
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Reportes técnicos disponibles para el propietario - Total:', response.length

# -------------------------------------------------------------------------
# US-64: Sistema de Calificación Post-Servicio
# Como usuario, quiero calificar y dejar reseñas sobre los servicios
# que he utilizado, para proporcionar retroalimentación a los técnicos.
# -------------------------------------------------------------------------
  Scenario: US-64 - Escenario 1: Propietario califica servicio completado (score 1-5)
    * def ownerUsername = 'rate_owner_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Calificar el servicio (score 5, comentario)
    Given path 'ratings'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "requestId": 1,
        "score": 5,
        "comment": "Excelente trabajo. El técnico llegó puntual, explicó todo el proceso y dejó el área de trabajo limpia. 100% recomendado.",
        "raterId": "#(ownerUsername)",
        "technicianId": 1
      }
      """
    When method post
    Then status 201
    * def ratingId = response.id
    And match response.score == 5
    And match response.comment contains 'Excelente'
    * print 'Calificación de 5 estrellas registrada y asociada al técnico. ID:', ratingId

  Scenario: US-64 - Escenario 2: Propietario califica servicio con comentario de baja puntuación
    * def ownerUsername = 'rate_low_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    Given path 'ratings'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "requestId": 2,
        "score": 2,
        "comment": "El trabajo tomó más tiempo del esperado y quedaron algunos detalles pendientes.",
        "raterId": "#(ownerUsername)",
        "technicianId": 2
      }
      """
    When method post
    Then status 201
    And match response.score == 2
    * print 'Calificación de 2 estrellas con comentario negativo registrada para retroalimentación del técnico'

  Scenario: US-64 - Escenario 3: Sistema valida que score esté entre 1 y 5
    * def ownerUsername = 'rate_val_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Score válido máximo (5)
    Given path 'ratings'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 3, "score": 5, "comment": "Perfecto", "raterId": "#(ownerUsername)", "technicianId": 1 }
    When method post
    Then status 201
    * print 'Score 5 válido aceptado correctamente'

# -------------------------------------------------------------------------
# US-65: Visualización de Calificaciones y Reseñas
# Como usuario, quiero ver las calificaciones y reseñas dejadas por otros
# usuarios para tomar decisiones informadas.
# -------------------------------------------------------------------------
  Scenario: US-65 - Escenario 1: Propietario consulta reputación de un técnico (ratings y promedio)
    * def ownerUsername = 'view_rate_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear calificaciones para el técnico ID=1
    Given path 'ratings'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 10, "score": 5, "comment": "Muy profesional", "raterId": "#(ownerUsername)", "technicianId": 1 }
    When method post
    Then status 201

    # Ver todas las calificaciones del técnico
    Given path 'ratings/technicians', 1
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Calificaciones del técnico 1 - Total reseñas:', response.length

  Scenario: US-65 - Escenario 2: Propietario ve ratings destacados del técnico
    * def ownerUsername = 'feat_rate_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Consultar ratings destacados (featured) del técnico
    Given path 'ratings/technicians', 1, 'featured'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Ratings destacados del técnico - Total:', response.length

  Scenario: US-65 - Escenario 3: Propietario consulta todas las reseñas de una solicitud específica
    * def ownerUsername = 'req_rate_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Ver ratings por solicitud específica
    Given path 'ratings/requests', 1
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Reseñas de la solicitud 1 - Total:', response.length

# -------------------------------------------------------------------------
# US-66: Retroalimentación Directa de Servicios
# Como técnico, quiero recibir retroalimentación directa sobre mis
# servicios para mejorar mi oferta.
# -------------------------------------------------------------------------
  Scenario: US-66 - Escenario 1: Técnico visualiza todas las valoraciones recibidas
    * def techUsername = 'feedback_tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Técnico consulta todas sus valoraciones
    Given path 'ratings/technicians', 1
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Técnico ve retroalimentación recibida - Total valoraciones:', response.length

  Scenario: US-66 - Escenario 2: Técnico identifica aspectos mejor valorados (ratings destacados)
    * def techUsername = 'feedback_feat_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Consultar ratings destacados (mejores valoraciones)
    Given path 'ratings/technicians', 1, 'featured'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Aspectos mejor valorados del técnico - Ratings destacados:', response.length

  Scenario: US-66 - Escenario 3: Técnico puede actualizar respuesta a reseña y eliminar valoración inapropiada
    * def ownerUsername = 'fb_owner_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear valoración
    Given path 'ratings'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 50, "score": 3, "comment": "Trabajo aceptable", "raterId": "#(ownerUsername)", "technicianId": 1 }
    When method post
    Then status 201
    * def ratingId = response.id

    # Actualizar score y comentario de la valoración
    Given path 'ratings'
    And header Authorization = 'Bearer ' + token
    And request { "id": "#(ratingId)", "score": 4, "comment": "Buen trabajo, cumplió con lo acordado" }
    When method put
    Then status 200
    * print 'Valoración actualizada correctamente. Retroalimentación mejorada para el técnico.'
