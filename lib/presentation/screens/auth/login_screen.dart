import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../parent/parent_dashboard.dart';
import '../student/student_dashboard.dart';
import '../teacher/teacher_dashboard.dart';
import '../admin/admin_dashboard.dart';

// Asumiendo que UserRole está definido en tu auth_provider.dart
enum UserRole { parent, student, teacher, admin } 

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
        case UserRole.parent: // Asegúrate de que esta línea esté presente y correcta
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
        // ⭐ SOLUCIÓN CLAVE: Añadir un 'default' si el rol no está cubierto o es inesperado
        default: 
          // Puedes navegar a una pantalla de error, un login de nuevo, o un dashboard genérico.
          // Aquí vamos a un dashboard por defecto (ej. estudiante) o mostramos un error.
          // Para ser seguro, puedes lanzar un error o ir al dashboard de estudiante:
          dashboard = const StudentDashboard(); 
          // O podrías mostrar un error en pantalla (más recomendado para producción):
          // throw Exception("Rol de usuario desconocido: ${user.role}");
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
    // Definimos el ancho máximo para que se vea bien en pantallas grandes (web/tablet)
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    final maxCardWidth = isLargeScreen ? 400.0 : double.infinity;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxCardWidth),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Encabezado Mejorado ---
                      // Puedes reemplazar el Icon con un Image.asset si tienes un logo
                      Icon(
                        Icons.school_sharp, // Icono ligeramente diferente
                        size: 80,
                        color: Theme.of(context).colorScheme.primary, // Usamos colorScheme
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bienvenido/a al Sistema Escolar',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Inicia sesión con tu correo y contraseña.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // --- Contenedor del Formulario (Card Elevado) ---
                      Card(
                        elevation: 8, // Una sombra más marcada para un look moderno
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // Ocupar el espacio mínimo vertical
                              children: [
                                // Campo de Email
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Correo Electrónico',
                                    prefixIcon: const Icon(Icons.person_outline), // Icono más común para login
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), // Bordes redondeados
                                    hintText: 'ejemplo@uepth.edu',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa tu correo';
                                    }
                                    // Validación simple de formato de email (opcional)
                                    if (!value.contains('@') || !value.contains('.')) {
                                       return 'Ingresa un correo válido';
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
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), // Bordes redondeados
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
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
                                  _buildErrorMessage(context, authProvider.errorMessage!),
                                  
                                // Botón de Iniciar Sesión
                                SizedBox(
                                  height: 56, // Botón un poco más alto
                                  child: ElevatedButton.icon(
                                    icon: authProvider.isLoading ? const SizedBox.shrink() : const Icon(Icons.login),
                                    label: authProvider.isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5, // Grosor ligeramente mayor
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text('INICIAR SESIÓN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    onPressed: authProvider.isLoading ? null : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10), // Borde redondeado
                                      ),
                                      minimumSize: const Size(double.infinity, 56), // Asegura ancho completo
                                      backgroundColor: Theme.of(context).colorScheme.primary, // Usa el color primario
                                      foregroundColor: Theme.of(context).colorScheme.onPrimary, // Texto en color opuesto al primario
                                      elevation: 4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Información de prueba (Movida fuera del Card principal)
                      if (authProvider.currentUser == null) // Solo si no ha iniciado sesión
                         _buildTestInfoCard(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Widget para el mensaje de error (Ligeramente ajustado)
  Widget _buildErrorMessage(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.error.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }


  /// Card con información de usuarios de prueba (Colores y estilo ajustados)
  Widget _buildTestInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_outlined, color: Colors.amber.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Acceso de Prueba (Desarrollo)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
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
              color: Colors.amber.shade700,
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
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '• $role: ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.amber.shade800,
              ),
            ),
            TextSpan(
              text: email,
              style: TextStyle(
                fontSize: 13,
                color: Colors.amber.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}