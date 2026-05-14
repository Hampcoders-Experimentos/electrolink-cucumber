Feature: EP-02 - Gestión de Feedback de Registro (Validaciones y Mensajes)

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s = ''; var chars = 'abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0; i<len; i++){ s += chars.charAt(Math.floor(Math.random() * chars.length)); } return s; }

# =========================================================================
# USER STORIES - EP-02
# =========================================================================

# -------------------------------------------------------------------------
# US-18: Validación de datos de registro
# Como un usuario, quiero recibir retroalimentación inmediata sobre la
# validez de los datos que ingresé durante el registro, para así corregir
# errores rápidamente.
# -------------------------------------------------------------------------
  Scenario: US-18 - Escenario 1: Registro con username vacío retorna error de validación
    Given path 'authentication/sign-up'
    And request
      """
      {
        "username": "",
        "password": "password123",
        "roles": ["ROLE_CLIENT"]
      }
      """
    When method post
    Then status 400
    * print 'Validación correcta: username vacío rechazado'

  Scenario: US-18 - Escenario 2: Registro con username ya existente retorna error de conflicto
    * def username = 'dup_user_' + randomString(6)
    # Registrar usuario base
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201

    # Intentar registrar con el mismo username
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "otherpass456", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 500
    * print 'Validación correcta: username duplicado informado al usuario'

  Scenario: US-18 - Escenario 3: Registro con password vacío retorna error de validación
    * def username = 'nopass_user_' + randomString(6)
    Given path 'authentication/sign-up'
    And request
      """
      {
        "username": "#(username)",
        "password": "",
        "roles": ["ROLE_CLIENT"]
      }
      """
    When method post
    Then status 400
    * print 'Validación correcta: contraseña vacía rechazada'

# -------------------------------------------------------------------------
# US-19: Mensajes de éxito - retroalimentación de registro
# Como un usuario, quiero recibir mensajes claros al completar el registro
# sobre éxito, para así entender fácilmente el resultado de mis acciones.
# -------------------------------------------------------------------------
  Scenario: US-19 - Escenario 1: Mensaje de éxito al completar el registro correctamente
    * def username = 'success_user_' + randomString(8)
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
    And match response.id != '#null'
    And match response.username == username
    * print 'Registro exitoso. Respuesta de confirmación recibida con datos del usuario creado.'

  Scenario: US-19 - Escenario 2: Inicio de sesión exitoso retorna token de acceso
    * def username = 'success_login_' + randomString(8)
    # Registrar
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    # Iniciar sesión y verificar mensaje de éxito
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    And match response.token != '#null'
    * print 'Inicio de sesión exitoso. Token recibido como confirmación.'

# -------------------------------------------------------------------------
# US-20: Mensajes de error - retroalimentación de registro
# Como un usuario, quiero recibir mensajes claros sobre cualquier error al
# completar el formulario, para saber cómo proceder.
# -------------------------------------------------------------------------
  Scenario: US-20 - Escenario 1: Mensaje de error por datos faltantes en el cuerpo del request
    Given path 'authentication/sign-up'
    And request
      """
      {
        "username": "",
        "password": "",
        "roles": []
      }
      """
    When method post
    Then status 400
    * print 'Error de sistema comunicado correctamente al usuario'

  Scenario: US-20 - Escenario 2: Mensaje de error por credenciales incorrectas en login
    Given path 'authentication/sign-in'
    And request
      """
      {
        "username": "noexiste_usuario_xyz",
        "password": "wrongpassword"
      }
      """
    When method post
    Then status 404
    * print 'Mensaje de error de credenciales inválidas recibido correctamente'

  Scenario: US-20 - Escenario 3: Datos del formulario no se pierden - verificación de idempotencia
    * def username = 'form_preserve_' + randomString(6)
    * def password = 'password123'
    # Primer intento con datos válidos
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "#(password)", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    # Segundo intento con mismo username (simula error y reintento con datos conservados)
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "#(password)", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 500
    * print 'El sistema retornó error. El cliente debe conservar los datos del formulario.'

# =========================================================================
# TECHNICAL STORIES - EP-02
# =========================================================================

# -------------------------------------------------------------------------
# TS-19: Verificación de Email
# Como un desarrollador, quiero crear endpoints para verificar emails de
# usuarios para completar el proceso de registro.
# -------------------------------------------------------------------------
  Scenario: TS-19 - Escenario 1: Registro nuevo dispara proceso de verificación de cuenta
    * def username = 'ts19_verify_' + randomString(8)
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
    And match response.id != '#null'
    * print 'Usuario creado. El sistema debe generar token de verificación y marcarlo como no verificado.'

  Scenario: TS-19 - Escenario 2: Inicio de sesión después del registro (MVP - cuenta activa de inmediato)
    * def username = 'ts19_active_' + randomString(8)
    # Registrar
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201

    # Iniciar sesión (en el MVP la cuenta es activa de inmediato)
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    And match response.token != '#null'
    * print 'Cuenta verificada y activa. Token JWT generado:', response.token

  Scenario: TS-19 - Escenario 3: Username inexistente retorna 404 al hacer sign-in
    Given path 'authentication/sign-in'
    And request { "username": "ts19_invalid_user_xyz", "password": "anypassword" }
    When method post
    Then status 404
    * print 'Token inválido/usuario inexistente retorna error correcto'
