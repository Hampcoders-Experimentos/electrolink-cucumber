Feature: EP-11 - Catálogo de Servicios con Recetas de Componentes

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s=''; var chars='abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0;i<len;i++){s+=chars.charAt(Math.floor(Math.random()*chars.length));} return s; }

# =========================================================================
# USER STORIES - EP-11
# =========================================================================

  Scenario: US-53 - Crear un servicio en catálogo con receta de componentes
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
    
    # 1. El técnico debe tener componentes en su inventario para usarlos en la receta
    Given path 'assets/components'
    And header Authorization = 'Bearer ' + token
    And request { "name": "Disyuntor 32A", "brand": "BTicino", "quantity": 20, "unitCost": 45.00 }
    When method post
    Then status 201
    * def componentId = response.id

    # 2. Crear servicio con receta (referenciando el componente)
    Given path 'services'
    And header Authorization = 'Bearer ' + token
    And request 
    """
    {
      "name": "Cambio de Llave General",
      "description": "Servicio de cambio de interruptor general de tablero",
      "basePrice": 80.00,
      "estimatedTime": 1,
      "category": "MAINTENANCE",
      "recipe": [
        {
          "componentId": #(componentId),
          "quantityRequired": 1
        }
      ]
    }
    """
    When method post
    Then status 201
    And match response.name == "Cambio de Llave General"
    And match response.recipe[0].componentId == componentId

  Scenario: US-54 - Modificar servicios y sus recetas de componentes
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
    
    # Crear servicio inicial
    Given path 'services'
    And header Authorization = 'Bearer ' + token
    And request { "name": "Revisión Básica", "description": "Chequeo visual", "basePrice": 40.00 }
    When method post
    Then status 201
    * def serviceId = response.id

    # Modificar receta del servicio (añadiendo componentes)
    Given path 'services', serviceId
    And header Authorization = 'Bearer ' + token
    And request 
    """
    {
      "name": "Revisión Básica Plus",
      "description": "Chequeo visual y limpieza de contactos",
      "basePrice": 50.00,
      "recipe": [
        {
          "componentName": "Limpia Contactos",
          "quantityRequired": 0.1
        }
      ]
    }
    """
    When method put
    Then status 200
    And match response.name == "Revisión Básica Plus"

  Scenario: US-55 - Eliminar servicios del catálogo
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
    
    # Crear servicio
    Given path 'services'
    And header Authorization = 'Bearer ' + token
    And request { "name": "Servicio Obsoleto", "description": "Ya no se ofrece", "basePrice": 10.00 }
    When method post
    Then status 201
    * def serviceId = response.id

    # Eliminar servicio
    Given path 'services', serviceId
    And header Authorization = 'Bearer ' + token
    When method delete
    Then status 204
