import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colegio_app/presentation/providers/auth_provider.dart';
import 'package:colegio_app/presentation/screens/parent/parent_dashboard.dart';
import 'package:colegio_app/presentation/screens/student/student_dashboard.dart';
import 'package:colegio_app/presentation/screens/teacher/teacher_dashboard.dart';
import 'package:colegio_app/presentation/screens/admin/admin_dashboard.dart';
import 'package:colegio_app/presentation/screens/teacher/nivel_selection_screen.dart';

/// Pantalla de Login específica por rol
class LoginScreen extends StatefulWidget {
  final UserRole role;

  const LoginScreen({
    super.key,
    this.role = UserRole.parent,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Obtener configuración según el rol
  Map<String, dynamic> _getRoleConfig() {
    switch (widget.role) {
      case UserRole.parent:
        return {
          'title': 'Padres/Tutores',
          'icon': Icons.family_restroom,
          'color': const Color(0xFF3B82F6),
          'placeholder': 'Código o Nombre del Estudiante',
          'hint': 'Ej: EST-2025-001 o Juan Pérez',
        };
      case UserRole.student:
        return {
          'title': 'Estudiantes',
          'icon': Icons.school,
          'color': const Color(0xFFFBBF24),
          'placeholder': 'Código de Estudiante',
          'hint': 'Ej: EST-2025-001',
        };
      case UserRole.teacher:
        return {
          'title': 'Docentes',
          'icon': Icons.menu_book,
          'color': const Color(0xFF8B5CF6),
          'placeholder': 'Usuario Docente',
          'hint': 'Ingresa tu usuario',
        };
      case UserRole.admin:
        return {
          'title': 'Administrador',
          'icon': Icons.admin_panel_settings,
          'color': const Color(0xFFEF4444),
          'placeholder': 'Usuario Administrador',
          'hint': 'Ingresa tu usuario',
        };
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Widget dashboard;
        switch (widget.role) {
          case UserRole.parent:
            dashboard = const ParentDashboard();
            break;
          case UserRole.student:
            dashboard = const StudentDashboard();
            break;
            case UserRole.teacher:
              dashboard = const NivelSelectionScreen();
              break;
          case UserRole.admin:
            dashboard = const AdminDashboard();
            break;
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => dashboard),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getRoleConfig();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Icono del rol
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: config['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          config['icon'],
                          size: 60,
                          color: config['color'],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Título
                      Text(
                        config['title'],
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      
                      // Subtítulo
                      Text(
                        'Ingresa tus credenciales',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      
                      // Campo de Usuario/Código
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: config['placeholder'],
                          hintText: config['hint'],
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu usuario';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Campo de Contraseña
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword 
                                ? Icons.visibility_outlined 
                                : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),
                      
                      // ¿Olvidaste tu contraseña?
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implementar recuperación de contraseña
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Función en desarrollo'),
                              ),
                            );
                          },
                          child: const Text('¿Olvidaste tu contraseña?'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Mostrar error si hay
                      if (authProvider.errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.errorMessage!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Botón de Ingresar
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: config['color'],
                          ),
                          child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Ingresar'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Info de prueba (temporal - quitar en producción)
                      _buildTestInfo(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bug_report, color: Colors.amber.shade700, size: 16),
              const SizedBox(width: 8),
              Text(
                'Modo de Prueba',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Usuario: cualquiera | Contraseña: cualquiera',
            style: TextStyle(
              fontSize: 11,
              color: Colors.amber.shade800,
            ),
          ),
        ],
      ),
    );
  }
}