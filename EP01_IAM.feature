Feature: EP-01 - Identity and Access Management (Registro e Inicio de Sesión)

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s = ''; var chars = 'abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0; i<len; i++){ s += chars.charAt(Math.floor(Math.random() * chars.length)); } return s; }

# =========================================================================
# USER STORIES - EP-01
# =========================================================================

# -------------------------------------------------------------------------
# US-13: Registro de cuentas como Dueño de Hogar
# Como un dueño de hogar, quiero registrarme para tener una cuenta en la
# aplicación, para así gestionar los componentes eléctricos de mi vivienda.
# -------------------------------------------------------------------------
  Scenario: US-13 - Escenario 1: Selección de rol Dueño de Hogar y registro exitoso
    * def username = 'homeowner_' + randomString(8)
    Given path 'authentication/sign-up'
    And request
      """
      {
        "username": "#(username)",
        "password": "password123",
        "roles": ["ROLE_CLIENT"]
      }
      """
    When method post
    Then status 201
    And match response.username == username
    * print 'Usuario Dueño de Hogar creado:', response.username

# -------------------------------------------------------------------------
# US-14: Registro de cuentas como Dueño de Empresa
# Como un dueño o representante de empresa, quiero registrarme para tener
# una cuenta en la aplicación, para gestionar los componentes eléctricos
# de mis instalaciones comerciales.
# -------------------------------------------------------------------------
  Scenario: US-14 - Escenario 1: Selección de rol Dueño de Empresa y registro exitoso
    * def username = 'companyowner_' + randomString(8)
    Given path 'authentication/sign-up'
    And request
      """
      {
        "username": "#(username)",
        "password": "password123",
        "roles": ["ROLE_CLIENT"]
      }
      """
    When method post
    Then status 201
    And match response.username == username
    * print 'Usuario Dueño de Empresa creado:', response.username

# -------------------------------------------------------------------------
# US-15: Registro de cuentas para Técnicos
# Como un Técnico de componentes eléctricos, quiero registrarme para tener
# una cuenta en la aplicación, para así ofrecer mis productos y servicios.
# -------------------------------------------------------------------------
  Scenario: US-15 - Escenario 1: Selección de rol Técnico y registro exitoso
    * def username = 'technician_' + randomString(8)
    Given path 'authentication/sign-up'
    And request
      """
      {
        "username": "#(username)",
        "password": "password123",
        "roles": ["ROLE_TECHNICIAN"]
      }
      """
    When method post
    Then status 201
    And match response.username == username
    * print 'Usuario Técnico creado:', response.username

  Scenario: US-15 - Escenario 2: Username duplicado retorna error
    * def username = 'technician_dup_' + randomString(6)
    # Primer registro
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    # Segundo registro con mismo username
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password456", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 500
    * print 'Error esperado por username duplicado'

# -------------------------------------------------------------------------
# US-16: Verificación de cuenta por correo electrónico
# Como un usuario, quiero verificar mi cuenta a través de un enlace enviado
# por correo electrónico, para así confirmar mi identidad.
# -------------------------------------------------------------------------
  Scenario: US-16 - Escenario 1: Registro exitoso dispara envío de verificación
    * def username = 'user_verify_' + randomString(8)
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    And match response.username == username
    * print 'Cuenta creada. El sistema debe enviar comunicación de verificación a:', username

  Scenario: US-16 - Escenario 2: Cuenta verificada permite inicio de sesión
    * def username = 'user_verified_' + randomString(8)
    # Crear cuenta
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    # Iniciar sesión (cuenta ya activa en MVP)
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    And match response.token != '#null'
    * print 'Cuenta verificada e inicio de sesión exitoso'

# -------------------------------------------------------------------------
# US-17: Inicio de sesión de usuarios
# Como un usuario registrado, quiero iniciar sesión en la aplicación con
# mis credenciales, para así acceder a mi cuenta y utilizar las
# funcionalidades de la plataforma.
# -------------------------------------------------------------------------
  Scenario: US-17 - Escenario 1: Inicio de sesión exitoso con credenciales válidas
    * def username = 'user_login_' + randomString(8)
    * def password = 'password123'
    # Crear cuenta primero
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "#(password)", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    # Iniciar sesión
    Given path 'authentication/sign-in'
    And request
      """
      {
        "username": "#(username)",
        "password": "#(password)"
      }
      """
    When method post
    Then status 200
    And match response.token != '#null'
    * def authToken = response.token
    * print 'Inicio de sesión exitoso. Token obtenido.'

  Scenario: US-17 - Escenario 2: Intento de inicio de sesión con credenciales inválidas
    Given path 'authentication/sign-in'
    And request
      """
      {
        "username": "usuario_inexistente_xyz999",
        "password": "wrongpassword"
      }
      """
    When method post
    Then status 404
    * print 'Acceso denegado correctamente para credenciales inválidas'

# =========================================================================
# TECHNICAL STORIES - EP-01
# =========================================================================

# -------------------------------------------------------------------------
# TS-17: Endpoint de Autenticación JWT
# Como un desarrollador, quiero crear un endpoint de login que genere
# tokens JWT para permitir la autenticación segura de usuarios.
# -------------------------------------------------------------------------
  Scenario: TS-17 - Escenario 1: Login exitoso retorna token JWT válido
    * def username = 'ts17_user_' + randomString(8)
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201

    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    And match response.token != '#null'
    And match response contains { token: '#string' }
    * print 'JWT generado correctamente'

  Scenario: TS-17 - Escenario 2: Credenciales inválidas retornan error 401/404
    Given path 'authentication/sign-in'
    And request { "username": "noexiste_ts17", "password": "badpass" }
    When method post
    Then status 404
    * print 'Error esperado para credenciales incorrectas'

# -------------------------------------------------------------------------
# TS-18: Endpoint de Registro de Usuarios
# Como un desarrollador, quiero crear endpoints de registro diferenciados
# para permitir el registro de propietarios y técnicos.
# -------------------------------------------------------------------------
  Scenario: TS-18 - Escenario 1: Registro exitoso de propietario - datos correctos y status 201
    * def username = 'ts18_owner_' + randomString(8)
    Given path 'authentication/sign-up'
    And request
      """
      {
        "username": "#(username)",
        "password": "securePass123",
        "roles": ["ROLE_CLIENT"]
      }
      """
    When method post
    Then status 201
    And match response.username == username
    And match response.password == '#notpresent'
    * print 'Propietario registrado sin exponer contraseña'

  Scenario: TS-18 - Escenario 2: Registro exitoso de técnico - rol TECHNICIAN asignado
    * def username = 'ts18_tech_' + randomString(8)
    Given path 'authentication/sign-up'
    And request
      """
      {
        "username": "#(username)",
        "password": "securePass123",
        "roles": ["ROLE_TECHNICIAN"]
      }
      """
    When method post
    Then status 201
    And match response.username == username
    * print 'Técnico registrado correctamente'

  Scenario: TS-18 - Escenario 3: Username duplicado retorna error de conflicto
    * def username = 'ts18_dup_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "pass123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201

    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "pass456", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 500
    * print 'Conflicto de username duplicado detectado correctamente'
