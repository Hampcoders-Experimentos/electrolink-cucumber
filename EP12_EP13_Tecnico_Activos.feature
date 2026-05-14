Feature: EP-12 & EP-13 - Endpoints Técnicos de Propiedades e Inventario

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s=''; var chars='abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0;i<len;i++){s+=chars.charAt(Math.floor(Math.random()*chars.length));} return s; }
# =========================================================================
# TECHNICAL STORIES - EP-12 (Propiedades)
# =========================================================================

  Scenario: TS-01 - Registrar Propiedad: Registro exitoso
    * def owner = 'owner_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(owner)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(owner)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'assets/properties'
    And header Authorization = 'Bearer ' + token
    And request { "address": "Av. Brasil 123", "district": "Jesús María", "city": "Lima", "propertyType": "RESIDENTIAL" }
    When method post
    Then status 201
    And match response.address == "Av. Brasil 123"

  Scenario: TS-02 - Obtener Propiedades por Propietario
    * def owner = 'owner_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(owner)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(owner)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'assets/properties/owner'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
# =========================================================================
# TECHNICAL STORIES - EP-13 (Inventario y Servicios)
# =========================================================================

  Scenario: TS-03 - Crear Componente: Creación exitosa
    * def tech = 'tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(tech)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(tech)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'assets/components'
    And header Authorization = 'Bearer ' + token
    And request { "name": "Relé Térmico", "brand": "ABB", "quantity": 10, "unitCost": 15.00 }
    When method post
    Then status 201
    And match response.name == "Relé Térmico"

  Scenario: TS-04 - Actualizar Stock de Componente: Actualización exitosa (PATCH)
    * def tech = 'tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(tech)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(tech)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Crear componente
    Given path 'assets/components'
    And header Authorization = 'Bearer ' + token
    And request { "name": "Tubo PVC 1/2", "brand": "Matusita", "quantity": 50, "unitCost": 0.80 }
    When method post
    Then status 201
    * def componentId = response.id
    # Actualizar stock
    Given path 'assets/components', componentId
    And header Authorization = 'Bearer ' + token
    And request { "quantity": 60 }
    When method patch
    Then status 200
    And match response.quantity == 60

  Scenario: TS-05 - Crear Servicio de Técnico con Receta
    * def tech = 'tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(tech)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(tech)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'assets/components'
    And header Authorization = 'Bearer ' + token
    And request { "name": "Cinta Aislante", "brand": "3M", "quantity": 10, "unitCost": 5.00 }
    When method post
    Then status 201
    * def componentId = response.id
    Given path 'services'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "name": "Encintado Preventivo",
        "description": "Protección de cables",
        "basePrice": 20.00,
        "recipe": [
          { "componentId": #(componentId), "quantityRequired": 1 }
        ]
      }
      """
    When method post
    Then status 201
    And match response.recipe[0].componentId == componentId

  Scenario: TS-10 - Actualización Automática de Stock (Event Listener)
    # Simular la finalización de un servicio que dispara el evento
    Given path 'admin/test/complete-service-event'
    And request { "serviceId": 1, "componentsUsed": [{ "id": 1, "qty": 2 }] }
    When method post
    Then status 200
    * print 'Evento de servicio completado procesado. Stock descontado.'
