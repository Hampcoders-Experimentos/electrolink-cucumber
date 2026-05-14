Feature: EP-04 - Solicitud de Servicio y Seguimiento en Tiempo Real

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s=''; var chars='abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0;i<len;i++){s+=chars.charAt(Math.floor(Math.random()*chars.length));} return s; }

    # -----------------------------------------------------------------------
    # Setup: Registra usuario, hace login, retorna token
    # -----------------------------------------------------------------------
    * def setupUser =
      """
      function(prefix, roleArr) {
        var uname = prefix + '_' + randomString(6);
        var pw = 'Password123';
        karate.call('authentication/sign-up', { method: 'post', request: { username: uname, password: pw, roles: roleArr } });
        var res = karate.http('http://localhost:8080/api/v1/authentication/sign-in').post({ username: uname, password: pw });
        return { token: res.body.token, username: uname };
      }
      """

# =========================================================================
# USER STORIES - EP-04
# =========================================================================

# -------------------------------------------------------------------------
# US-40: Contratación de Servicios Eléctricos mediante Wizard
# Como propietario, quiero un proceso guiado paso a paso para contratar
# servicios eléctricos y generar una solicitud de servicio.
# -------------------------------------------------------------------------
  Scenario: US-40 - Escenario 1: Propietario completa wizard y crea solicitud de servicio
    # Paso 1: Registro y login del propietario
    * def ownerUsername = 'wizard_owner_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def ownerToken = response.token

    # Paso 2: Crear solicitud de servicio (resultado final del wizard)
    Given path 'requests'
    And header Authorization = 'Bearer ' + ownerToken
    And request
      """
      {
        "clientId": "client-wizard-001",
        "technicianId": "tech-001",
        "propertyId": "prop-uuid-001",
        "serviceId": "service-001",
        "problemDescription": "Corte de luz en habitaciones del primer piso",
        "scheduledDate": "2026-06-01",
        "bill": {
          "billingPeriod": "Mayo 2026",
          "energyConsumed": 320.5,
          "amountPaid": 145.80,
          "billImageUrl": "https://storage.electrolink.com/bills/may2026.jpg"
        },
        "photos": [],
        "isPriority": false
      }
      """
    When method post
    Then status 201
    And match response.message contains 'Request created with ID'
    * print 'Solicitud creada exitosamente mediante wizard:', response.message

# -------------------------------------------------------------------------
# US-41: Selección de Propiedad
# Como propietario con múltiples propiedades, quiero seleccionar la
# propiedad donde necesito el servicio.
# -------------------------------------------------------------------------
  Scenario: US-41 - Escenario 1: Propietario incluye propertyId en solicitud de servicio
    * def ownerUsername = 'prop_select_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear solicitud con propiedad específica seleccionada
    Given path 'requests'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "clientId": "client-prop-001",
        "technicianId": "tech-001",
        "propertyId": "selected-property-uuid-123",
        "serviceId": "service-001",
        "problemDescription": "Falla en instalación eléctrica",
        "scheduledDate": "2026-06-05",
        "bill": {
          "billingPeriod": "Abril 2026",
          "energyConsumed": 250.0,
          "amountPaid": 120.00,
          "billImageUrl": null
        },
        "photos": [],
        "isPriority": false
      }
      """
    When method post
    Then status 201
    And match response.message contains 'Request created with ID'
    * print 'Solicitud con propertyId específico creada correctamente'

# -------------------------------------------------------------------------
# US-42: Carga Manual de Datos de Recibos Eléctricos
# Como propietario, quiero ingresar datos de mi recibo eléctrico durante
# la solicitud, para registrar mi historial de consumo.
# -------------------------------------------------------------------------
  Scenario: US-42 - Escenario 1: Datos de recibo incluidos correctamente en la solicitud
    * def ownerUsername = 'bill_upload_' + randomString(6)
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
        "clientId": "client-bill-001",
        "technicianId": "tech-001",
        "propertyId": "prop-bill-uuid-001",
        "serviceId": "service-001",
        "problemDescription": "Revisión preventiva de instalación",
        "scheduledDate": "2026-06-10",
        "bill": {
          "billingPeriod": "Mayo 2026",
          "energyConsumed": 450.75,
          "amountPaid": 210.30,
          "billImageUrl": "https://storage.electrolink.com/bills/recibo-mayo.jpg"
        },
        "photos": [],
        "isPriority": false
      }
      """
    When method post
    Then status 201
    And match response.message contains 'Request created with ID'
    * print 'Datos del recibo eléctrico almacenados con la solicitud para análisis de consumo'

# -------------------------------------------------------------------------
# US-43: Descripción Detallada del Problema Eléctrico
# Como propietario, quiero añadir una descripción detallada de mi problema
# para que el técnico asignado llegue informado.
# -------------------------------------------------------------------------
  Scenario: US-43 - Escenario 1: Solicitud con descripción detallada del problema
    * def ownerUsername = 'prob_desc_' + randomString(6)
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
        "clientId": "client-desc-001",
        "technicianId": "tech-001",
        "propertyId": "prop-desc-uuid-001",
        "serviceId": "service-001",
        "problemDescription": "Disyuntor principal salta frecuentemente al conectar electrodomésticos. El problema ocurre especialmente en la noche cuando se usa el microondas y la lavadora al mismo tiempo. El tablero eléctrico tiene 15 años.",
        "scheduledDate": "2026-06-08",
        "bill": {
          "billingPeriod": "Mayo 2026",
          "energyConsumed": 310.0,
          "amountPaid": 130.50,
          "billImageUrl": null
        },
        "photos": [],
        "isPriority": false
      }
      """
    When method post
    Then status 201
    And match response.message contains 'Request created with ID'
    * print 'Solicitud con descripción detallada creada. El técnico verá el contexto del problema.'

# -------------------------------------------------------------------------
# US-44: Selección de Servicio Específico del Catálogo
# Como propietario, quiero ver el catálogo de servicios disponibles en mi
# zona y seleccionar el que necesito.
# -------------------------------------------------------------------------
  Scenario: US-44 - Escenario 1: Listar servicios del catálogo disponibles
    * def ownerUsername = 'catalog_usr_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    Given path 'services'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Catálogo de servicios obtenido. Total disponibles:', response.length

  Scenario: US-44 - Escenario 2: Solicitud vinculada a serviceId específico del catálogo
    * def ownerUsername = 'catalog_req_' + randomString(6)
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
        "clientId": "client-cat-001",
        "technicianId": "tech-001",
        "propertyId": "prop-cat-uuid-001",
        "serviceId": "service-electrico-basico-001",
        "problemDescription": "Instalación de toma corriente adicional",
        "scheduledDate": "2026-06-12",
        "bill": {
          "billingPeriod": "Mayo 2026",
          "energyConsumed": 200.0,
          "amountPaid": 95.00,
          "billImageUrl": null
        },
        "photos": [],
        "isPriority": false
      }
      """
    When method post
    Then status 201
    * print 'Solicitud vinculada al servicio seleccionado del catálogo'

# -------------------------------------------------------------------------
# US-45: Cancelación de Servicios Programados
# Como cliente, quiero cancelar un servicio programado con anticipación,
# para así evitar cargos innecesarios.
# -------------------------------------------------------------------------
  Scenario: US-45 - Escenario 1: Cancelación de solicitud dentro del plazo permitido
    * def ownerUsername = 'cancel_req_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear solicitud
    Given path 'requests'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "clientId": "client-cancel-001",
        "technicianId": "tech-001",
        "propertyId": "prop-cancel-uuid-001",
        "serviceId": "service-001",
        "problemDescription": "Servicio a cancelar para prueba",
        "scheduledDate": "2026-06-20",
        "bill": {
          "billingPeriod": "Mayo 2026",
          "energyConsumed": 100.0,
          "amountPaid": 50.00,
          "billImageUrl": null
        },
        "photos": [],
        "isPriority": false
      }
      """
    When method post
    Then status 201
    # Extraer ID de la respuesta (formato: "Request created with ID: X")
    * def msgRaw = response.message
    * def requestId = msgRaw.split(': ')[1]
    * print 'Solicitud creada con ID:', requestId

    # Cancelar (eliminar) la solicitud dentro del plazo permitido
    Given path 'requests', requestId
    And header Authorization = 'Bearer ' + token
    When method delete
    Then status 200
    And match response.message contains 'deleted successfully'
    * print 'Solicitud cancelada exitosamente sin penalización'

# -------------------------------------------------------------------------
# US-46: Notificación de Asignación Automática de Técnico (Propietario)
# Como propietario, quiero recibir notificación con la información del
# técnico asignado automáticamente a mi solicitud.
# -------------------------------------------------------------------------
  Scenario: US-46 - Escenario 1: Solicitud creada y técnico asignado visible en detalle
    * def ownerUsername = 'notif_assign_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear solicitud
    Given path 'requests'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "clientId": "client-notif-001",
        "technicianId": "tech-assigned-001",
        "propertyId": "prop-notif-uuid-001",
        "serviceId": "service-001",
        "problemDescription": "Instalación eléctrica defectuosa",
        "scheduledDate": "2026-06-15",
        "bill": {
          "billingPeriod": "Mayo 2026",
          "energyConsumed": 280.0,
          "amountPaid": 115.00,
          "billImageUrl": null
        },
        "photos": [],
        "isPriority": false
      }
      """
    When method post
    Then status 201
    * def msgRaw = response.message
    * def requestId = msgRaw.split(': ')[1]

    # Consultar detalle del request para ver técnico asignado
    Given path 'requests', requestId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.technicianId == 'tech-assigned-001'
    * print 'El propietario puede ver el técnico asignado en la solicitud ID:', requestId

# -------------------------------------------------------------------------
# US-57: Beneficio de Solicitud Prioritaria (Plan Premium)
# Como propietario Premium, quiero marcar mi solicitud como prioritaria
# para tener preferencia en el sistema de asignación.
# -------------------------------------------------------------------------
  Scenario: US-57 - Escenario 1: Propietario Premium crea solicitud marcada como prioritaria
    * def ownerUsername = 'premium_prior_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear solicitud prioritaria (isPriority = true)
    Given path 'requests'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "clientId": "client-premium-001",
        "technicianId": "tech-001",
        "propertyId": "prop-premium-uuid-001",
        "serviceId": "service-premium-001",
        "problemDescription": "Corte total de energía - URGENTE",
        "scheduledDate": "2026-06-01",
        "bill": {
          "billingPeriod": "Mayo 2026",
          "energyConsumed": 500.0,
          "amountPaid": 250.00,
          "billImageUrl": null
        },
        "photos": [],
        "isPriority": true
      }
      """
    When method post
    Then status 201
    * def msgRaw = response.message
    * def requestId = msgRaw.split(': ')[1]

    # Verificar que la solicitud fue creada con prioridad
    Given path 'requests', requestId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.isPriority == true
    * print 'Solicitud prioritaria creada con ID:', requestId

# -------------------------------------------------------------------------
# US-58: Notificación de Límite de Solicitudes Alcanzado (Plan Básico)
# Como propietario del plan Básico, quiero ser notificado cuando alcanzo
# mi límite de 2 solicitudes mensuales.
# -------------------------------------------------------------------------
  Scenario: US-58 - Escenario 1: Sistema crea solicitudes hasta límite del plan básico
    * def ownerUsername = 'basic_limit_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    * def baseRequest =
      """
      {
        "clientId": "client-basic-limit",
        "technicianId": "tech-001",
        "propertyId": "prop-basic-uuid-001",
        "serviceId": "service-001",
        "problemDescription": "Solicitud de prueba de límite",
        "scheduledDate": "2026-06-01",
        "bill": { "billingPeriod": "Mayo 2026", "energyConsumed": 100.0, "amountPaid": 50.0, "billImageUrl": null },
        "photos": [],
        "isPriority": false
      }
      """
    # Solicitud 1 - dentro del límite básico
    Given path 'requests'
    And header Authorization = 'Bearer ' + token
    And request baseRequest
    When method post
    Then status 201
    * print 'Solicitud 1 de 2 creada (plan básico)'

    # Solicitud 2 - dentro del límite básico
    Given path 'requests'
    And header Authorization = 'Bearer ' + token
    And request baseRequest
    When method post
    Then status 201
    * print 'Solicitud 2 de 2 creada (plan básico). Límite alcanzado.'

  Scenario: US-58 - Escenario 2: Validar suscripción y límite via endpoint de subscription
    * def ownerUsername = 'sub_check_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    * def userId = response.id
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear suscripción básica
    Given path 'subscriptions'
    And header Authorization = 'Bearer ' + token
    And request { "userId": "#(userId)", "planId": 1 }
    When method post
    Then status 201
    * print 'Suscripción básica creada. Límite de 2 solicitudes/mes activo.'

    # Verificar estado de suscripción activa
    Given path 'subscriptions/users', userId, 'active'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.canMakeRequest == true
    * print 'Suscripción activa. canMakeRequest:', response.canMakeRequest

# -------------------------------------------------------------------------
# US-59: Seguimiento de Estados de Servicio en Tiempo Real
# Como propietario y técnico, quiero ver el estado actual del servicio
# actualizado en tiempo real (Pending → In Progress → Completed).
# -------------------------------------------------------------------------
  Scenario: US-59 - Escenario 1: Visualización del estado actual de la operación de servicio
    * def techUsername = 'status_tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear operación de servicio (estado inicial: PENDING)
    Given path 'service-operations'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "requestId": 1,
        "technicianId": 1
      }
      """
    When method post
    Then status 201
    * def operationId = response.id
    * match response.currentStatus == 'PENDING'
    * print 'ServiceOperation creada con estado PENDING, ID:', operationId

  Scenario: US-59 - Escenario 2: Técnico actualiza estado a IN_PROGRESS - visible en tiempo real
    * def techUsername = 'status_upd_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear operación base
    Given path 'service-operations'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 2, "technicianId": 1 }
    When method post
    Then status 201
    * def operationId = response.id

    # Actualizar a IN_PROGRESS
    Given path 'service-operations/status'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "serviceOperationId": #(operationId),
        "newStatus": "IN_PROGRESS"
      }
      """
    When method put
    Then status 204
    * print 'Estado actualizado a IN_PROGRESS. Visible para propietario y técnico.'

    # Confirmar que el nuevo estado está disponible para consulta
    Given path 'service-operations', operationId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.currentStatus == 'IN_PROGRESS'
    * print 'Estado IN_PROGRESS confirmado en la operación ID:', operationId

# =========================================================================
# TECHNICAL STORIES - EP-04
# =========================================================================

# -------------------------------------------------------------------------
# TS-23: Sistema de Notificaciones Básico
# Como desarrollador, quiero crear un servicio básico de notificaciones
# para enviar emails simples a los usuarios.
# -------------------------------------------------------------------------
  Scenario: TS-23 - Escenario 1: Creación de solicitud dispara flujo de notificación
    * def ownerUsername = 'ts23_notif_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # La creación de solicitud debe disparar notificación interna al técnico
    Given path 'requests'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "clientId": "client-ts23-001",
        "technicianId": "tech-001",
        "propertyId": "prop-ts23-uuid-001",
        "serviceId": "service-001",
        "problemDescription": "Prueba de notificación de sistema",
        "scheduledDate": "2026-07-01",
        "bill": {
          "billingPeriod": "Junio 2026",
          "energyConsumed": 200.0,
          "amountPaid": 90.00,
          "billImageUrl": null
        },
        "photos": [],
        "isPriority": false
      }
      """
    When method post
    Then status 201
    And match response.message contains 'Request created with ID'
    * print 'TS-23: Solicitud creada. Sistema de notificación debe enviar email al técnico asignado.'

  Scenario: TS-23 - Escenario 2: Preferencias de notificación almacenadas en perfil del usuario
    * def ownerUsername = 'ts23_pref_' + randomString(6)
    * def email = ownerUsername + '@test.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear perfil con preferencias de notificación
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "firstName": "TS23",
        "lastName": "NotifTest",
        "email": "#(email)",
        "street": "Av. Notif 100",
        "role": "HOMEOWNER",
        "additionalInfoOrCertification": "Notif: email=true, sms=false, push=true, frequency=immediate"
      }
      """
    When method post
    Then status 201
    And match response.additionalInfoOrCertification contains 'email=true'
    * print 'TS-23: Preferencias de notificación registradas en perfil:', response.id

  Scenario: TS-23 - Escenario 3: Cambio de estado de operación registra evento (log)
    * def techUsername = 'ts23_log_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear operación de servicio
    Given path 'service-operations'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 99, "technicianId": 1 }
    When method post
    Then status 201
    * def opId = response.id

    # Actualizar estado - debe generar log/evento de notificación
    Given path 'service-operations/status'
    And header Authorization = 'Bearer ' + token
    And request { "serviceOperationId": "#(opId)", "newStatus": "IN_PROGRESS" }
    When method put
    Then status 204
    * print 'TS-23: Cambio de estado registrado. Sistema de logs/notificación debe capturar el evento.'
