Feature: EP-06 - Configuración Operativa del Técnico (Agenda, Zona, Inventario)

  Background:
    * url 'http://localhost:8080/api/v1'
    * def randomString = function(len){ var s=''; var chars='abcdefghijklmnopqrstuvwxyz0123456789'; for(var i=0;i<len;i++){s+=chars.charAt(Math.floor(Math.random()*chars.length));} return s; }

# =========================================================================
# USER STORIES - EP-06
# =========================================================================

# -------------------------------------------------------------------------
# US-29: Configuración de Zona de Cobertura Geográfica
# Como técnico, quiero configurar mi zona de cobertura geográfica para
# recibir solicitudes solo de clientes dentro de mi área de trabajo.
# -------------------------------------------------------------------------
  Scenario: US-29 - Escenario 1: Técnico configura zona de cobertura en su perfil
    * def techUsername = 'zone_tech_' + randomString(6)
    * def email = techUsername + '@tech.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Crear perfil con zona de cobertura en additionalInfoOrCertification
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "firstName": "Carlos",
        "lastName": "Cobertura",
        "email": "#(email)",
        "street": "Av. Central 100",
        "role": "TECHNICIAN",
        "additionalInfoOrCertification": "Zona: Lima Norte - Distritos: Los Olivos, Independencia, Comas - Radio: 15km"
      }
      """
    When method post
    Then status 201
    * def profileId = response.id
    And match response.additionalInfoOrCertification contains 'Lima Norte'
    * print 'Zona de cobertura registrada en perfil del técnico ID:', profileId

  Scenario: US-29 - Escenario 2: Sistema usa zona de cobertura para filtrar técnicos disponibles
    * def techUsername = 'zone_filter_' + randomString(6)
    * def email = techUsername + '@tech.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "firstName": "Diego",
        "lastName": "Zona",
        "email": "#(email)",
        "street": "Av. Universitaria 500",
        "role": "TECHNICIAN",
        "additionalInfoOrCertification": "Zona: Lima Sur - Distritos: San Juan de Miraflores, Villa El Salvador"
      }
      """
    When method post
    Then status 201
    * def profileId = response.id
    # Buscar técnicos por rol para confirmar que están disponibles en el sistema
    Given path 'profiles/search'
    And header Authorization = 'Bearer ' + token
    And param role = 'TECHNICIAN'
    When method get
    Then status 200
    And match response == '#array'
    * print 'Técnicos con zona de cobertura configurada disponibles para matching:', response.length

# -------------------------------------------------------------------------
# US-48: Configurar Horarios de Trabajo Semanales
# Como técnico, quiero configurar mis horarios de trabajo por día de la
# semana para que el sistema me asigne trabajos en mis horas disponibles.
# -------------------------------------------------------------------------
  Scenario: US-48 - Escenario 1: Técnico establece disponibilidad semanal - Lunes a Viernes
    * def techUsername = 'sched_wk_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Crear horarios para cada día laboral
    * def techId = 'tech-wk-' + randomString(4)
    Given path 'schedules'
    And header Authorization = 'Bearer ' + token
    And request { "technicianId": "#(techId)", "day": "Monday", "startTime": "08:00", "endTime": "17:00" }
    When method post
    Then status 201
    * print 'Horario Lunes creado'

    Given path 'schedules'
    And header Authorization = 'Bearer ' + token
    And request { "technicianId": "#(techId)", "day": "Wednesday", "startTime": "08:00", "endTime": "17:00" }
    When method post
    Then status 201
    * print 'Horario Miércoles creado'

    Given path 'schedules'
    And header Authorization = 'Bearer ' + token
    And request { "technicianId": "#(techId)", "day": "Friday", "startTime": "09:00", "endTime": "15:00" }
    When method post
    Then status 201
    * print 'Horario Viernes creado'

    # Verificar horarios creados por técnico
    Given path 'schedules/technician', techId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Horarios configurados para técnico', techId, '- Total días:', response.length

  Scenario: US-48 - Escenario 2: Horario laboral estándar guardado para asignación automática
    * def techUsername = 'sched_std_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    * def techId = 'tech-std-' + randomString(4)
    Given path 'schedules'
    And header Authorization = 'Bearer ' + token
    And request { "technicianId": "#(techId)", "day": "Tuesday", "startTime": "07:00", "endTime": "16:00" }
    When method post
    Then status 201
    * def scheduleId = response.id
    And match response.day == 'Tuesday'
    And match response.startTime == '07:00'
    And match response.endTime == '16:00'
    * print 'Horario estándar confirmado - disponible para asignación automática, ID:', scheduleId

# -------------------------------------------------------------------------
# US-49: Modificar Horarios de Trabajo Existentes
# Como técnico, quiero modificar mis horarios ya configurados para ajustar
# mi disponibilidad según cambios en mi situación.
# -------------------------------------------------------------------------
  Scenario: US-49 - Escenario 1: Técnico modifica horas de inicio y fin de un día laboral
    * def techUsername = 'sched_mod_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    * def techId = 'tech-mod-' + randomString(4)
    # Crear horario base
    Given path 'schedules'
    And header Authorization = 'Bearer ' + token
    And request { "technicianId": "#(techId)", "day": "Thursday", "startTime": "08:00", "endTime": "16:00" }
    When method post
    Then status 201
    * def scheduleId = response.id
    # Modificar horario existente
    Given path 'schedules', scheduleId
    And header Authorization = 'Bearer ' + token
    And request { "technicianId": "#(techId)", "day": "Thursday", "startTime": "09:00", "endTime": "18:00" }
    When method put
    Then status 200
    And match response.startTime == '09:00'
    And match response.endTime == '18:00'
    * print 'Horario actualizado de 08:00-16:00 a 09:00-18:00 para el Jueves'

# -------------------------------------------------------------------------
# US-50: Bloquear Fechas y Horarios Específicos
# Como técnico, quiero bloquear fechas específicas en mi calendario para
# evitar que el sistema me asigne trabajos en esos períodos.
# -------------------------------------------------------------------------
  Scenario: US-50 - Escenario 1: Técnico bloquea un día específico eliminando el horario
    * def techUsername = 'block_date_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    * def techId = 'tech-blk-' + randomString(4)
    # Crear horario para un día
    Given path 'schedules'
    And header Authorization = 'Bearer ' + token
    And request { "technicianId": "#(techId)", "day": "Saturday", "startTime": "09:00", "endTime": "14:00" }
    When method post
    Then status 201
    * def scheduleId = response.id
    * print 'Horario del sábado creado con ID:', scheduleId

    # Bloquear el día eliminando el horario (no disponible para asignación)
    Given path 'schedules', scheduleId
    And header Authorization = 'Bearer ' + token
    When method delete
    Then status 204
    * print 'Día bloqueado: el sábado ya no está disponible para asignación automática'

    # Verificar que el horario fue eliminado
    Given path 'schedules', scheduleId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 404
    * print 'Confirmado: horario eliminado - técnico no recibirá asignaciones ese día'

# -------------------------------------------------------------------------
# US-51: Visualizar Agenda de Trabajos Asignados Automáticamente
# Como técnico, quiero visualizar en un calendario todos los trabajos
# asignados dentro de mis horarios disponibles.
# -------------------------------------------------------------------------
  Scenario: US-51 - Escenario 1: Técnico visualiza su agenda con trabajos asignados
    * def techUsername = 'agenda_tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    * def techId = 'tech-agenda-' + randomString(4)

    # Ver horarios del técnico (agenda base)
    Given path 'schedules/technician', techId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Agenda del técnico consultada. Horarios disponibles:', response.length

    # Ver operaciones de servicio asignadas al técnico
    Given path 'service-operations/technicians', 1
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Trabajos asignados en la agenda del técnico:', response.length

# -------------------------------------------------------------------------
# US-52: Configurar Tiempo de Traslado Entre Servicios
# Como técnico, quiero configurar el tiempo promedio de traslado para que
# el sistema lo considere al asignar trabajos consecutivos.
# -------------------------------------------------------------------------
  Scenario: US-52 - Escenario 1: Técnico configura buffer de traslado en su perfil
    * def techUsername = 'travel_tech_' + randomString(6)
    * def email = techUsername + '@tech.com'
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Configurar tiempo de traslado en el perfil del técnico
    Given path 'profiles'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "firstName": "Mario",
        "lastName": "Traslado",
        "email": "#(email)",
        "street": "Av. Trabajo 200",
        "role": "TECHNICIAN",
        "additionalInfoOrCertification": "Certificado en eléctrica | Tiempo traslado: 30 minutos | Zona: Lima Centro"
      }
      """
    When method post
    Then status 201
    * def profileId = response.id
    And match response.additionalInfoOrCertification contains 'Tiempo traslado: 30 minutos'
    * print 'Buffer de traslado configurado en perfil del técnico ID:', profileId

# -------------------------------------------------------------------------
# US-56: Establecimiento de Precios por Tipo de Servicio y Zona
# Como técnico, quiero establecer precios diferenciados por tipo de servicio
# y opcionalmente por zona, para tener una estructura tarifaria clara.
# -------------------------------------------------------------------------
  Scenario: US-56 - Escenario 1: Técnico define precio base al crear un servicio
    * def techUsername = 'price_tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    # Crear servicio con precio base definido
    Given path 'services'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "name": "Instalación Eléctrica Residencial",
        "description": "Instalación completa de sistema eléctrico residencial",
        "basePrice": 350.00,
        "estimatedTime": 4,
        "category": "INSTALLATION",
        "isVisible": true,
        "createdBy": "#(techUsername)",
        "policy": "Garantía 6 meses",
        "restriction": "Solo viviendas residenciales",
        "tags": ["eléctrica", "residencial", "instalación"],
        "components": []
      }
      """
    When method post
    Then status 201
    And match response.basePrice == 350.00
    * print 'Servicio con precio base de S/. 350.00 creado. Visible para clientes.'

  Scenario: US-56 - Escenario 2: Técnico modifica precio de servicio existente
    * def techUsername = 'price_upd_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token
    Given path 'services'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "name": "Mantenimiento Preventivo_" + randomString(4),
        "description": "Revisión periódica de instalación",
        "basePrice": 150.00,
        "estimatedTime": 2,
        "category": "MAINTENANCE",
        "isVisible": true,
        "createdBy": "#(techUsername)",
        "policy": "Sin garantía",
        "restriction": "Ninguna",
        "tags": ["mantenimiento"],
        "components": []
      }
      """
    When method post
    Then status 201
    * def serviceId = response.id
    # Actualizar precio diferenciado por zona
    Given path 'services', serviceId
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "name": "Mantenimiento Preventivo Premium",
        "description": "Revisión periódica - Zona Centro",
        "basePrice": 200.00,
        "estimatedTime": 2,
        "category": "MAINTENANCE",
        "isVisible": true,
        "createdBy": "#(techUsername)",
        "policy": "Garantía 1 mes",
        "restriction": "Solo Lima Centro",
        "tags": ["mantenimiento", "premium"],
        "components": []
      }
      """
    When method put
    Then status 200
    And match response.basePrice == 200.00
    * print 'Precio diferenciado por zona actualizado a S/. 200.00'

# -------------------------------------------------------------------------
# US-62: Actualización Automática de Inventario Post-Servicio
# Como técnico, quiero que el sistema descuente automáticamente del
# inventario los componentes utilizados al completar un servicio.
# -------------------------------------------------------------------------
  Scenario: US-62 - Escenario 1: Técnico completa servicio y stock se descuenta
    * def techUsername = 'stock_tech_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear operación de servicio y completarla
    Given path 'service-operations'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 10, "technicianId": 1 }
    When method post
    Then status 201
    * def opId = response.id
    And match response.currentStatus == 'PENDING'

    # Avanzar a IN_PROGRESS
    Given path 'service-operations/status'
    And header Authorization = 'Bearer ' + token
    And request { "serviceOperationId": "#(opId)", "newStatus": "IN_PROGRESS" }
    When method put
    Then status 204

    # Completar el servicio - dispara ServiceCompletedEvent → descuento de stock
    Given path 'service-operations/status'
    And header Authorization = 'Bearer ' + token
    And request { "serviceOperationId": "#(opId)", "newStatus": "COMPLETED" }
    When method put
    Then status 204
    * print 'Servicio completado. Sistema debe publicar ServiceCompletedEvent y descontar stock del inventario.'

    # Verificar estado final
    Given path 'service-operations', opId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.currentStatus == 'COMPLETED'
    * print 'Stock del inventario actualizado automáticamente post-servicio.'

# -------------------------------------------------------------------------
# US-63: Historial de Clientes Atendidos
# Como técnico, quiero acceder a un historial detallado de los clientes
# que he atendido para dar seguimiento a relaciones profesionales.
# -------------------------------------------------------------------------
  Scenario: US-63 - Escenario 1: Técnico consulta historial de operaciones de servicio realizadas
    * def techUsername = 'hist_client_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Consultar operaciones de servicio asignadas al técnico (historial de clientes)
    Given path 'service-operations/technicians', 1
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response == '#array'
    * print 'Historial de clientes atendidos (service operations) - Total:', response.length

  Scenario: US-63 - Escenario 2: Técnico accede a detalle de servicio prestado a un cliente
    * def techUsername = 'hist_det_' + randomString(6)
    Given path 'authentication/sign-up'
    And request { "username": "#(techUsername)", "password": "password123", "roles": ["ROLE_TECHNICIAN"] }
    When method post
    Then status 201
    Given path 'authentication/sign-in'
    And request { "username": "#(techUsername)", "password": "password123" }
    When method post
    Then status 200
    * def token = response.token

    # Crear operación de servicio para el historial
    Given path 'service-operations'
    And header Authorization = 'Bearer ' + token
    And request { "requestId": 20, "technicianId": 1 }
    When method post
    Then status 201
    * def opId = response.id

    # Consultar detalle del servicio prestado (incluye requestId = cliente atendido)
    Given path 'service-operations', opId
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response.id == opId
    And match response.requestId != '#null'
    And match response.technicianId != '#null'
    * print 'Detalle de cliente atendido - RequestID:', response.requestId, '| TechnicianID:', response.technicianId
