import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../parent/parent_dashboard.dart';
import '../student/student_dashboard.dart';
import '../teacher/teacher_dashboard.dart';
import '../admin/admin_dashboard.dart';

/// Pantalla de Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Key para el formulario (para validaciones)
  final _formKey = GlobalKey<FormState>();
  
  // Para mostrar/ocultar la contraseña
  bool _obscurePassword = true;

  @override
  void dispose() {
    // IMPORTANTE: Limpiar los controladores cuando se destruye la pantalla
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Método que se ejecuta al presionar "Iniciar Sesión"
  Future<void> _handleLogin() async {
    // Validar el formulario
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Intentar hacer login
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        // Login exitoso - Navegar según el rol
        final user = authProvider.currentUser!;
        Widget dashboard;

        switch (user.role) {
          case UserRole.parent:
            dashboard = const ParentDashboard();
            break;
          case UserRole.student:
            dashboard = const StudentDashboard();
            break;
          case UserRole.teacher:
            dashboard = const TeacherDashboard();
            break;
          case UserRole.admin:
            dashboard = const AdminDashboard();
            break;
        }

        // Navegar al dashboard correspondiente
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => dashboard),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      // Logo o icono del colegio
                      Icon(
                        Icons.school,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 24),
                      
                      // Título
                      Text(
                        'U.E.P. Técnico Humanístico',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      
                      // Subtítulo
                      Text(
                        'Sistema de Seguimiento Escolar',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      
                      // Campo de Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: 'ejemplo@uepth.edu',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo';
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
                      const SizedBox(height: 24),
                      
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
                      
                      // Botón de Iniciar Sesión
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _handleLogin,
                          child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Iniciar Sesión'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Información de prueba
                      _buildTestInfoCard(),
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

  /// Card con información de usuarios de prueba
  Widget _buildTestInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Usuarios de Prueba',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTestUser('Padre/Tutor', 'padre@uepth.edu'),
          _buildTestUser('Estudiante', 'estudiante@uepth.edu'),
          _buildTestUser('Docente', 'docente@uepth.edu'),
          _buildTestUser('Administrador', 'admin@uepth.edu'),
          const SizedBox(height: 8),
          Text(
            'Contraseña: cualquiera',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestUser(String role, String email) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '• $role: $email',
        style: TextStyle(
          fontSize: 13,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }
}