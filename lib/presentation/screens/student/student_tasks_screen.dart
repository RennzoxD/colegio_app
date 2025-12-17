import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentTasksScreen extends StatefulWidget {
  const StudentTasksScreen({super.key});

  @override
  State<StudentTasksScreen> createState() => _StudentTasksScreenState();
}

class _StudentTasksScreenState extends State<StudentTasksScreen> {
  final List<Map<String, dynamic>> materias = [
    {'nombre': 'Todas las Materias', 'icono': Icons.all_inclusive, 'color': Colors.grey},
    {'nombre': 'Historia Mundial', 'icono': Icons.history, 'color': Colors.red},
    {'nombre': 'Cloud Computing', 'icono': Icons.cloud, 'color': Colors.blue},
    {'nombre': 'Inteligencia de Negocios', 'icono': Icons.analytics, 'color': Colors.green},
    {'nombre': 'Inteligencia Artificial', 'icono': Icons.psychology, 'color': Colors.purple},
    {'nombre': 'Investigación III', 'icono': Icons.search, 'color': Colors.orange},
    {'nombre': 'Programación Avanzada', 'icono': Icons.code, 'color': Colors.indigo},
  ];

  final List<Map<String, dynamic>> estados = [
    {'nombre': 'Todos los Estados', 'color': Colors.grey},
    {'nombre': 'Pendiente', 'color': Colors.orange},
    {'nombre': 'Completada', 'color': Colors.green},
    {'nombre': 'Vencida', 'color': Colors.red},
    {'nombre': 'En Progreso', 'color': Colors.blue},
  ];

  final List<Task> tareas = [
    Task(
      id: 1,
      titulo: 'Historia Mundial',
      descripcion: 'Escribe un ensayo crítico sobre las causas y consecuencias de la Primera Guerra Mundial.',
      materia: 'Historia Mundial',
      estado: 'Vencida',
      prioridad: 'Alta',
      fechaEntrega: DateTime.now().subtract(const Duration(days: 2)),
      color: Colors.red,
      progreso: 0.6,
      icono: Icons.history,
    ),
    Task(
      id: 2,
      titulo: 'Cloud Computing',
      descripcion: 'Preparar una presentación sobre seguridad en entornos híbridos.',
      materia: 'Cloud Computing',
      estado: 'Completada',
      prioridad: 'Baja',
      fechaEntrega: DateTime.now().add(const Duration(days: 5)),
      color: Colors.purple,
      progreso: 1.0,
      icono: Icons.cloud,
    ),
    Task(
      id: 3,
      titulo: 'Inteligencia de Negocios',
      descripcion: 'Informe sobre proceso ETL y sus aplicaciones empresariales.',
      materia: 'Inteligencia de Negocios',
      estado: 'Pendiente',
      prioridad: 'Alta',
      fechaEntrega: DateTime.now().add(const Duration(days: 2)),
      color: Colors.orange,
      progreso: 0.3,
      icono: Icons.analytics,
    ),
    Task(
      id: 4,
      titulo: 'Programación Avanzada',
      descripcion: 'Sistema de gestión con base de datos relacional y ORM.',
      materia: 'Programación Avanzada',
      estado: 'En Progreso',
      prioridad: 'Media',
      fechaEntrega: DateTime.now().add(const Duration(days: 7)),
      color: Colors.deepPurple,
      progreso: 0.7,
      icono: Icons.code,
    ),
    Task(
      id: 5,
      titulo: 'Inteligencia Artificial',
      descripcion: 'Implementar un algoritmo de redes neuronales básico.',
      materia: 'Inteligencia Artificial',
      estado: 'Pendiente',
      prioridad: 'Alta',
      fechaEntrega: DateTime.now().add(const Duration(days: 1)),
      color: Colors.teal,
      progreso: 0.2,
      icono: Icons.psychology,
    ),
    Task(
      id: 6,
      titulo: 'Investigación III',
      descripcion: 'Revisión bibliográfica sobre métodos de investigación cuantitativa.',
      materia: 'Investigación III',
      estado: 'Completada',
      prioridad: 'Baja',
      fechaEntrega: DateTime.now().subtract(const Duration(days: 1)),
      color: Colors.amber,
      progreso: 1.0,
      icono: Icons.search,
    ),
  ];

  String materiaSeleccionada = 'Todas las Materias';
  String estadoSeleccionado = 'Todos los Estados';
  String busqueda = '';
  bool mostrarCalendario = false;
  DateTime? fechaSeleccionada;

  List<Task> get tareasFiltradas {
    return tareas.where((tarea) {
      final cumpleMateria = materiaSeleccionada == 'Todas las Materias' || 
                           tarea.materia == materiaSeleccionada;
      final cumpleEstado = estadoSeleccionado == 'Todos los Estados' || 
                          tarea.estado == estadoSeleccionado;
      final cumpleBusqueda = busqueda.isEmpty || 
                            tarea.titulo.toLowerCase().contains(busqueda.toLowerCase()) ||
                            tarea.descripcion.toLowerCase().contains(busqueda.toLowerCase());
      final cumpleFecha = fechaSeleccionada == null || 
                         tarea.fechaEntrega.day == fechaSeleccionada!.day;
      
      return cumpleMateria && cumpleEstado && cumpleBusqueda && cumpleFecha;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📚 Mis Tareas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              setState(() {
                mostrarCalendario = !mostrarCalendario;
              });
            },
            tooltip: 'Ver calendario',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportarTareas,
            tooltip: 'Exportar tareas',
          ),
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: _verResumen,
            tooltip: 'Resumen de tareas',
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'ordenar',
                child: Row(
                  children: [
                    Icon(Icons.sort, size: 20),
                    SizedBox(width: 8),
                    Text('Ordenar por'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'estadisticas',
                child: Row(
                  children: [
                    Icon(Icons.bar_chart, size: 20),
                    SizedBox(width: 8),
                    Text('Estadísticas'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'ordenar') {
                _mostrarOpcionesOrdenar();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (mostrarCalendario) _calendarioWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen estadístico
                  _resumenCards(),
                  
                  const SizedBox(height: 20),
                  
                  // Filtros
                  _filtrosWidget(),
                  
                  const SizedBox(height: 20),
                  
                  // Encabezado de tareas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📋 Tareas (${tareasFiltradas.length})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _indicadorEstado(),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Lista de tareas
                  _listaTareas(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarTarea,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Tarea'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  // ================= CALENDARIO =================
  Widget _calendarioWidget() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🗓️ Calendario de Tareas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      mostrarCalendario = false;
                      fechaSeleccionada = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now().add(const Duration(days: 60)),
              onDateChanged: (date) {
                setState(() {
                  fechaSeleccionada = date;
                });
              },
            ),
            if (fechaSeleccionada != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.blue, size: 12),
                    const SizedBox(width: 8),
                    Text(
                      'Filtrado por: ${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          fechaSeleccionada = null;
                        });
                      },
                      child: const Text('Limpiar filtro'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ================= RESUMEN =================
  Widget _resumenCards() {
    final totalTareas = tareas.length;
    final pendientes = tareas.where((t) => t.estado == 'Pendiente').length;
    final vencidas = tareas.where((t) => t.estado == 'Vencida').length;
    final altaPrioridad = tareas.where((t) => t.prioridad == 'Alta').length;
    final completadas = tareas.where((t) => t.estado == 'Completada').length;
    final porcentajeCompletadas = totalTareas > 0 ? (completadas / totalTareas * 100).round() : 0;

    return Column(
      children: [
        Row(
          children: [
            const Text(
              '📊 Resumen',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Chip(
              label: Text('${porcentajeCompletadas}% completado'),
              backgroundColor: Colors.blue.shade50,
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _ResumenCard(
              titulo: 'Total de Tareas',
              valor: totalTareas.toString(),
              icono: Icons.task,
              color: Colors.blue,
              subtitulo: '${completadas} completadas',
            ),
            _ResumenCard(
              titulo: 'Pendientes',
              valor: pendientes.toString(),
              icono: Icons.access_time,
              color: Colors.orange,
              subtitulo: 'Por completar',
            ),
            _ResumenCard(
              titulo: 'Vencidas',
              valor: vencidas.toString(),
              icono: Icons.warning,
              color: Colors.red,
              subtitulo: 'Requieren atención',
            ),
            _ResumenCard(
              titulo: 'Alta Prioridad',
              valor: altaPrioridad.toString(),
              icono: Icons.priority_high,
              color: Colors.purple,
              subtitulo: 'Urgentes',
            ),
          ],
        ),
      ],
    );
  }

  // ================= FILTROS =================
  Widget _filtrosWidget() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.filter_list, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Filtros',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (materiaSeleccionada != 'Todas las Materias' || 
                    estadoSeleccionado != 'Todos los Estados' ||
                    busqueda.isNotEmpty ||
                    fechaSeleccionada != null)
                  TextButton(
                    onPressed: _limpiarFiltros,
                    child: const Text('Limpiar filtros'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar tarea, materia o descripción...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) {
                setState(() {
                  busqueda = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Filtros en fila
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FiltroChip(
                    icono: Icons.subject,
                    label: materiaSeleccionada,
                    onTap: _mostrarSelectorMaterias,
                  ),
                  const SizedBox(width: 8),
                  _FiltroChip(
                    icono: _obtenerIconoEstado(estadoSeleccionado),
                    label: estadoSeleccionado,
                    color: _obtenerColorEstado(estadoSeleccionado),
                    onTap: _mostrarSelectorEstados,
                  ),
                  if (fechaSeleccionada != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FiltroChip(
                        icono: Icons.calendar_today,
                        label: '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}',
                        onTap: () {
                          setState(() {
                            fechaSeleccionada = null;
                          });
                        },
                        mostrarCerrar: true,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INDICADOR ESTADO =================
  Widget _indicadorEstado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${tareas.where((t) => t.estado == 'Completada').length}/${tareas.length}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ================= LISTA TAREAS =================
  Widget _listaTareas() {
    if (tareasFiltradas.isEmpty) {
      return Column(
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            '🎉 ¡No hay tareas con estos filtros!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            materiaSeleccionada != 'Todas las Materias' 
              ? 'Prueba a cambiar los filtros o selecciona otra materia'
              : '¡Todas tus tareas están completadas!',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tareasFiltradas.length,
      itemBuilder: (context, index) {
        final tarea = tareasFiltradas[index];
        return _TareaCard(tarea: tarea, onTap: () => _verDetalleTarea(tarea));
      },
    );
  }

  // ================= FUNCIONES =================
  void _mostrarSelectorMaterias() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccionar Materia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...materias.map((materia) {
                return ListTile(
                  leading: Icon(materia['icono'], color: materia['color']),
                  title: Text(materia['nombre']),
                  trailing: materiaSeleccionada == materia['nombre']
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() {
                      materiaSeleccionada = materia['nombre'];
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _mostrarSelectorEstados() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccionar Estado',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...estados.map((estado) {
                return ListTile(
                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: estado['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(estado['nombre']),
                  trailing: estadoSeleccionado == estado['nombre']
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() {
                      estadoSeleccionado = estado['nombre'];
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _limpiarFiltros() {
    setState(() {
      materiaSeleccionada = 'Todas las Materias';
      estadoSeleccionado = 'Todos los Estados';
      busqueda = '';
      fechaSeleccionada = null;
    });
  }

  void _exportarTareas() {
    // Implementar exportación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportando tareas...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _verResumen() {
    // Implementar vista de resumen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📈 Resumen de Tareas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Aquí iría un resumen detallado de todas las tareas'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }

  void _agregarTarea() {
    // Implementar agregar tarea
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('➕ Nueva Tarea'),
        content: const Text('Formulario para agregar nueva tarea'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _verDetalleTarea(Task tarea) {
    // Implementar vista detalle
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(tarea.icono, color: tarea.color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tarea.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(tarea.descripcion),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarOpcionesOrdenar() {
    // Implementar ordenamiento
  }

  IconData _obtenerIconoEstado(String estado) {
    switch (estado) {
      case 'Pendiente': return Icons.access_time;
      case 'Completada': return Icons.check_circle;
      case 'Vencida': return Icons.warning;
      case 'En Progreso': return Icons.autorenew;
      default: return Icons.filter_list;
    }
  }

  Color _obtenerColorEstado(String estado) {
    switch (estado) {
      case 'Pendiente': return Colors.orange;
      case 'Completada': return Colors.green;
      case 'Vencida': return Colors.red;
      case 'En Progreso': return Colors.blue;
      default: return Colors.grey;
    }
  }
}

// ================= MODELOS =================

class Task {
  final int id;
  final String titulo;
  final String descripcion;
  final String materia;
  final String estado;
  final String prioridad;
  final DateTime fechaEntrega;
  final Color color;
  final double progreso;
  final IconData icono;

  Task({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.materia,
    required this.estado,
    required this.prioridad,
    required this.fechaEntrega,
    required this.color,
    required this.progreso,
    required this.icono,
  });
}

// ================= COMPONENTES =================

class _ResumenCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;
  final String subtitulo;

  const _ResumenCard({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icono, color: color, size: 20),
                ),
                const Spacer(),
                Text(
                  valor,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subtitulo,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltroChip extends StatelessWidget {
  final IconData icono;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool mostrarCerrar;

  const _FiltroChip({
    required this.icono,
    required this.label,
    this.color = Colors.blue,
    required this.onTap,
    this.mostrarCerrar = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            if (mostrarCerrar) ...[
              const SizedBox(width: 4),
              Icon(Icons.close, size: 14, color: color),
            ],
          ],
        ),
      ),
    );
  }
}

class _TareaCard extends StatelessWidget {
  final Task tarea;
  final VoidCallback onTap;

  const _TareaCard({
    required this.tarea,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ahora = DateTime.now();
    final diferencia = tarea.fechaEntrega.difference(ahora);
    final diasRestantes = diferencia.inDays;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: tarea.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(tarea.icono, color: tarea.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tarea.titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tarea.materia,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _BadgeEstado(
                    estado: tarea.estado,
                    color: tarea.color,
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Descripción
              Text(
                tarea.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              
              const SizedBox(height: 16),
              
              // Barra de progreso
              LinearProgressIndicator(
                value: tarea.progreso,
                backgroundColor: Colors.grey.shade200,
                color: tarea.color,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              
              const SizedBox(height: 8),
              
              // Pie de tarjeta
              Row(
                children: [
                  // Prioridad
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _obtenerColorPrioridad(tarea.prioridad).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.flag,
                          size: 12,
                          color: _obtenerColorPrioridad(tarea.prioridad),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tarea.prioridad,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _obtenerColorPrioridad(tarea.prioridad),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Fecha
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatearFecha(tarea.fechaEntrega, diasRestantes),
                        style: TextStyle(
                          fontSize: 12,
                          color: _obtenerColorFecha(diasRestantes),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Acciones
                  IconButton(
                    icon: Icon(
                      tarea.estado == 'Completada' 
                          ? Icons.check_circle 
                          : Icons.check_circle_outline,
                      color: tarea.estado == 'Completada' 
                          ? Colors.green 
                          : Colors.grey.shade400,
                    ),
                    onPressed: () {},
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _obtenerColorPrioridad(String prioridad) {
    switch (prioridad) {
      case 'Alta': return Colors.red;
      case 'Media': return Colors.orange;
      case 'Baja': return Colors.green;
      default: return Colors.grey;
    }
  }
  
  String _formatearFecha(DateTime fecha, int diasRestantes) {
    final formatter = DateFormat('dd MMM');
    if (diasRestantes < 0) {
      return 'Vencida: ${formatter.format(fecha)}';
    } else if (diasRestantes == 0) {
      return 'Hoy ${DateFormat('h:mm a').format(fecha)}';
    } else if (diasRestantes == 1) {
      return 'Mañana ${DateFormat('h:mm a').format(fecha)}';
    } else {
      return 'En $diasRestantes días';
    }
  }
  
  Color _obtenerColorFecha(int diasRestantes) {
    if (diasRestantes < 0) return Colors.red;
    if (diasRestantes == 0) return Colors.orange;
    if (diasRestantes <= 2) return Colors.amber;
    return Colors.grey.shade600;
  }
}

class _BadgeEstado extends StatelessWidget {
  final String estado;
  final Color color;

  const _BadgeEstado({
    required this.estado,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _obtenerColorEstado(estado).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estado,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _obtenerColorEstado(estado),
        ),
      ),
    );
  }
  
  Color _obtenerColorEstado(String estado) {
    switch (estado) {
      case 'Pendiente': return Colors.orange;
      case 'Completada': return Colors.green;
      case 'Vencida': return Colors.red;
      case 'En Progreso': return Colors.blue;
      default: return Colors.grey;
    }
  }
}

// Añadir import para DateFormat
