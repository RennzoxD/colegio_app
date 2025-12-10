import 'package:flutter/material.dart';
import '../auth/login_role_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 60, color: Colors.blue),

                  const SizedBox(height: 10),

                  const Text(
                    "Accede a tu Panel",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Selecciona tu tipo de usuario para ingresar",
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),

                  const SizedBox(height: 25),

                  // ROLES
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _roleButton(
                        context,
                        icon: Icons.group,
                        label: "Padres/Tutores",
                        description:
                            "Consulta la información académica de tu hijo",
                        color: const Color(0xFFE3F2FD),
                        role: "parent",
                      ),
                      _roleButton(
                        context,
                        icon: Icons.school,
                        label: "Estudiantes",
                        description: "Revisa tus notas, tareas y avances",
                        color: const Color(0xFFFFF3E0),
                        role: "student",
                      ),
                      _roleButton(
                        context,
                        icon: Icons.menu_book,
                        label: "Docentes",
                        description:
                            "Gestiona notas, tareas y observaciones",
                        color: const Color(0xFFF3E5F5),
                        role: "teacher",
                      ),
                      _roleButton(
                        context,
                        icon: Icons.admin_panel_settings,
                        label: "Administrador",
                        description: "Administra el sistema académico",
                        color: const Color(0xFFFFEBEE),
                        role: "admin",
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  _firstTimeCard(),

                  const SizedBox(height: 15),

                  const Text(
                    "UEP Técnico Humanístico Ebenezer - Educa para esta vida y la eternidad",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----- WIDGET REUSABLE PARA BOTÓN -----
  Widget _roleButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required String role,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoginRoleScreen(role: role),
          ),
        );
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            // Icono dentro del fondo de color
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 35, color: Colors.blue.shade700),
            ),

            const SizedBox(height: 10),

            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----- TARJETA INFORMATIVA -----
  Widget _firstTimeCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Text(
            "¿Primera vez en la plataforma?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Si es tu primera vez accediendo o tienes problemas con tus credenciales, "
            "contacta al administrador de tu institución educativa.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {},
                child: const Text("Soporte Técnico"),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                child: const Text("Guía de Usuario"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
