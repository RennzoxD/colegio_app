import 'package:flutter/material.dart';

class StudentSubjectsScreen extends StatelessWidget {
  const StudentSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Cursos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _filtersCard(),
            const SizedBox(height: 12),
            _periodCard(),
            const SizedBox(height: 12),
            _coursesList(),
            const SizedBox(height: 16),
            _scheduleCard(), // ¡Horario mejorado!
          ],
        ),
      ),
    );
  }

  // ================= FILTROS =================
  Widget _filtersCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _dropdown('Nivel', 'Primaria')),
                const SizedBox(width: 8),
                Expanded(child: _dropdown('Año', '2025')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _dropdown('Trimestre', 'T1')),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Aplicar'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // ================= PERIODO =================
  Widget _periodCard() {
    return Card(
      elevation: 2,
      child: ListTile(
        title: const Text(
          'Primaria — 2025',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {},
        ),
      ),
    );
  }

  // ================= LISTA DE CURSOS =================
  Widget _coursesList() {
    return Column(
      children: const [
        CourseCard(
          title: 'Comunicación',
          teacher: 'Prof. García',
          classroom: 'Aula P-3A',
        ),
        CourseCard(
          title: 'Matemática',
          teacher: 'Prof. López',
          classroom: 'Aula P-3A',
        ),
        CourseCard(
          title: 'Ciencia y Tecnología',
          teacher: 'Prof. Martín',
          classroom: 'Laboratorio',
        ),
        CourseCard(
          title: 'Inglés',
          teacher: 'Miss Smith',
          classroom: 'Aula de Idiomas',
        ),
        CourseCard(
          title: 'Arte y Cultura',
          teacher: 'Prof. Díaz',
          classroom: 'Sala de Arte',
        ),
        CourseCard(
          title: 'Educación Física',
          teacher: 'Prof. Vega',
          classroom: 'Cancha',
        ),
      ],
    );
  }

  // ================= HORARIO MEJORADO =================
  Widget _scheduleCard() {
    // Datos de ejemplo para el horario
    final List<ScheduleItem> scheduleItems = [
      ScheduleItem(
        day: 'Lunes',
        time: '08:00 - 09:30',
        subject: 'Matemática',
        teacher: 'Prof. López',
        classroom: 'Aula P-3A',
        color: Colors.blue[100]!,
      ),
      ScheduleItem(
        day: 'Lunes',
        time: '09:45 - 11:15',
        subject: 'Comunicación',
        teacher: 'Prof. García',
        classroom: 'Aula P-3A',
        color: Colors.green[100]!,
      ),
      ScheduleItem(
        day: 'Lunes',
        time: '11:30 - 13:00',
        subject: 'Ciencia y Tecnología',
        teacher: 'Prof. Martín',
        classroom: 'Laboratorio',
        color: Colors.orange[100]!,
      ),
      ScheduleItem(
        day: 'Martes',
        time: '08:00 - 09:30',
        subject: 'Inglés',
        teacher: 'Miss Smith',
        classroom: 'Aula de Idiomas',
        color: Colors.pink[100]!,
      ),
      ScheduleItem(
        day: 'Martes',
        time: '09:45 - 11:15',
        subject: 'Educación Física',
        teacher: 'Prof. Vega',
        classroom: 'Cancha',
        color: Colors.purple[100]!,
      ),
      ScheduleItem(
        day: 'Miércoles',
        time: '08:00 - 09:30',
        subject: 'Arte y Cultura',
        teacher: 'Prof. Díaz',
        classroom: 'Sala de Arte',
        color: Colors.yellow[100]!,
      ),
      ScheduleItem(
        day: 'Miércoles',
        time: '09:45 - 11:15',
        subject: 'Matemática',
        teacher: 'Prof. López',
        classroom: 'Aula P-3A',
        color: Colors.blue[100]!,
      ),
    ];

    // Agrupar por día
    final Map<String, List<ScheduleItem>> scheduleByDay = {};
    for (var item in scheduleItems) {
      scheduleByDay.putIfAbsent(item.day, () => []).add(item);
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📅 Horario de Clases',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: const Text('Semana actual'),
                  backgroundColor: Colors.blue[50],
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              '3° Primaria - Trimestre 1',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // Días de la semana
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  _DayChip(day: 'Lun', isActive: true),
                  SizedBox(width: 8),
                  _DayChip(day: 'Mar', isActive: false),
                  SizedBox(width: 8),
                  _DayChip(day: 'Mié', isActive: false),
                  SizedBox(width: 8),
                  _DayChip(day: 'Jue', isActive: false),
                  SizedBox(width: 8),
                  _DayChip(day: 'Vie', isActive: false),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de clases por día
            ...scheduleByDay.entries.map((entry) {
              return _DayScheduleSection(
                day: entry.key,
                items: entry.value,
              );
            }).toList(),
            
            const SizedBox(height: 8),
            
            // Leyenda
            _ScheduleLegend(),
          ],
        ),
      ),
    );
  }

  // ================= DROPDOWN SIMULADO =================
  Widget _dropdown(String label, String value) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: Text(value),
    );
  }
}

// =======================================================
// ================= COMPONENTES ==========================
// =======================================================

class CourseCard extends StatelessWidget {
  final String title;
  final String teacher;
  final String classroom;

  const CourseCard({
    super.key,
    required this.title,
    required this.teacher,
    required this.classroom,
  });

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text('T1'),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () {},
                )
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _MiniIcon(icon: Icons.description, text: 'Nota'),
                _MiniIcon(icon: Icons.star, text: 'Conducta'),
                _MiniIcon(icon: Icons.trending_up, text: 'Progreso'),
                _MiniIcon(icon: Icons.check_circle, text: 'Asistencia'),
              ],
            ),
            const SizedBox(height: 8),
            Text('Docente: $teacher'),
            Text('3° Primaria'),
            Text('Ambiente: $classroom'),
          ],
        ),
      ),
    );
  }
}

class _MiniIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniIcon({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// ================= NUEVOS COMPONENTES DE HORARIO =================

class ScheduleItem {
  final String day;
  final String time;
  final String subject;
  final String teacher;
  final String classroom;
  final Color color;

  ScheduleItem({
    required this.day,
    required this.time,
    required this.subject,
    required this.teacher,
    required this.classroom,
    required this.color,
  });
}

class _DayChip extends StatelessWidget {
  final String day;
  final bool isActive;

  const _DayChip({required this.day, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DayScheduleSection extends StatelessWidget {
  final String day;
  final List<ScheduleItem> items;

  const _DayScheduleSection({
    required this.day,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 12),
          child: Text(
            day,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        ...items.map((item) => _ScheduleItemCard(item: item)).toList(),
      ],
    );
  }
}

class _ScheduleItemCard extends StatelessWidget {
  final ScheduleItem item;

  const _ScheduleItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: item.color,
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hora
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.time,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Información de la clase
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.subject,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.teacher,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '📍 ${item.classroom}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Indicador de estado
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getStatusColor(item.time),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(String time) {
    final now = DateTime.now();
    final currentHour = now.hour;
    
    // Ejemplo simple: comparar con hora actual
    if (time.contains('08:00') && currentHour >= 8 && currentHour < 9) {
      return Colors.green; // En curso
    } else if (time.contains('09:45') && currentHour >= 9 && currentHour < 11) {
      return Colors.green; // En curso
    } else if (time.contains('08:00') && currentHour < 8) {
      return Colors.blue; // Próxima
    } else {
      return Colors.grey; // Pasada
    }
  }
}

class _ScheduleLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: Colors.green, text: 'En curso'),
        const SizedBox(width: 16),
        _LegendItem(color: Colors.blue, text: 'Próxima'),
        const SizedBox(width: 16),
        _LegendItem(color: Colors.grey, text: 'Pasada'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}