import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de API - Maneja TODAS las comunicaciones con el backend Laravel
/// 
/// Este servicio es un "Singleton" (solo existe UNA instancia en toda la app)
/// Es responsable de:
/// 1. Hacer peticiones HTTP al backend (GET, POST, PUT, DELETE)
/// 2. Guardar y cargar el token de autenticación
/// 3. Agregar automáticamente el token a todas las peticiones
/// 4. Manejar errores de red
class ApiService {
  // ========================================================================
  // CONFIGURACIÓN
  // ========================================================================
  
  /// URL base del backend Laravel
  /// 🔥 IMPORTANTE: 
  /// - En desarrollo local: http://127.0.0.1:8000/api
  /// - En producción: https://tu-servidor.com/api
  /// - Si usas tu celular físico: http://TU_IP_LOCAL:8000/api (ej: http://192.168.1.5:8000/api)
  static const String baseUrl = 'http://localhost:8000/api';
  
  /// Token de autenticación (lo recibimos después del login)
  /// Este token se envía en TODAS las peticiones para que el backend
  /// sepa quién es el usuario que está haciendo la petición
  String? _token;
  
  // ========================================================================
  // PATRÓN SINGLETON
  // ========================================================================
  
  /// Instancia única del servicio (Patrón Singleton)
  /// Esto garantiza que solo haya UNA instancia de ApiService en toda la app
  static final ApiService _instance = ApiService._internal();
  
  /// Factory constructor - Siempre devuelve la misma instancia
  /// Cuando hagas: ApiService() 
  /// Siempre obtendrás la MISMA instancia, no una nueva
  factory ApiService() => _instance;
  
  /// Constructor privado - Solo se llama una vez
  /// El guion bajo (_) hace que sea privado
  ApiService._internal();

  // ========================================================================
  // GESTIÓN DEL TOKEN
  // ========================================================================

  /// Guarda el token de autenticación
  /// 
  /// Cuando el usuario hace login exitoso, el backend nos devuelve un token.
  /// Este método:
  /// 1. Guarda el token en memoria (_token)
  /// 2. Lo guarda en el almacenamiento local (SharedPreferences) para persistencia
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// await apiService.setToken('eyJ0eXAiOiJKV1QiLCJhbGc...');
  /// ```
  Future<void> setToken(String token) async {
    // Guardar en memoria (para usar durante esta sesión)
    _token = token;
    
    // Guardar en almacenamiento permanente (persiste entre reinicios de la app)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Carga el token guardado desde el almacenamiento local
  /// 
  /// Esto se llama al iniciar la app para recuperar la sesión del usuario
  /// Si el usuario ya había iniciado sesión antes, no necesita hacerlo de nuevo
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// await apiService.loadToken();
  /// if (apiService.isAuthenticated) {
  ///   // El usuario ya tiene sesión
  /// }
  /// ```
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  /// Verifica si hay un token (usuario autenticado)
  bool get isAuthenticated => _token != null;

  // ========================================================================
  // HEADERS (CABECERAS HTTP)
  // ========================================================================

  /// Headers comunes para TODAS las peticiones HTTP
  /// 
  /// Los headers son metadatos que acompañan cada petición HTTP
  /// Le dicen al servidor información adicional sobre la petición:
  /// 
  /// - Content-Type: Le dice al servidor que enviamos JSON
  /// - Accept: Le dice al servidor que esperamos JSON como respuesta
  /// - Authorization: Contiene el token para identificar al usuario
  /// 
  /// El "if (_token != null)" es una característica de Dart:
  /// Solo agrega el header Authorization SI hay un token
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',  // Enviamos datos en formato JSON
    'Accept': 'application/json',        // Esperamos respuesta en formato JSON
    if (_token != null) 'Authorization': 'Bearer $_token',  // Token de autenticación (solo si existe)
  };

  // ========================================================================
  // MÉTODOS HTTP
  // ========================================================================

  /// Petición GET - Para LEER datos del servidor
  /// 
  /// Se usa para obtener información sin modificar nada en el servidor
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// // Obtener lista de estudiantes
  /// final data = await apiService.get('students');
  /// print(data['students']); // [{id: 1, name: 'Juan'}, ...]
  /// 
  /// // Obtener UN estudiante específico
  /// final data = await apiService.get('students/5');
  /// print(data['student']); // {id: 5, name: 'María'}
  /// ```
  /// 
  /// @param endpoint - La ruta del endpoint (sin la URL base)
  /// @return Map con los datos de la respuesta
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      // Construir la URL completa
      // Ejemplo: baseUrl = 'http://127.0.0.1:8000/api'
      //          endpoint = 'students'
      //          URL final = 'http://127.0.0.1:8000/api/students'
      final url = Uri.parse('$baseUrl/$endpoint');
      
      // Hacer la petición HTTP GET
      final response = await http.get(
        url,
        headers: _headers,  // Incluye automáticamente el token si existe
      );
      
      // Procesar la respuesta
      return _handleResponse(response);
      
    } catch (e) {
      // Si hay error de red (sin internet, servidor caído, etc.)
      throw Exception('Error de conexión: $e');
    }
  }

  /// Petición POST - Para CREAR o ENVIAR datos al servidor
  /// 
  /// Se usa para crear nuevos registros o enviar información al servidor
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// // Hacer login
  /// final response = await apiService.post('legacy-login', {
  ///   'email': 'admin@example.com',
  ///   'password': 'password123',
  ///   'device': 'mobile',
  /// });
  /// 
  /// // Crear un nuevo estudiante
  /// final response = await apiService.post('students', {
  ///   'nombres': 'Juan',
  ///   'apellidos': 'Pérez',
  ///   'email': 'juan@example.com',
  /// });
  /// ```
  /// 
  /// @param endpoint - La ruta del endpoint
  /// @param body - Los datos a enviar (se convertirán a JSON automáticamente)
  /// @return Map con los datos de la respuesta
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      // Construir la URL completa
      final url = Uri.parse('$baseUrl/$endpoint');
      
      // Hacer la petición HTTP POST
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(body),  // Convertir el Map a JSON string
      );
      
      // Procesar la respuesta
      return _handleResponse(response);
      
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Petición PUT - Para ACTUALIZAR datos existentes
  /// 
  /// Se usa para modificar registros que ya existen
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// // Actualizar un estudiante
  /// final response = await apiService.put('students/5', {
  ///   'email': 'nuevo_email@example.com',
  ///   'telefono': '123456789',
  /// });
  /// ```
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.put(
        url,
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Petición DELETE - Para ELIMINAR datos
  /// 
  /// Se usa para borrar registros del servidor
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// // Eliminar un estudiante
  /// await apiService.delete('students/5');
  /// ```
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.delete(
        url,
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ========================================================================
  // PROCESAMIENTO DE RESPUESTAS
  // ========================================================================

  /// Procesa la respuesta HTTP y convierte el JSON a un Map
  /// 
  /// Códigos de estado HTTP:
  /// - 200-299: Éxito (OK)
  /// - 400-499: Error del cliente (datos incorrectos, no autorizado, etc.)
  /// - 500-599: Error del servidor (el backend tiene un problema)
  /// 
  /// @param response - La respuesta HTTP del servidor
  /// @return Map con los datos parseados
  /// @throws Exception si el código de estado indica error
  Map<String, dynamic> _handleResponse(http.Response response) {
    // Verificar si la petición fue exitosa (código 200-299)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Convertir el JSON string a un Map de Dart
      return json.decode(response.body);
    } else {
      // Si hubo error, lanzar una excepción con el detalle
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  // ========================================================================
  // ENDPOINTS ESPECÍFICOS (métodos de conveniencia)
  // ========================================================================

  /// Login - Autentica al usuario y obtiene un token
  /// 
  /// Este método es un "wrapper" que facilita el uso del endpoint de login
  /// En lugar de escribir:
  ///   apiService.post('legacy-login', {...})
  /// 
  /// Puedes escribir:
  ///   apiService.login(email, password)
  /// 
  /// El backend espera estos datos:
  /// {
  ///   "email": "admin@example.com",
  ///   "password": "password123",
  ///   "device": "mobile"
  /// }
  /// 
  /// Y devuelve:
  /// {
  ///   "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  ///   "user": {
  ///     "id": 1,
  ///     "name": "Administrador",
  ///     "email": "admin@example.com",
  ///     "role": "admin"
  ///   }
  /// }
  /// 
  /// @param email - Email del usuario
  /// @param password - Contraseña
  /// @return Map con el token y datos del usuario
  Future<Map<String, dynamic>> login(String email, String password) async {
    return await post('legacy-login', {
      'email': email,
      'password': password,
      'device': 'mobile',  // Identificador del dispositivo
    });
  }

  /// Logout - Cierra la sesión del usuario
  /// 
  /// Este método:
  /// 1. Notifica al backend que el usuario cerró sesión (invalida el token)
  /// 2. Elimina el token de la memoria
  /// 3. Elimina el token del almacenamiento local
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// await apiService.logout();
  /// // Ahora el usuario no está autenticado
  /// ```
  Future<void> logout() async {
    try {
      // Notificar al backend (esto invalida el token en el servidor)
      await post('logout', {});
    } catch (e) {
      // Si falla (por ejemplo, sin internet), continuamos de todos modos
      // El token se eliminará localmente
      print('Error al notificar logout al servidor: $e');
    }
    
    // Eliminar token de la memoria
    _token = null;
    
    // Eliminar token del almacenamiento local
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // ========================================================================
  // MÉTODOS ADICIONALES PARA ENDPOINTS ESPECÍFICOS
  // ========================================================================

  /// Obtener lista de estudiantes
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// final students = await apiService.getStudents();
  /// for (var student in students) {
  ///   print(student['nombres']);
  /// }
  /// ```
  Future<List<dynamic>> getStudents() async {
    final response = await get('students');
    return response['data'] ?? [];
  }

  /// Obtener un estudiante específico
  /// 
  /// @param id - ID del estudiante
  Future<Map<String, dynamic>> getStudent(int id) async {
    return await get('students/$id');
  }

  /// Obtener lista de docentes
  Future<List<dynamic>> getTeachers() async {
    final response = await get('teachers');
    return response['data'] ?? [];
  }

  /// Obtener secciones con filtros opcionales
  /// 
  /// @param year - Año lectivo (opcional)
  /// @param nivel - Nivel educativo (opcional)
  /// @param estado - Estado de la sección (opcional)
  Future<List<dynamic>> getSections({String? year, String? nivel, String? estado}) async {
    String endpoint = 'sections?';
    if (year != null) endpoint += 'year=$year&';
    if (nivel != null) endpoint += 'nivel=$nivel&';
    if (estado != null) endpoint += 'estado=$estado&';
    
    final response = await get(endpoint);
    return response['data'] ?? [];
  }
}