import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser!;

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      // ------------------------------------------------------------
      //                        DRAWER (SIDEBAR)
      // ------------------------------------------------------------
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xff003366)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.school_rounded, color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Estudiante de 5to Secundaria",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            _drawerItem(icon: Icons.person, text: "Mi Información"),
            _drawerItem(icon: Icons.book, text: "Mis Materias"),
            _drawerItem(icon: Icons.task, text: "Mis Tareas"),
            _drawerItem(icon: Icons.grade, text: "Mis Notas"),
            _drawerItem(icon: Icons.event_available, text: "Mi Asistencia"),
            _drawerItem(icon: Icons.schedule, text: "Mi Horario"),
            _drawerItem(icon: Icons.show_chart, text: "Mi Progreso"),
            const Divider(),
            _drawerItem(icon: Icons.home_outlined, text: "Inicio"),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(12),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  side: const BorderSide(color: Color(0xff003366)),
                ),
                icon: const Icon(Icons.logout, color: Color(0xff003366)),
                label: const Text(
                  "Cerrar Sesión",
                  style: TextStyle(color: Color(0xff003366)),
                ),
                onPressed: () async {
                  await auth.logout();

                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),

      // ------------------------------------------------------------
      //                        APP BAR
      // ------------------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xff003366)),
        title: const Text(
          "Panel del Estudiante",
          style: TextStyle(
            color: Color(0xff003366),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: const Color(0xffffcc00),
            ),
            onPressed: () {},
            icon: const Icon(Icons.download, color: Colors.black),
            label: const Text(
              "Reporte",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),

      // ------------------------------------------------------------
      //                        BODY
      // ------------------------------------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Texto de bienvenida
            const Text(
              "Bienvenido",
              style: TextStyle(
                color: Color(0xff003366),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Usa el menú lateral para acceder a tus materias, tareas, notas y demás información académica.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            // Tarjeta de información
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Color(0xffd8e3f0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xffe3ecff),
                        child: Icon(Icons.person, color: Colors.blue[900], size: 32),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff003366),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: const TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Drawer Item Widget
  Widget _drawerItem({required IconData icon, required String text}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff003366)),
      title: Text(
        text,
        style: const TextStyle(color: Color(0xff003366), fontSize: 15),
      ),
      onTap: () {},
    );
  }
}
