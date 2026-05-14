Feature: EP-10 - Gestión de Activos (Componentes y Propiedades)

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s=''; var chars='abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0;i<len;i++){s+=chars.charAt(Math.floor(Math.random()*chars.length));} return s; }

# =========================================================================
# USER STORIES - EP-10
# =========================================================================

# -------------------------------------------------------------------------
# US-31, US-32, US-33, US-37, US-38, US-39: Gestión de Componentes (Técnico)
# -------------------------------------------------------------------------

  Scenario: US-31 & US-37 - Registro de un nuevo componente eléctrico con stock
    * def techUsername = 'tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    
    Given path 'assets/components'
    And header Authorization = 'Bearer ' + token
    And request 
    """
    {
      "name": "Interruptor Termomagnético 20A",
      "brand": "Schneider",
      "model": "Acti9",
      "quantity": 10,
      "unitCost": 25.50,
      "minStockThreshold": 2
    }
    """
    When method post
    Then status 201
    And match response.name == "Interruptor Termomagnético 20A"
    And match response.quantity == 10
    * def componentId = response.id

  Scenario: US-32 & US-38 - Edición de datos técnicos y ajuste manual de stock
    * def techUsername = 'tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    
    # Crear componente inicial
    Given path 'assets/components'
    And header Authorization = 'Bearer ' + token
    And request { "name": "Cable 14AWG", "brand": "Indeco", "quantity": 100, "unitCost": 1.20 }
    When method post
    Then status 201
    * def componentId = response.id

    # Editar componente
    Given path 'assets/components', componentId
    And header Authorization = 'Bearer ' + token
    And request { "name": "Cable 14AWG Rojo", "brand": "Indeco", "quantity": 150, "unitCost": 1.25 }
    When method put
    Then status 200
    And match response.name == "Cable 14AWG Rojo"
    And match response.quantity == 150

  Scenario: US-33 - Eliminación de componente eléctrico
    * def techUsername = 'tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    
    # Crear componente
    Given path 'assets/components'
    And header Authorization = 'Bearer ' + token
    And request { "name": "Socket Loza", "brand": "Generic", "quantity": 5, "unitCost": 3.00 }
    When method post
    Then status 201
    * def componentId = response.id

    # Eliminar componente
    Given path 'assets/components', componentId
    And header Authorization = 'Bearer ' + token
    When method delete
    Then status 204

  Scenario: US-39 - Configuración de Alertas de Stock Mínimo
    * def techUsername = 'tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    
    # Crear componente con umbral
    Given path 'assets/components'
    And header Authorization = 'Bearer ' + token
    And request { "name": "Fusible 10A", "brand": "General Electric", "quantity": 5, "unitCost": 0.50, "minStockThreshold": 3 }
    When method post
    Then status 201
    And match response.minStockThreshold == 3

# -------------------------------------------------------------------------
# US-34, US-35, US-36: Gestión de Propiedades (Propietario)
# -------------------------------------------------------------------------

  Scenario: US-34 - Registro de una nueva propiedad
    * def ownerUsername = 'owner_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    
    Given path 'assets/properties'
    And header Authorization = 'Bearer ' + token
    And request 
    """
    {
      "address": "Calle Las Begonias 123",
      "district": "San Isidro",
      "city": "Lima",
      "propertyType": "RESIDENTIAL",
      "latitude": -12.0945,
      "longitude": -77.0321
    }
    """
    When method post
    Then status 201
    And match response.address == "Calle Las Begonias 123"
    * def propertyId = response.id

  Scenario: US-35 - Edición de información de propiedad
    * def ownerUsername = 'owner_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    
    # Crear propiedad
    Given path 'assets/properties'
    And header Authorization = 'Bearer ' + token
    And request { "address": "Av. Larco 456", "district": "Miraflores", "city": "Lima" }
    When method post
    Then status 201
    * def propertyId = response.id

    # Editar propiedad
    Given path 'assets/properties', propertyId
    And header Authorization = 'Bearer ' + token
    And request { "address": "Av. Larco 789", "district": "Miraflores", "city": "Lima" }
    When method put
    Then status 200
    And match response.address == "Av. Larco 789"

  Scenario: US-36 - Eliminación de propiedad
    * def ownerUsername = 'owner_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    
    # Crear propiedad
    Given path 'assets/properties'
    And header Authorization = 'Bearer ' + token
    And request { "address": "Calle A 1", "district": "Lince", "city": "Lima" }
    When method post
    Then status 201
    * def propertyId = response.id

    # Eliminar propiedad
    Given path 'assets/properties', propertyId
    And header Authorization = 'Bearer ' + token
    When method delete
    Then status 204
