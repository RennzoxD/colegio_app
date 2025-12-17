import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class StudentInfoScreen extends StatelessWidget {
  const StudentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Estudiante'),
      ),
      body: Consumer<AuthProvider>(
        builder: (_, auth, __) {
          final user = auth.currentUser;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _studentHeader(user),
                const SizedBox(height: 16),
                _contactInfoCard(),
                const SizedBox(height: 16),
                _academicInfoCard(),
                const SizedBox(height: 16),
                _actionsCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔹 CABECERA DEL ESTUDIANTE
  Widget _studentHeader(user) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 36,
              child: Icon(Icons.person, size: 42),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Juan Pérez Martínez',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Primaria · 1° A'),
                  const SizedBox(height: 4),
                  const Text('Código: 2024-0001'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 INFORMACIÓN DE CONTACTO
  Widget _contactInfoCard() {
    return Card(
      elevation: 2,
      child: Column(
        children: const [
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Teléfono'),
            subtitle: Text('999-999-999'),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Responsable Financiero'),
            subtitle: Text('Pedro Armas'),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.badge),
            title: Text('DNI R.F.'),
            subtitle: Text('12345678'),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Correo'),
            subtitle: Text('juan.perez@colegio.edu'),
          ),
        ],
      ),
    );
  }

  // 🔹 INFORMACIÓN ACADÉMICA
  Widget _academicInfoCard() {
    return Card(
      elevation: 2,
      child: Column(
        children: const [
          ListTile(
            leading: Icon(Icons.school),
            title: Text('Entidad'),
            subtitle: Text('Colegio ABC'),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.layers),
            title: Text('Nivel'),
            subtitle: Text('Primaria'),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.class_),
            title: Text('Grado / Sección'),
            subtitle: Text('1° A'),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Año / Trimestre'),
            subtitle: Text('2025 · T1'),
          ),
        ],
      ),
    );
  }

  // 🔹 ACCIONES
  Widget _actionsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.description),
                label: const Text('Ficha Académica'),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.message),
                label: const Text('Contactar'),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
