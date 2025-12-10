import 'package:flutter/foundation.dart';

/// Roles disponibles en el sistema
enum UserRole {
  parent,    // Padre/Tutor
  student,   // Estudiante
  teacher,   // Docente
  admin,     // Administrador
}

/// Modelo simple del usuario
class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

/// Provider de Autenticación
/// Maneja el estado del login, logout y usuario actual
class AuthProvider extends ChangeNotifier {
  // Usuario actual (null = no hay sesión)
  User? _currentUser;
  
  // Estado de carga (útil para mostrar un loading)
  bool _isLoading = false;
  
  // Mensaje de error (si hay)
  String? _errorMessage;

  // Getters (para acceder a los datos desde la UI)
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Método de Login (Simulado por ahora)
  /// En la Fase 5 conectaremos al API real
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notifica a la UI que hubo cambios

    try {
      // Simulamos un delay de red (como si estuviéramos esperando respuesta del servidor)
      await Future.delayed(const Duration(seconds: 2));

      // 🎭 DATOS SIMULADOS (Mock Data)
      // Aquí simularemos diferentes usuarios según el email
      
      if (password.isEmpty) {
        _errorMessage = 'La contraseña no puede estar vacía';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Simulación de usuarios de prueba
      User? user;
      
      if (email.contains('padre') || email.contains('parent')) {
        user = User(
          id: '1',
          name: 'María López',
          email: email,
          role: UserRole.parent,
        );
      } else if (email.contains('estudiante') || email.contains('student')) {
        user = User(
          id: '2',
          name: 'Juan Pérez',
          email: email,
          role: UserRole.student,
        );
      } else if (email.contains('docente') || email.contains('teacher')) {
        user = User(
          id: '3',
          name: 'Prof. Carlos García',
          email: email,
          role: UserRole.teacher,
        );
      } else if (email.contains('admin')) {
        user = User(
          id: '4',
          name: 'Administrador',
          email: email,
          role: UserRole.admin,
        );
      } else {
        // Si no coincide con ninguno, default a padre
        user = User(
          id: '1',
          name: 'Usuario Demo',
          email: email,
          role: UserRole.parent,
        );
      }

      // Guardamos el usuario actual
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      
      return true; // Login exitoso
      
    } catch (e) {
      _errorMessage = 'Error al iniciar sesión: $e';
      _isLoading = false;
      notifyListeners();
      return false; // Login fallido
    }
  }

  /// Método de Logout
  Future<void> logout() async {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Limpiar mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}