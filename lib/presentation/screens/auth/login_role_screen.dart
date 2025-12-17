import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

// Importa tus dashboards reales
import '../parent/parent_dashboard.dart';
import '../student/student_dashboard.dart';
import '../teacher/teacher_dashboard.dart';
import '../admin/admin_dashboard.dart';

class LoginRoleScreen extends StatefulWidget {
  final String role; // student, teacher, parent, admin

  const LoginRoleScreen({super.key, required this.role});

  @override
  State<LoginRoleScreen> createState() => _LoginRoleScreenState();
}

class _LoginRoleScreenState extends State<LoginRoleScreen> {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // ------------ MAPA PARA CAMBIAR LA UI SEGÚN EL ROL ------------
  late String title;
  late String subtitle;
  late String labelCodigo;
  late IconData icono;

  @override
  void initState() {
    super.initState();

    switch (widget.role) {
      case "student":
        title = "Estudiantes";
        subtitle = "Revisa tus notas, tareas y avances";
        labelCodigo = "Código de Estudiante";
        icono = Icons.school;
        break;

      case "teacher":
        title = "Docentes";
        subtitle = "Gestiona tus notas, tareas y observaciones";
        labelCodigo = "Código de Docente";
        icono = Icons.menu_book_rounded;
        break;

      case "parent":
        title = "Padres/Tutores";
        subtitle = "Consulta la información académica de tu hijo";
        labelCodigo = "Código de Padre/Tutor";
        icono = Icons.family_restroom;
        break;

      case "admin":
        title = "Administrador";
        subtitle = "Administra el sistema académico";
        labelCodigo = "Código de Administrador";
        icono = Icons.admin_panel_settings;
        break;

      default:
        title = "Usuario";
        subtitle = "";
        labelCodigo = "Código";
        icono = Icons.person;
    }
  }

  // ------------ VALIDACIÓN + REDIRECCIÓN AUTOMÁTICA ------------
  Future<void> login() async {
    String codigo = codigoController.text.trim();
    String pass = passController.text.trim();

    // Validaciones vacías
    if (codigo.isEmpty) {
      return _error("Debes ingresar tu código.");
    }
    if (pass.isEmpty) {
      return _error("Debes ingresar tu contraseña.");
    }

    // Simulación de credenciales (luego lo conectas con tu API)
    Map<String, Map<String, String>> mockUsers = {
      "student": {"code": "STU001", "pass": "1234"},
      "teacher": {"code": "DOC001", "pass": "1234"},
      "parent": {"code": "PAR001", "pass": "1234"},
      "admin": {"code": "ADM001", "pass": "1234"},
    };

    final userData = mockUsers[widget.role];

    // Protege contra role desconocido (evita usar `!` sobre null)
    if (userData == null) {
      return _error("Tipo de usuario desconocido.");
    }

    final expectedCode = userData["code"] ?? "";
    final expectedPass = userData["pass"] ?? "";

    if (codigo != expectedCode || pass != expectedPass) {
      return _error("Credenciales incorrectas para este tipo de usuario.");
    }

    // Antes de navegar, registramos al usuario en el AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Construimos un 'email' que el AuthProvider entiende para asignar rol
    final simulatedEmail = '${widget.role}@demo.local';

    final success = await authProvider.login(simulatedEmail, pass);

    if (!success) {
      return _error(authProvider.errorMessage ?? 'Error al autenticar usuario.');
    }

    // Redirección REAL según el rol
    Widget page;
    switch (widget.role) {
      case "student":
        page = const StudentDashboard();
        break;
      case "teacher":
        page = const TeacherDashboard();
        break;
      case "parent":
        page = const ParentDashboard();
        break;
      case "admin":
        page = const AdminDashboard();
        break;
      default:
        page = const StudentDashboard();
    }

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f9fc),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ---------- TITULO ----------
              Center(
                child: Column(
                  children: [
                    Icon(icono, size: 50, color: const Color(0xFF0A4D68)),
                    const SizedBox(height: 10),
                    const Text(
                      "Accede a tu Panel",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A4D68),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Selecciona tu tipo de usuario para ingresar a la plataforma educativa",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, size: 20),
                    SizedBox(width: 6),
                    Text(
                      "Cambiar tipo de usuario",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------- CARD DEL ROL ----------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A4D68),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icono, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A4D68),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ---------- INPUT: CÓDIGO ----------
              Text(
                labelCodigo,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A4D68),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: codigoController,
                decoration: InputDecoration(
                  hintText: "USU-2025-001",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.blue.shade100),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------- INPUT: CONTRASEÑA ----------
              const Text(
                "Contraseña",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A4D68),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.blue.shade100),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ---------- BOTÓN LOGIN ----------
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A4D68),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: login,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Ingresar", style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
//asdaassadadsasdasads