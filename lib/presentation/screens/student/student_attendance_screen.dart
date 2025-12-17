import 'package:flutter/material.dart';

class StudentAttendanceScreen extends StatelessWidget {
  const StudentAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Asistencia'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Ver Historial Completo',
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
            _generalAttendanceCard(),
            const SizedBox(height: 20),
            const Text(
              'DETALLE POR ASIGNATURA',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _subjectAttendanceCard(
              subject: 'Matemática',
              teacher: 'Prof. López',
              present: 8,
              absent: 2,
              late: 1,
              justified: 1,
            ),
            _subjectAttendanceCard(
              subject: 'Comunicación',
              teacher: 'Prof. García',
              present: 9,
              absent: 1,
              late: 0,
              justified: 1,
            ),
            _subjectAttendanceCard(
              subject: 'Ciencia y Tecnología',
              teacher: 'Prof. Martín',
              present: 7,
              absent: 3,
              late: 1,
              justified: 1,
            ),
          ],
        ),
      ),
    );
  }

  // ================= ASISTENCIA GENERAL =================
  Widget _generalAttendanceCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Asistencia General',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '73%',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: 0.73,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Porcentaje de asistencia en todas las clases.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _AttendanceStat(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  label: 'Asistencias',
                  value: '8',
                ),
                _AttendanceStat(
                  icon: Icons.cancel,
                  color: Colors.red,
                  label: 'Faltas',
                  value: '2',
                ),
                _AttendanceStat(
                  icon: Icons.access_time,
                  color: Colors.orange,
                  label: 'Retardos',
                  value: '1',
                ),
                _AttendanceStat(
                  icon: Icons.info,
                  color: Colors.blue,
                  label: 'Justificados',
                  value: '1',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= DETALLE POR ASIGNATURA =================
  Widget _subjectAttendanceCard({
    required String subject,
    required String teacher,
    required int present,
    required int absent,
    required int late,
    required int justified,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.person, size: 18),
                const SizedBox(width: 6),
                Text(teacher),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _attendanceMini(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  value: present,
                ),
                _attendanceMini(
                  icon: Icons.cancel,
                  color: Colors.red,
                  value: absent,
                ),
                _attendanceMini(
                  icon: Icons.access_time,
                  color: Colors.orange,
                  value: late,
                ),
                _attendanceMini(
                  icon: Icons.info,
                  color: Colors.blue,
                  value: justified,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _attendanceMini({
    required IconData icon,
    required Color color,
    required int value,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ================= COMPONENTE =================

class _AttendanceStat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _AttendanceStat({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
