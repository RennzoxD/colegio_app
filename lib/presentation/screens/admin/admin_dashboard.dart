import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel de Administración',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.admin_panel_settings,
                size: 100,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              Text(
                "¡Bienvenido Administrador!",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // Nombre del usuario
              Text(
                user.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              // Email
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 30),

              const Text(
                "Panel de Funciones",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 20),

              const Text(
                'Aquí podrás gestionar:\n'
                '• Usuarios y roles\n'
                '• Docentes y horarios\n'
                '• Estudiantes y asistencia\n'
                '• Comunicados generales\n'
                '• Configuración del sistema',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
