Feature: EP-09 - Suscripciones y Pagos (Stripe Integration)

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s=''; var chars='abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0;i<len;i++){s+=chars.charAt(Math.floor(Math.random()*chars.length));} return s; }

# =========================================================================
# TECHNICAL STORIES - EP-09
# =========================================================================

  Scenario: TS-14 - Listener de Webhook de Stripe: Suscripción exitosa
    # Simular un webhook de Stripe (checkout.session.completed)
    Given path 'webhooks/stripe'
    And header Stripe-Signature = 'valid_mock_signature'
    And request 
    """
    {
      "type": "checkout.session.completed",
      "data": {
        "object": {
          "client_reference_id": "user-uuid-001",
          "customer": "cus_001",
          "subscription": "sub_001"
        }
      }
    }
    """
    When method post
    Then status 200
    * print 'Webhook procesado. El usuario user-uuid-001 ahora es Premium.'

  Scenario: TS-14 - Listener de Webhook de Stripe: Firma inválida
    Given path 'webhooks/stripe'
    And header Stripe-Signature = 'invalid_signature'
    And request { "type": "checkout.session.completed" }
    When method post
    Then status 400
    * print 'Webhook rechazado por firma inválida.'

  Scenario: TS-15 - Reinicio Mensual de Contador (Cron Job)
    # Simular la ejecución de la tarea programada (si hay un endpoint de trigger para test)
    # O simplemente validar el impacto si se puede disparar manualmente
    Given path 'admin/tasks/reset-counters'
    And param date = '2026-06-01'
    When method post
    Then status 200
    * print 'Contadores de solicitudes reiniciados para el nuevo mes.'

  Scenario: TS-16 - Sesión de Portal de Stripe: Generación exitosa
    * def user = 'premium_user_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(user)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(user)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    
    # Simular que el usuario ya es Premium para acceder al portal
    Given path 'subscriptions/portal-session'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.url contains 'stripe.com'
    * print 'URL del Portal de Stripe generada correctamente.'
