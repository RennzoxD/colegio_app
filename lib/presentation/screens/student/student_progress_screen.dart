import 'package:flutter/material.dart';

class StudentProgressScreen extends StatelessWidget {
  const StudentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF), // Fondo suave de la imagen
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Mi Progreso Académico",
          style: TextStyle(color: Color(0xFF0D1B3E), fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Ver Historial"),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Un resumen de tu desempeño y avance en todas tus materias. ¡Sigue así!",
              style: TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // --- TARJETA PROGRESO GENERAL ---
            _buildGeneralProgressCard(),

            const SizedBox(height: 16),

            // --- GRID DE ESTADÍSTICAS RÁPIDAS (Tareas) ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.1,
              children: [
                _buildStatMiniCard("Total Tareas", "7", Icons.book_outlined, Colors.black87),
                _buildStatMiniCard("Completadas", "3", Icons.check_circle_outline, Colors.green),
                _buildStatMiniCard("Pendientes", "2", Icons.access_time, Colors.blue),
                _buildStatMiniCard("Atrasadas", "2", Icons.error_outline, Colors.red),
              ],
            ),

            const SizedBox(height: 25),
            const Text(
              "Progreso por Materia",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E)),
            ),
            const SizedBox(height: 15),

            // --- LISTA DE MATERIAS ---
            _buildSubjectCard("Matemáticas", "Prof. García", 1.0, "100%", "1", "0", "0", "85/100", Colors.purple[50]!),
            _buildSubjectCard("Español", "Prof. López", 0.5, "50%", "1", "0", "1", "95/100", Colors.blue[50]!),
            _buildSubjectCard("Ciencias", "Prof. Martín", 0.5, "50%", "1", "1", "0", "78/100", Colors.green[50]!),
          ],
        ),
      ),
    );
  }

  // Widget para la tarjeta grande de progreso 43%
  Widget _buildGeneralProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Progreso General", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(Icons.emoji_events_outlined, color: Colors.orangeAccent),
            ],
          ),
          const SizedBox(height: 15),
          const Text("43%", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E))),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.43,
            backgroundColor: Colors.grey[200],
            color: Colors.blueAccent,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 10),
          const Text("Basado en tus tareas completadas. ¡Un gran esfuerzo!", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // Widget para las 4 tarjetitas de arriba
  Widget _buildStatMiniCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          Icon(icon, size: 20, color: color.withOpacity(0.7)),
        ],
      ),
    );
  }

  // Widget para cada materia (Progreso por Materia)
  Widget _buildSubjectCard(String name, String prof, double prog, String percent, String comp, String pend, String venc, String grade, Color tagColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [const Icon(Icons.book_outlined, size: 18), const SizedBox(width: 8), Text(name, style: const TextStyle(fontWeight: FontWeight.bold))]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(12)),
                child: const Text("Tareas", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          Text(prof, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Progreso en $name", style: const TextStyle(fontSize: 11, color: Colors.blue)),
              Text(percent, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(value: prog, minHeight: 6, borderRadius: BorderRadius.circular(5)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoMini(comp, "Completas", Colors.green),
              _infoMini(pend, "Pendientes", Colors.blue),
              _infoMini(venc, "Vencidas", Colors.red),
            ],
          ),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Promedio Calificaciones:", style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
                child: Text(grade, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _infoMini(String val, String label, Color col) {
    return Column(
      children: [
        Icon(Icons.check_circle_outline, size: 16, color: col),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ],
    );
  }
}