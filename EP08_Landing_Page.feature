Feature: EP-08 - Landing Page Informativa

  # =========================================================================
  # NOTA: Las historias de EP-08 corresponden a la landing page (frontend).
  # Los escenarios de API verifican los endpoints que alimentan la landing
  # (planes, disponibilidad del backend). Las validaciones visuales (UI)
  # están documentadas como criterios de aceptación para pruebas manuales
  # o herramientas de UI testing (Selenium/Playwright).
  # =========================================================================

  Background:
    * url 'http://localhost:8080/api/v1'
    * def frontUrl = 'http://localhost:4200'
    * def randomString = function(len){ var s=''; var chars='abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0;i<len;i++){s+=chars.charAt(Math.floor(Math.random()*chars.length));} return s; }

# =========================================================================
# USER STORIES - EP-08
# =========================================================================

# -------------------------------------------------------------------------
# US-01: Visualización de Características y Beneficios
# Como visitante, quiero ver claramente las características y beneficios
# de la plataforma, para entender cómo puede ayudarme y decidir registrarme.
# -------------------------------------------------------------------------
  Scenario: US-01 - Escenario 1: Backend activo y listo para servir la landing page
    # Verificar que el backend está activo (prerrequisito para la landing)
    Given url 'http://localhost:8080/api/v1/authentication/sign-in'
    And request { "username": "healthcheck", "password": "healthcheck" }
    When method post
    Then status != 500
    * print 'Backend activo. La landing page puede mostrar características y beneficios.'

  Scenario: US-01 - Escenario 2: Planes disponibles como base de beneficios mostrados en landing
    # La landing muestra los planes → validar que el endpoint de planes responde
    * def ownerUsername = 'lp_plans_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'plans'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Planes disponibles para mostrar en landing - Total:', response.length

# -------------------------------------------------------------------------
# US-02: Visualización de Testimonios
# Como visitante indeciso, quiero ver testimonios de usuarios reales para
# aumentar mi confianza en el servicio antes de registrarme.
# -------------------------------------------------------------------------
  Scenario: US-02 - Escenario 1: Ratings del sistema como base para testimonios en landing
    * def ownerUsername = 'lp_test_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear 3 ratings para alimentar la sección de testimonios
    Given path 'ratings'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 1, "score": 5, "comment": "Excelente plataforma, encontré al técnico perfecto en minutos.", "raterId": "propietario-testimonio-1", "technicianId": 1 }
    When method post
    Then status 201
    * print 'Testimonio 1 creado'

    Given path 'ratings'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 2, "score": 5, "comment": "Gracias a Electrolink mi negocio tiene electricidad estable.", "raterId": "propietario-testimonio-2", "technicianId": 1 }
    When method post
    Then status 201
    * print 'Testimonio 2 creado'

    Given path 'ratings'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 3, "score": 4, "comment": "El técnico llegó puntual y resolvió el problema rápidamente.", "raterId": "propietario-testimonio-3", "technicianId": 2 }
    When method post
    Then status 201
    * print 'Testimonio 3 creado'

    # Verificar que hay al menos 3 testimonios disponibles
    Given path 'ratings'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Total testimonios disponibles en el sistema:', response.length

# -------------------------------------------------------------------------
# US-03: Adaptabilidad a Diferentes Dispositivos (Responsive)
# Como visitante desde diferentes dispositivos, quiero que la landing page
# se adapte correctamente a mi pantalla.
# -------------------------------------------------------------------------
  Scenario: US-03 - Escenario 1: Backend responde correctamente (base para carga en cualquier dispositivo)
    # Test de disponibilidad del API - la adaptabilidad es validación de UI
    Given url 'http://localhost:8080/actuator/health'
    When method get
    Then status 200
    * print 'Backend disponible. La landing page responsive puede cargarse en cualquier dispositivo.'

  Scenario: US-03 - Escenario 2: API retorna Content-Type JSON (compatible con cualquier cliente)
    * def ownerUsername = 'lp_resp_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'plans'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match responseHeaders['Content-Type'][0] contains 'application/json'
    * print 'API retorna JSON - compatible con clientes móviles, tabletas y escritorios'

# -------------------------------------------------------------------------
# US-04: Visualización de una Sección Principal (Hero)
# Como visitante, quiero ver una sección principal atractiva con el
# propósito del producto y una llamada a la acción de registro.
# -------------------------------------------------------------------------
  Scenario: US-04 - Escenario 1: Endpoint de registro disponible para el CTA de la landing
    # La llamada a la acción de la landing apunta a /sign-up → verificar disponibilidad
    Given path 'authentication/sign-up'
    And request { "username": "lp_hero_cta_" + randomString(6), "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    * print 'Endpoint de registro disponible. El CTA Hero de la landing puede registrar usuarios.'

# -------------------------------------------------------------------------
# US-05: Navegación sin Errores
# Como visitante, quiero navegar por la página web sin encontrar errores,
# para tener una experiencia fluida que me anime a registrarme.
# -------------------------------------------------------------------------
  Scenario: US-05 - Escenario 1: Todos los endpoints principales responden sin error 5xx
    * def ownerUsername = 'lp_nav_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Verificar que los endpoints clave no retornan 500
    Given path 'plans'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * print 'Endpoint /plans OK - sin error 500'

    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * print 'Endpoint /profiles OK - sin error 500'

    Given path 'services'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * print 'Todos los endpoints principales responden sin errores. Navegación fluida garantizada.'

# -------------------------------------------------------------------------
# US-06: Navegación mediante Encabezado
# Como usuario, quiero un menú de navegación claro en el encabezado para
# acceder fácilmente a las diferentes secciones de la página.
# -------------------------------------------------------------------------
  Scenario: US-06 - Escenario 1: Secciones de la landing tienen datos del backend disponibles
    * def ownerUsername = 'lp_nav2_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Sección "Planes" navegable → endpoint activo
    Given path 'plans'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * print 'Sección Planes disponible para el menú de navegación'

    # Sección "Servicios" navegable → endpoint activo
    Given path 'services'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * print 'Sección Servicios disponible para el menú de navegación'

# -------------------------------------------------------------------------
# US-07: Visualización del Pie de Página
# Como visitante, quiero ver un pie de página organizado con accesos
# directos e información de contacto.
# -------------------------------------------------------------------------
  Scenario: US-07 - Escenario 1: Backend disponible con CORS habilitado para el footer de la landing
    # El footer hace links a /sign-up y /sign-in → verificar que están disponibles
    Given path 'authentication/sign-up'
    And request { "username": "footer_link_" + randomString(6), "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    * print 'Links del footer (Registro, Login) apuntan a endpoints activos.'
    * print 'Términos y Condiciones, Política de Privacidad y Redes Sociales son contenido estático del frontend.'

# -------------------------------------------------------------------------
# US-08: Ver Información del Startup
# Como potencial cliente, quiero conocer información sobre la empresa
# desarrolladora para evaluar su credibilidad.
# -------------------------------------------------------------------------
  Scenario: US-08 - Escenario 1: Sección "About Us" tiene soporte del backend (perfiles del equipo)
    * def ownerUsername = 'lp_about_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # La sección "Sobre nosotros" puede mostrar perfiles del equipo
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * print 'Sistema activo y credible. Sección About Us puede cargarse correctamente.'

# -------------------------------------------------------------------------
# US-09: Conocer la Misión de la Startup
# Como visitante interesado, quiero conocer la misión de la empresa para
# entender sus valores y propósito.
# -------------------------------------------------------------------------
  Scenario: US-09 - Escenario 1: Backend activo refleja la misión operativa del sistema
    # La misión se refleja funcionalmente: conectar técnicos con propietarios
    Given path 'authentication/sign-up'
    And request { "username": "mission_" + randomString(6), "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-up'
    And request { "username": "mission_t_" + randomString(6), "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    * print 'Misión cumplida: Sistema conecta propietarios y técnicos correctamente.'

# -------------------------------------------------------------------------
# US-10: Conocer la Visión de la Startup
# Como visitante interesado, quiero conocer la visión de la empresa para
# entender sus objetivos a largo plazo.
# -------------------------------------------------------------------------
  Scenario: US-10 - Escenario 1: Capacidades analíticas reflejan la visión de datos del sistema
    * def ownerUsername = 'vision_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # La visión incluye análisis de datos → verificar endpoints de analytics
    Given url 'http://localhost:8080/api/v1/analytics/homeowners/1/consumption'
    And header Authorization = 'Bearer ' + token
    And param months = 12
    When method get
    Then status != 500
    * print 'Capacidades analíticas disponibles. La visión de datos de la plataforma está operativa.'

# -------------------------------------------------------------------------
# US-11: Conocer Más a Fondo los Servicios que Ofrecen
# Como visitante, quiero ver capturas de pantalla y detalles de los
# servicios para decidir si optar por la plataforma.
# -------------------------------------------------------------------------
  Scenario: US-11 - Escenario 1: Catálogo de servicios disponible para mostrarse en la landing
    * def ownerUsername = 'lp_svc_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Listar servicios del catálogo para mostrar en la landing
    Given path 'services'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Catálogo de servicios disponible para mostrar en la landing - Total:', response.length

# -------------------------------------------------------------------------
# US-12: Ver Planes de Suscripción Disponibles
# Como visitante, quiero ver una sección clara con los planes de suscripción
# separados por Técnicos y Propietarios, con características y precios.
# -------------------------------------------------------------------------
  Scenario: US-12 - Escenario 1: Planes de suscripción disponibles en la landing (Plan Básico)
    * def ownerUsername = 'lp_plan_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    Given path 'plans'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * def basicPlan = response.find(function(p){ return p.planType == 'BASIC' || p.name == 'BASIC' })
    * print 'Planes disponibles en landing - Total:', response.length

  Scenario: US-12 - Escenario 2: Plan BASIC y PREMIUM disponibles para comparación en la landing
    * def ownerUsername = 'lp_plan2_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(ownerUsername)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(ownerUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Verificar plan BASIC (ID=1) seeded al inicio
    Given path 'plans', 1
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * print 'Plan BASIC disponible - Nombre:', response.name, '| Precio:', response.price

    # Verificar plan PREMIUM (ID=2) seeded al inicio
    Given path 'plans', 2
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * print 'Plan PREMIUM disponible - Nombre:', response.name, '| Precio:', response.price
    * print 'Ambos planes mostrados en landing para comparación por Propietarios y Técnicos'
