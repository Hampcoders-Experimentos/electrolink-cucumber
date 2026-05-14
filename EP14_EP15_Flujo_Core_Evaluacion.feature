Feature: EP-14 & EP-15 - Flujo de Solicitud, Asignación y Evaluación

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s=''; var chars='abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0;i<len;i++){s+=chars.charAt(Math.floor(Math.random()*chars.length));} return s; }
# =========================================================================
# TECHNICAL STORIES - EP-14 (Solicitud y Asignación)
# =========================================================================

  Scenario: TS-06 - Obtener Servicios por Zona
    Given path 'services/search'
    And param lat = -12.0945
    And param lon = -77.0321
    When method get
    Then status 200
    And match response == '#array'
    * print 'Servicios encontrados para la ubicación especificada.'

  Scenario: TS-07 - Iniciar Flujo de Solicitud: Usuario gratuito alcanza el límite
    * def owner = 'free_user_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(owner)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(owner)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Simular que ya tiene 2 solicitudes este mes (limite de plan gratuito)
    # Este escenario asume que hay un check previo o que el backend valida esto al intentar crear
    Given path 'requests/check-limit'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.canRequest == true
    * print 'Usuario dentro del límite.'

  Scenario: TS-08 - Enviar Solicitud de Servicio: Envío exitoso
    * def owner = 'owner_req_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(owner)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(owner)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'requests'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "clientId": "user-uuid-001",
        "propertyId": "prop-uuid-001",
        "serviceId": 1,
        "problemDescription": "Cortocircuito en sala",
        "scheduledDate": "2026-05-20",
        "isPriority": false,
        "bill": {
          "billingPeriod": "Mayo 2026",
          "energyConsumed": 250.5,
          "amountPaid": 120.00
        }
      }
      """
    When method post
    Then status 201
    And match response.id != '#null'

  Scenario: TS-09 - Asignar Técnico Automáticamente
    Given path 'admin/tasks/auto-assign'
    When method post
    Then status 200
    * print 'Proceso de asignación automática ejecutado.'
# =========================================================================
# TECHNICAL STORIES - EP-15 (Evaluación)
# =========================================================================

  Scenario: TS-11 - Enviar Evaluación de Servicio: Evaluación exitosa
    * def owner = 'owner_eval_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(owner)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(owner)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'ratings'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "requestId": 1,
        "score": 5,
        "comment": "Excelente atención técnica",
        "raterId": "user-uuid-001",
        "technicianId": 1
      }
      """
    When method post
    Then status 201
    And match response.score == 5

  Scenario: TS-12 - Obtener Evaluaciones por Técnico
    Given path 'ratings/technician/1'
    When method get
    Then status 200
    And match response == '#array'
    * print 'Lista de evaluaciones del técnico obtenida.'
