import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Revisar código do projeto',
      description: 'Verificar PR abertos',
      dueDate: DateTime.now(),
      priority: 'alta',
      status: 'pending',
    ),
    Task(
      id: '2',
      title: 'Atualizar documentação',
      description: 'Documentar novas APIs',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: 'média',
      status: 'pending',
    ),
    Task(
      id: '3',
      title: 'Preparar relatório mensal',
      description: 'Compilar métricas e KPIs',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      priority: 'alta',
      status: 'completed',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ativas'),
            Tab(text: 'Completadas'),
            Tab(text: 'Arquivadas'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TaskList(
            tasks: tasks.where((t) => t.status == 'pending').toList(),
          ),
          _TaskList(
            tasks: tasks.where((t) => t.status == 'completed').toList(),
          ),
          _TaskList(
            tasks: tasks.where((t) => t.status == 'archived').toList(),
          ),
        ],
      ),
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority; // 'alta', 'média', 'baixa'
  final String status; // 'pending', 'completed', 'archived'

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
  });
}

class _TaskList extends StatefulWidget {
  final List<Task> tasks;

  const _TaskList({required this.tasks});

  @override
  State<_TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<_TaskList> {
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.tasks);
  }

  @override
  Widget build(BuildContext context) {
    if (_tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_outlined,
              size: 48,
              color: const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma tarefa',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return _TaskCard(
          task: _tasks[index],
          onToggle: (completed) {
            setState(() {
              _tasks[index] = Task(
                id: _tasks[index].id,
                title: _tasks[index].title,
                description: _tasks[index].description,
                dueDate: _tasks[index].dueDate,
                priority: _tasks[index].priority,
                status: completed ? 'completed' : 'pending',
              );
            });
          },
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final Function(bool) onToggle;

  const _TaskCard({
    required this.task,
    required this.onToggle,
  });

  Color get priorityColor {
    switch (task.priority) {
      case 'alta':
        return const Color(0xFFEF4444);
      case 'média':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF10B981);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(task.status != 'completed'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF334155),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: priorityColor,
                  width: 2,
                ),
              ),
              child: task.status == 'completed'
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: priorityColor,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: task.status == 'completed'
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(task.dueDate),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                task.priority,
                style: TextStyle(
                  fontSize: 12,
                  color: priorityColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);
    final difference = dateDay.difference(today).inDays;

    if (difference == 0) {
      return 'Hoje';
    } else if (difference == 1) {
      return 'Amanhã';
    } else if (difference == -1) {
      return 'Ontem';
    } else if (difference < 0) {
      return 'Atrasado';
    } else {
      return 'Em ${difference}d';
    }
  }
}
