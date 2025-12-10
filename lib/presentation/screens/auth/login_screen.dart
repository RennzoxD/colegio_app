import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../parent/parent_dashboard.dart';
import '../student/student_dashboard.dart';
import '../teacher/teacher_dashboard.dart';
import '../admin/admin_dashboard.dart';

// Nota: Asegúrate de que UserRole esté definido en 'auth_provider.dart'

/// Pantalla de Login con diseño mejorado
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  // Animación para el logo/tarjeta
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Empieza ligeramente abajo
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Iniciar la animación después de un pequeño retraso
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Método de login (sin cambios funcionales)
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Limpiar mensaje de error previo al intentar de nuevo
      // Esta línea debe estar en tu AuthProvider.dart, pero la simulamos aquí si no está:
      // authProvider.clearError();

      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
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
          default:
            // Manejo de rol inesperado (solución al problema anterior)
            dashboard = const StudentDashboard(); 
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => dashboard),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    final maxFormWidth = isLargeScreen ? 420.0 : double.infinity;

    return Scaffold(
      // --- FASE 1: Fondo y Color principal ---
      body: Container(
        // Fondo de color primario para el "look" de portal
        color: theme.colorScheme.primary, 
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxFormWidth),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return SlideTransition(
                      position: _slideAnimation, // Aplicamos animación
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // --- FASE 2: Encabezado y Marca ---
                          _buildHeader(context),
                          const SizedBox(height: 32),
                          
                          // --- FASE 3: Tarjeta de Login (La Capa Flotante) ---
                          Card(
                            elevation: 16, // Elevación fuerte
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Iniciar Sesión',
                                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 24),

                                    // Campo de Email
                                    _buildEmailField(theme),
                                    const SizedBox(height: 16),

                                    // Campo de Contraseña
                                    _buildPasswordField(theme),
                                    const SizedBox(height: 24),
                                    
                                    // Mensaje de Error
                                    if (authProvider.errorMessage != null)
                                      _buildErrorMessage(context, authProvider.errorMessage!),
                                      
                                    // Botón de Iniciar Sesión
                                    _buildLoginButton(context, authProvider),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // --- FASE 4: Información de Prueba (Opcional, en el fondo) ---
                          if (authProvider.currentUser == null)
                             _buildTestInfoCard(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(
          Icons.school_sharp,
          size: 90,
          color: Colors.white, // Ícono blanco sobre fondo primario
        ),
        const SizedBox(height: 16),
        Text(
          'U.E.P. Técnico Humanístico',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Portal Educativo',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField(ThemeData theme) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Correo Electrónico',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: theme.colorScheme.surface, // Color de fondo del campo
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa tu correo';
        }
        if (!value.contains('@')) {
           return 'Formato de correo inválido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(ThemeData theme) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: theme.colorScheme.surface,
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
          return 'Ingresa tu contraseña';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthProvider authProvider) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 56, 
      child: ElevatedButton(
        child: authProvider.isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: theme.colorScheme.onPrimary,
                ),
              )
            : Text('ACCEDER AL PORTAL', style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              )),
        onPressed: authProvider.isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: theme.colorScheme.secondary, // Usamos 'secondary' para un mejor contraste.
          elevation: 6,
        ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer, // Color de fondo para errores (Material 3)
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.error),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: theme.colorScheme.onErrorContainer, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Fondo semitransparente sobre el color primario
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bug_report, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                'Acceso de Pruebas (DEV)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
              color: Colors.white70,
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
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: email,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}