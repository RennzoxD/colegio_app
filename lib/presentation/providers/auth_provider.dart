import 'package:flutter/foundation.dart';
import '../../data/services/api_service.dart';

// ============================================================================
// ENUMS Y MODELOS
// ============================================================================

/// Roles disponibles en el sistema
/// 
/// Un "enum" es una lista fija de valores posibles
/// Es más seguro que usar strings porque evita errores de escritura
/// 
/// Uso:
/// ```dart
/// UserRole miRol = UserRole.teacher;
/// if (miRol == UserRole.teacher) {
///   print('Soy docente');
/// }
/// ```
enum UserRole {
  parent,    // Padre/Tutor - Puede ver info de sus hijos
  student,   // Estudiante - Puede ver sus propias notas y tareas
  teacher,   // Docente - Puede registrar notas y asistencias
  admin,     // Administrador - Tiene acceso completo al sistema
}

/// Modelo de Usuario
/// 
/// Representa a un usuario autenticado en la app
/// Es una clase simple que solo almacena datos (no tiene lógica compleja)
/// 
/// Ejemplo de uso:
/// ```dart
/// User usuario = User(
///   id: '1',
///   name: 'Juan Pérez',
///   email: 'juan@example.com',
///   role: UserRole.student,
/// );
/// 
/// print(usuario.name);  // 'Juan Pérez'
/// print(usuario.role);  // UserRole.student
/// ```
class User {
  /// ID único del usuario (viene del backend)
  final String id;
  
  /// Nombre completo del usuario
  final String name;
  
  /// Email del usuario (usado para login)
  final String email;
  
  /// Rol del usuario (determina qué puede hacer en la app)
  final UserRole role;

  /// Constructor - Crea una nueva instancia de User
  /// 
  /// El "required" indica que estos parámetros son obligatorios
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

// ============================================================================
// PROVIDER DE AUTENTICACIÓN
// ============================================================================

/// Provider de Autenticación
/// 
/// Este es el "cerebro" del sistema de autenticación
/// Maneja TODO lo relacionado con el login, logout y usuario actual
/// 
/// ¿Qué es un Provider?
/// - Es un patrón de gestión de estado en Flutter
/// - Permite compartir datos entre múltiples pantallas
/// - Cuando cambian los datos, TODAS las pantallas que lo usan se actualizan automáticamente
/// 
/// ¿Por qué usar Provider?
/// - Sin Provider: Tendrías que pasar el usuario por CADA pantalla manualmente
/// - Con Provider: Cualquier pantalla puede acceder al usuario con Provider.of<AuthProvider>(context)
/// 
/// Flujo de autenticación:
/// 1. Usuario ingresa email/password en LoginScreen
/// 2. LoginScreen llama a authProvider.login(email, password)
/// 3. AuthProvider llama al backend a través de ApiService
/// 4. Si el backend responde OK, guardamos el usuario y el token
/// 5. La app navega automáticamente al dashboard correspondiente
class AuthProvider extends ChangeNotifier {
  // ==========================================================================
  // INSTANCIAS Y ESTADO
  // ==========================================================================
  
  /// Instancia del servicio de API
  /// Lo usamos para hacer las peticiones HTTP al backend
  final _apiService = ApiService();
  
  /// Usuario actualmente autenticado
  /// 
  /// null = No hay usuario logueado
  /// User = Hay un usuario logueado
  /// 
  /// El guion bajo (_) hace que sea privada (solo accesible dentro de esta clase)
  /// Para acceder desde fuera, se usa el getter "currentUser"
  User? _currentUser;
  
  /// Indica si está en proceso de login/logout
  /// 
  /// true = Mostramos un loading spinner
  /// false = Mostramos los botones normales
  bool _isLoading = false;
  
  /// Mensaje de error (si algo salió mal)
  /// 
  /// null = No hay error
  /// String = Hay un error, mostrarlo al usuario
  String? _errorMessage;

  // ==========================================================================
  // GETTERS (Acceso de solo lectura a las variables privadas)
  // ==========================================================================
  
  /// Obtiene el usuario actual
  /// 
  /// Uso en la UI:
  /// ```dart
  /// final authProvider = Provider.of<AuthProvider>(context);
  /// final user = authProvider.currentUser;
  /// 
  /// if (user != null) {
  ///   print('Usuario: ${user.name}');
  /// }
  /// ```
  User? get currentUser => _currentUser;
  
  /// Obtiene el estado de carga
  /// 
  /// Uso en la UI:
  /// ```dart
  /// if (authProvider.isLoading) {
  ///   return CircularProgressIndicator();
  /// } else {
  ///   return ElevatedButton(...);
  /// }
  /// ```
  bool get isLoading => _isLoading;
  
  /// Obtiene el mensaje de error
  /// 
  /// Uso en la UI:
  /// ```dart
  /// if (authProvider.errorMessage != null) {
  ///   ScaffoldMessenger.of(context).showSnackBar(
  ///     SnackBar(content: Text(authProvider.errorMessage!)),
  ///   );
  /// }
  /// ```
  String? get errorMessage => _errorMessage;
  
  /// Verifica si hay un usuario autenticado
  /// 
  /// Uso:
  /// ```dart
  /// if (authProvider.isAuthenticated) {
  ///   // Ir al dashboard
  /// } else {
  ///   // Ir al login
  /// }
  /// ```
  bool get isAuthenticated => _currentUser != null;

  // ==========================================================================
  // MÉTODO PRINCIPAL: LOGIN
  // ==========================================================================

  /// Autentica al usuario contra el backend
  /// 
  /// FLUJO COMPLETO DEL LOGIN:
  /// 
  /// 1. Usuario presiona "Iniciar Sesión" en la UI
  /// 2. Se llama a este método: authProvider.login(email, password)
  /// 3. Activamos el loading (_isLoading = true)
  /// 4. Notificamos a la UI (notifyListeners) - La UI muestra un spinner
  /// 5. Hacemos la petición HTTP al backend (apiService.login)
  /// 6. El backend valida las credenciales en la base de datos
  /// 7. Si son correctas, el backend devuelve: {token: '...', user: {...}}
  /// 8. Guardamos el token (para futuras peticiones)
  /// 9. Creamos el objeto User con los datos recibidos
  /// 10. Desactivamos el loading (_isLoading = false)
  /// 11. Notificamos a la UI - La UI navega al dashboard
  /// 
  /// @param email - Email del usuario
  /// @param password - Contraseña del usuario
  /// @return true si el login fue exitoso, false si falló
  Future<bool> login(String email, String password) async {
    // ----------------------------------------------------------------------
    // PASO 1: Preparar el estado para el proceso de login
    // ----------------------------------------------------------------------
    
    _isLoading = true;           // Activar loading
    _errorMessage = null;         // Limpiar errores anteriores
    notifyListeners();            // Notificar a la UI que el estado cambió
                                  // Esto hace que la UI se redibuje y muestre el loading

    try {
      // --------------------------------------------------------------------
      // PASO 2: Hacer la petición HTTP al backend
      // --------------------------------------------------------------------
      
      // Esto envía una petición POST a: http://127.0.0.1:8000/api/legacy-login
      // Con el body: {"email": "...", "password": "...", "device": "mobile"}
      final response = await _apiService.login(email, password);
      
      // La respuesta del backend tiene esta estructura:
      // {
      //   "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
      //   "user": {
      //     "id": 1,
      //     "name": "Administrador",
      //     "email": "admin@example.com",
      //     "role": "admin"
      //   }
      // }

      // --------------------------------------------------------------------
      // PASO 3: Guardar el token para futuras peticiones
      // --------------------------------------------------------------------
      
      // El token es como una "llave" que identifica al usuario
      // Se incluye en TODAS las peticiones futuras al backend
      // El backend lo usa para saber quién está haciendo la petición
      await _apiService.setToken(response['token']);

      // --------------------------------------------------------------------
      // PASO 4: Crear el objeto User con los datos del backend
      // --------------------------------------------------------------------
      
      final userData = response['user'];  // Extraer los datos del usuario
      
      _currentUser = User(
        id: userData['id'].toString(),     // Convertir el ID a String
        name: userData['name'],             // Nombre del usuario
        email: userData['email'],           // Email del usuario
        role: _parseRole(userData['role']), // Convertir el rol a enum
      );

      // --------------------------------------------------------------------
      // PASO 5: Finalizar el proceso de login exitoso
      // --------------------------------------------------------------------
      
      _isLoading = false;      // Desactivar loading
      notifyListeners();       // Notificar a la UI
                               // La UI navega automáticamente al dashboard
      
      return true;  // Login exitoso

    } catch (e) {
      // ----------------------------------------------------------------------
      // MANEJO DE ERRORES
      // ----------------------------------------------------------------------
      
      // Si algo salió mal (credenciales incorrectas, sin internet, etc.)
      // capturamos el error aquí
      
      _errorMessage = 'Error al iniciar sesión: $e';  // Guardar el error
      _isLoading = false;                             // Desactivar loading
      notifyListeners();                              // Notificar a la UI
                                                       // La UI muestra el error
      
      return false;  // Login fallido
    }
  }

  // ==========================================================================
  // MÉTODO AUXILIAR: PARSEAR ROL
  // ==========================================================================

  /// Convierte un string de rol a un enum UserRole
  /// 
  /// El backend nos envía el rol como string: "admin", "teacher", etc.
  /// Pero en Flutter usamos enums para mayor seguridad
  /// Este método hace la conversión
  /// 
  /// Ejemplos:
  /// - "admin" → UserRole.admin
  /// - "teacher" → UserRole.teacher
  /// - "docente" → UserRole.teacher (soporta sinónimos)
  /// - "ADMIN" → UserRole.admin (no importan mayúsculas)
  /// 
  /// @param roleStr - El rol como string
  /// @return El rol como enum UserRole
  UserRole _parseRole(String roleStr) {
    // Convertir a minúsculas para hacer la comparación case-insensitive
    switch (roleStr.toLowerCase()) {
      case 'parent':
      case 'tutor':
      case 'padre':
        return UserRole.parent;
        
      case 'student':
      case 'estudiante':
      case 'alumno':
        return UserRole.student;
        
      case 'teacher':
      case 'docente':
      case 'profesor':
        return UserRole.teacher;
        
      case 'admin':
      case 'administrador':
      case 'administrator':
        return UserRole.admin;
        
      default:
        // Si no reconocemos el rol, default a student por seguridad
        return UserRole.student;
    }
  }

  // ==========================================================================
  // MÉTODO: LOGOUT
  // ==========================================================================

  /// Cierra la sesión del usuario
  /// 
  /// FLUJO DEL LOGOUT:
  /// 1. Notificar al backend que el usuario cerró sesión
  /// 2. El backend invalida el token (ya no servirá)
  /// 3. Eliminar el token local
  /// 4. Eliminar el usuario actual
  /// 5. Notificar a la UI - La UI navega al login
  /// 
  /// Uso:
  /// ```dart
  /// await authProvider.logout();
  /// Navigator.pushReplacement(context, LoginScreen());
  /// ```
  Future<void> logout() async {
    // Notificar al backend (esto invalida el token en el servidor)
    await _apiService.logout();
    
    // Limpiar el estado local
    _currentUser = null;      // Ya no hay usuario
    _errorMessage = null;     // Limpiar errores
    
    // Notificar a la UI
    notifyListeners();
  }

  // ==========================================================================
  // MÉTODO: LIMPIAR ERROR
  // ==========================================================================

  /// Limpia el mensaje de error
  /// 
  /// Útil después de mostrar el error al usuario
  /// Para que no se muestre de nuevo
  /// 
  /// Uso:
  /// ```dart
  /// // Mostrar error
  /// if (authProvider.errorMessage != null) {
  ///   showDialog(...);
  ///   authProvider.clearError();  // Limpiar después de mostrar
  /// }
  /// ```
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}