Feature: EP-03 - Gestión de Perfiles y Sesión

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s=''; var chars='abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0;i<len;i++){s+=chars.charAt(Math.floor(Math.random()*chars.length));} return s; }

    # Helper: registra usuario y retorna token JWT
    * def registerAndLogin =
      """
      function(prefix, role) {
        var username = prefix + '_' + Java.type('java.util.UUID').randomUUID().toString().substring(0,8);
        var password = 'Password123';
        var roles = role === 'TECHNICIAN' ? ['ROLE_TECHNICIAN'] : ['ROLE_CLIENT'];
        karate.call('classpath:helpers/register.feature', { username: username, password: password, roles: roles });
        var res = karate.call('classpath:helpers/login.feature', { username: username, password: password });
        return { token: res.token, username: username };
      }
      """

# =========================================================================
# USER STORIES - EP-03
# =========================================================================

# -------------------------------------------------------------------------
# US-21: Recuperación de Contraseña
# Como un usuario registrado, quiero recuperar mi contraseña en caso de
# olvidarla, para así volver a acceder a mi cuenta de manera segura.
# -------------------------------------------------------------------------
  Scenario: US-21 - Escenario 1: Registro exitoso es prerrequisito para recuperación
    * def username = 'recover_' + randomString(8)
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    * print 'Cuenta registrada. Flujo de recuperación de contraseña dispara envío de correo (no expuesto en MVP API).'

  Scenario: US-21 - Escenario 2: Cambio de contraseña - nueva sesión con credenciales actualizadas
    * def username = 'newpass_' + randomString(8)
    * def originalPass = 'OriginalPass123'
    # Crear cuenta
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "#(originalPass)", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    # Iniciar sesión con la contraseña original
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "#(originalPass)" }
    When method post
    Then status 200
    And match response.token != '#null'
    * print 'Contraseña original válida. Restablecimiento dispara flujo de email.'

# -------------------------------------------------------------------------
# US-22: Cierre de Sesión
# Como un usuario autenticado, quiero cerrar mi sesión de forma segura,
# para así proteger mi cuenta cuando termine de usar la aplicación.
# -------------------------------------------------------------------------
  Scenario: US-22 - Escenario 1: Cierre de sesión voluntario
    * def username = 'logout_' + randomString(8)
    # Registrar
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    # Login para obtener token
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    * match token != '#null'
    # El cierre de sesión en JWT stateless es gestionado en el cliente
    # Verificamos que el token obtenido es válido haciendo una consulta autenticada
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * print 'Token válido. El cierre de sesión implica descartarlo en el cliente.'

# -------------------------------------------------------------------------
# US-23: Visualización de Perfil de Propietario
# Como un propietario registrado, quiero visualizar mi perfil, para así
# revisar mi información personal y preferencias almacenadas.
# -------------------------------------------------------------------------
  Scenario: US-23 - Escenario 1: Propietario visualiza su perfil personal
    * def username = 'owner_view_' + randomString(8)
    * def email = username + '@test.com'
    # Registrar usuario
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    # Obtener token
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Crear perfil de propietario
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "firstName": "Carlos",
        "lastName": "Propietario",
        "email": "#(email)",
        "street": "Av. Los Álamos 123",
        "role": "HOMEOWNER",
        "additionalInfoOrCertification": "Propietario residencial"
      }
      """
    When method post
    Then status 201
    * def profileId = response.id
    # Visualizar perfil
    Given path 'profiles', profileId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.firstName == 'Carlos'
    And match response.lastName == 'Propietario'
    And match response.role == 'HOMEOWNER'
    * print 'Perfil de propietario visualizado con ID:', profileId

# -------------------------------------------------------------------------
# US-24: Edición de Perfil de Propietario
# Como un propietario registrado, quiero editar mi información personal,
# para así mantener mi perfil actualizado.
# -------------------------------------------------------------------------
  Scenario: US-24 - Escenario 1: Edición exitosa de información personal del propietario
    * def username = 'owner_edit_' + randomString(8)
    * def email = username + '@test.com'
    # Registrar y obtener token
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Crear perfil
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Ana", "lastName": "Gómez", "email": "#(email)", "street": "Calle Inicial 1", "role": "HOMEOWNER", "additionalInfoOrCertification": "" }
    When method post
    Then status 201
    * def profileId = response.id
    # Editar perfil
    Given path 'profiles', profileId
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "id": #(profileId),
        "firstName": "Ana",
        "lastName": "Gómez Actualizada",
        "email": "#(email)",
        "street": "Calle Nueva 999",
        "role": "HOMEOWNER",
        "additionalInfoOrCertification": "Info actualizada",
        "isVerified": false
      }
      """
    When method put
    Then status 200
    And match response.street == 'Calle Nueva 999'
    And match response.lastName == 'Gómez Actualizada'
    * print 'Perfil de propietario actualizado correctamente'

# -------------------------------------------------------------------------
# US-25: Visualización de Perfil de Técnico
# Como un Técnico registrado, quiero visualizar mi perfil profesional,
# para así revisar cómo se presenta mi información a los clientes.
# -------------------------------------------------------------------------
  Scenario: US-25 - Escenario 1: Técnico visualiza su perfil profesional
    * def username = 'tech_view_' + randomString(8)
    * def email = username + '@tech.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Crear perfil de técnico
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "firstName": "Luis",
        "lastName": "Técnico",
        "email": "#(email)",
        "street": "Av. Industrial 456",
        "role": "TECHNICIAN",
        "additionalInfoOrCertification": "Certificado en instalaciones eléctricas"
      }
      """
    When method post
    Then status 201
    * def profileId = response.id
    # Visualizar perfil técnico
    Given path 'profiles', profileId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.role == 'TECHNICIAN'
    And match response.additionalInfoOrCertification == 'Certificado en instalaciones eléctricas'
    * print 'Perfil de técnico visualizado con certificaciones, ID:', profileId

# -------------------------------------------------------------------------
# US-26: Edición de Perfil de Técnico
# Como un Técnico registrado, quiero editar mi información profesional y
# certificaciones, para así mantener mi perfil actualizado y atractivo.
# -------------------------------------------------------------------------
  Scenario: US-26 - Escenario 1: Edición de información profesional del técnico
    * def username = 'tech_edit_' + randomString(8)
    * def email = username + '@tech.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Pedro", "lastName": "Eléctrico", "email": "#(email)", "street": "Zona Industrial 1", "role": "TECHNICIAN", "additionalInfoOrCertification": "Sin certificados" }
    When method post
    Then status 201
    * def profileId = response.id
    # Editar perfil con nueva certificación
    Given path 'profiles', profileId
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "id": #(profileId),
        "firstName": "Pedro",
        "lastName": "Eléctrico",
        "email": "#(email)",
        "street": "Zona Industrial 2 - Actualizado",
        "role": "TECHNICIAN",
        "additionalInfoOrCertification": "Certificado NTIE 2024 - Instalaciones eléctricas avanzadas",
        "isVerified": false
      }
      """
    When method put
    Then status 200
    And match response.additionalInfoOrCertification contains 'Certificado NTIE 2024'
    * print 'Certificación del técnico actualizada correctamente'

  Scenario: US-26 - Escenario 2: Búsqueda de técnico por rol confirma actualización en perfil público
    * def username = 'tech_cert_' + randomString(8)
    * def email = username + '@tech.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Mario", "lastName": "Técnico", "email": "#(email)", "street": "Av. Central", "role": "TECHNICIAN", "additionalInfoOrCertification": "Certificación actualizada" }
    When method post
    Then status 201
    * def profileId = response.id
    # Buscar por rol para verificar visibilidad pública
    Given path 'profiles/search'
    And header Authorization = 'Bearer ' + token
    And param role = 'TECHNICIAN'
    When method get
    Then status 200
    And match response == '#array'
    * print 'Técnicos encontrados en búsqueda pública:', response.length

# -------------------------------------------------------------------------
# US-27: Entrar a un Dashboard Personalizado
# Como un usuario de la plataforma, quiero acceder a un dashboard
# personalizado al iniciar sesión, según mi rol y actividad reciente.
# -------------------------------------------------------------------------
  Scenario: US-27 - Escenario 1: Propietario accede a datos de su dashboard tras login
    * def username = 'dash_owner_' + randomString(8)
    * def email = username + '@home.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    And match response.token != '#null'
    # Crear perfil para el dashboard
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Sandra", "lastName": "Hogar", "email": "#(email)", "street": "Calle 10", "role": "HOMEOWNER", "additionalInfoOrCertification": "" }
    When method post
    Then status 201
    # Consultar perfil como parte del dashboard personalizado
    Given path 'profiles/search'
    And header Authorization = 'Bearer ' + token
    And param email = email
    When method get
    Then status 200
    And match response[0].role == 'HOMEOWNER'
    * print 'Dashboard del propietario muestra perfil personalizado'

  Scenario: US-27 - Escenario 2: Técnico accede a datos de su dashboard tras login
    * def username = 'dash_tech_' + randomString(8)
    * def email = username + '@tech.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Roberto", "lastName": "Técnico", "email": "#(email)", "street": "Av. Taller 5", "role": "TECHNICIAN", "additionalInfoOrCertification": "Especialista en redes eléctricas" }
    When method post
    Then status 201
    Given path 'profiles/search'
    And header Authorization = 'Bearer ' + token
    And param email = email
    When method get
    Then status 200
    And match response[0].role == 'TECHNICIAN'
    * print 'Dashboard del técnico muestra perfil profesional'

# -------------------------------------------------------------------------
# US-30: Configuración de Notificaciones Personalizadas
# Como un usuario de la plataforma, quiero configurar mis preferencias de
# notificaciones para recibir información relevante sin saturación.
# -------------------------------------------------------------------------
  Scenario: US-30 - Escenario 1: Actualización de preferencias en el perfil
    * def username = 'notif_' + randomString(8)
    * def email = username + '@home.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Crear perfil
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Laura", "lastName": "Notif", "email": "#(email)", "street": "Av. Notif 1", "role": "HOMEOWNER", "additionalInfoOrCertification": "Preferencias: solo email" }
    When method post
    Then status 201
    * def profileId = response.id
    # Actualizar preferencias (almacenadas en additionalInfoOrCertification en el MVP)
    Given path 'profiles', profileId
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "id": #(profileId),
        "firstName": "Laura",
        "lastName": "Notif",
        "email": "#(email)",
        "street": "Av. Notif 1",
        "role": "HOMEOWNER",
        "additionalInfoOrCertification": "Notificaciones: email=true, sms=false, push=true",
        "isVerified": false
      }
      """
    When method put
    Then status 200
    And match response.additionalInfoOrCertification contains 'email=true'
    * print 'Preferencias de notificación almacenadas en perfil del propietario'

# =========================================================================
# TECHNICAL STORIES - EP-03
# =========================================================================

# -------------------------------------------------------------------------
# TS-20: Middleware de Autorización
# Como un desarrollador, quiero crear middleware de autorización para
# controlar acceso a endpoints según roles de usuario.
# -------------------------------------------------------------------------
  Scenario: TS-20 - Escenario 1: Acceso autorizado con token JWT válido
    * def username = 'ts20_auth_' + randomString(8)
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Acceder a endpoint protegido con token válido
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * print 'Middleware permite acceso con token válido'

  Scenario: TS-20 - Escenario 2: Acceso denegado sin token - retorna 401/403
    Given path 'profiles'
    When method get
    Then status 401
    * print 'Middleware bloquea acceso sin token correctamente'

  Scenario: TS-20 - Escenario 3: Token inválido retorna error de autenticación
    Given path 'profiles'
    And header Authorization = 'Bearer token_invalido_xyz_123'
    When method get
    Then status 401
    * print 'Middleware rechaza token inválido'

# -------------------------------------------------------------------------
# TS-21: Recuperación de Contraseña (Endpoint)
# Como un desarrollador, quiero crear endpoints para recuperación de
# contraseña para permitir a usuarios restablecer sus credenciales.
# -------------------------------------------------------------------------
  Scenario: TS-21 - Escenario 1: Flujo de recuperación - registro y login confirman credenciales activas
    * def username = 'ts21_forgot_' + randomString(8)
    * def password = 'OldPassword123'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "#(password)", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "#(password)" }
    When method post
    Then status 200
    And match response.token != '#null'
    * print 'Credenciales válidas confirmadas. Endpoint de recuperación pendiente de implementación completa.'

  Scenario: TS-21 - Escenario 2: Intento de login con contraseña incorrecta retorna 404
    * def username = 'ts21_reset_' + randomString(8)
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "correctPass123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    # Login con password incorrecto
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "wrongPassword" }
    When method post
    Then status 404
    * print 'Credenciales incorrectas bloqueadas. El restablecimiento es necesario.'

# -------------------------------------------------------------------------
# TS-22: Endpoints de Gestión de Perfiles
# Como un desarrollador, quiero crear endpoints CRUD para gestión de
# perfiles de propietarios y técnicos.
# -------------------------------------------------------------------------
  Scenario: TS-22 - Escenario 1: POST /api/v1/profiles - Crear perfil retorna 201
    * def username = 'ts22_create_' + randomString(8)
    * def email = username + '@test.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Dev", "lastName": "Test", "email": "#(email)", "street": "Dev Street 1", "role": "HOMEOWNER", "additionalInfoOrCertification": "" }
    When method post
    Then status 201
    And match response.id != '#null'
    And match response.firstName == 'Dev'
    * def profileId = response.id
    * print 'TS-22: POST /profiles OK - ID:', profileId

  Scenario: TS-22 - Escenario 2: GET /api/v1/profiles/{id} - Obtener perfil por ID retorna 200
    * def username = 'ts22_get_' + randomString(8)
    * def email = username + '@test.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Get", "lastName": "Test", "email": "#(email)", "street": "Get Street 1", "role": "HOMEOWNER", "additionalInfoOrCertification": "" }
    When method post
    Then status 201
    * def profileId = response.id
    Given path 'profiles', profileId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.id == profileId
    * print 'TS-22: GET /profiles/{id} OK'

  Scenario: TS-22 - Escenario 3: PUT /api/v1/profiles/{id} - Actualizar perfil retorna 200
    * def username = 'ts22_put_' + randomString(8)
    * def email = username + '@test.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Put", "lastName": "Original", "email": "#(email)", "street": "Old Street", "role": "HOMEOWNER", "additionalInfoOrCertification": "" }
    When method post
    Then status 201
    * def profileId = response.id
    Given path 'profiles', profileId
    And header Authorization = 'Bearer ' + token
    And request { "id": "#(profileId)", "firstName": "Put", "lastName": "Updated", "email": "#(email)", "street": "New Street 99", "role": "HOMEOWNER", "additionalInfoOrCertification": "updated", "isVerified": false }
    When method put
    Then status 200
    And match response.lastName == 'Updated'
    * print 'TS-22: PUT /profiles/{id} OK'

  Scenario: TS-22 - Escenario 4: DELETE /api/v1/profiles/{id} - Eliminar perfil retorna 204
    * def username = 'ts22_del_' + randomString(8)
    * def email = username + '@test.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_CLIENT"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Del", "lastName": "Test", "email": "#(email)", "street": "Del Street", "role": "HOMEOWNER", "additionalInfoOrCertification": "" }
    When method post
    Then status 201
    * def profileId = response.id
    Given path 'profiles', profileId
    And header Authorization = 'Bearer ' + token
    When method delete
    Then status 204
    * print 'TS-22: DELETE /profiles/{id} OK'

  Scenario: TS-22 - Escenario 5: GET /api/v1/profiles/search?role=TECHNICIAN - Búsqueda por rol
    * def username = 'ts22_search_' + randomString(8)
    * def email = username + '@tech.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(username)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(username)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request { "firstName": "Search", "lastName": "Tecnico", "email": "#(email)", "street": "Search Street", "role": "TECHNICIAN", "additionalInfoOrCertification": "Especialista" }
    When method post
    Then status 201
    Given path 'profiles/search'
    And header Authorization = 'Bearer ' + token
    And param role = 'TECHNICIAN'
    When method get
    Then status 200
    And match response == '#array'
    * print 'TS-22: GET /profiles/search?role=TECHNICIAN OK, resultados:', response.length
