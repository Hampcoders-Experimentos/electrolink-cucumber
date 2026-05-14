Feature: EP-05 - Historial de Servicios Contratados

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s=''; var chars='abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0;i<len;i++){s+=chars.charAt(Math.floor(Math.random()*chars.length));} return s; }

# =========================================================================
# USER STORIES - EP-05
# =========================================================================

# -------------------------------------------------------------------------
# US-47: Historial de servicios contratados
# Como cliente, quiero ver un historial de los servicios que he contratado
# anteriormente, para así tener referencia futura.
# -------------------------------------------------------------------------
  Scenario: US-47 - Escenario 1: Propietario visualiza historial de servicios contratados
    * def ownerUsername = 'hist_owner_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Crear solicitud para tener historial
    Given path 'requests'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "clientId": "client-hist-001",
        "technicianId": "tech-001",
        "propertyId": "prop-hist-uuid-001",
        "serviceId": "service-001",
        "problemDescription": "Revisión eléctrica general",
        "scheduledDate": "2026-05-20",
        "bill": { "billingPeriod": "Abril 2026", "energyConsumed": 300.0, "amountPaid": 130.00, "billImageUrl": null },
        "photos": [],
        "isPriority": false
      }
      """
    When method post
    Then status 201
    # Consultar historial de solicitudes del cliente
    Given path 'requests/clients/client-hist-001/requests'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Historial de servicios. Total:', response.length

  Scenario: US-47 - Escenario 2: Historial muestra detalle de cada servicio (fecha, técnico, estado)
    * def ownerUsername = 'hist_detail_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'requests'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "clientId": "client-detail-hist-001",
        "technicianId": "tech-detail-001",
        "propertyId": "prop-hist-det-001",
        "serviceId": "service-002",
        "problemDescription": "Instalación de luminarias LED",
        "scheduledDate": "2026-05-25",
        "bill": { "billingPeriod": "Abril 2026", "energyConsumed": 210.5, "amountPaid": 95.75, "billImageUrl": null },
        "photos": [],
        "isPriority": false
      }
      """
    When method post
    Then status 201
    * def msgRaw = response.message
    * def requestId = msgRaw.split(': ')[1]
    Given path 'requests', requestId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.clientId == 'client-detail-hist-001'
    And match response.technicianId == 'tech-detail-001'
    And match response.scheduledDate != '#null'
    * print 'Detalle: fecha:', response.scheduledDate, '| técnico:', response.technicianId

  Scenario: US-47 - Escenario 3: Historial vacío para cliente sin solicitudes previas
    * def newUsername = 'hist_empty_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(newUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(newUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'requests/clients/cliente-nuevo-sin-historial/requests'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '[]'
    * print 'Historial vacío confirmado para cliente nuevo'
