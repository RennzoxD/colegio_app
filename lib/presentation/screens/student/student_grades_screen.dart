import 'package:flutter/material.dart';

class StudentGradesScreen extends StatelessWidget {
  const StudentGradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Notas'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Historial de Calificaciones',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _generalAverageCard(),
            const SizedBox(height: 16),
            const Text(
              'Detalle por Materia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _subjectTile(
              'Matemáticas',
              '1 Calificaciones',
              85,
              Colors.blue,
            ),
            _subjectTile(
              'Español',
              '2 Calificaciones',
              87,
              Colors.indigo,
            ),
            _subjectTile(
              'Ciencias',
              '2 Calificaciones',
              74,
              Colors.green,
            ),
            _subjectTile(
              'Historia',
              '1 Calificaciones',
              60,
              Colors.purple,
            ),
            _subjectTile(
              'Inglés',
              '1 Calificaciones',
              88,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  // ================= PROMEDIO GENERAL =================
  Widget _generalAverageCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Promedio General',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '77%',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: 0.77,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Basado en tus calificaciones registradas en todas las materias.',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MATERIAS =================
  Widget _subjectTile(
    String name,
    String count,
    int percent,
    Color chipColor,
  ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.menu_book),
        title: Text(name),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: chipColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count,
            style: TextStyle(color: chipColor, fontSize: 12),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$percent%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Ponderado',
                style: TextStyle(fontSize: 10),
              ),
            )
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
