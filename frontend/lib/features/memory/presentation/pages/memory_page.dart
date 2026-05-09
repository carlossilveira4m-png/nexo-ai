import 'package:flutter/material.dart';

class MemoryPage extends StatefulWidget {
  const MemoryPage({Key? key}) : super(key: key);

  @override
  State<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  final List<Memory> memories = [
    Memory(
      id: '1',
      type: 'link',
      title: 'Flutter Best Practices',
      content: 'https://flutter.dev/docs/best-practices',
      tags: ['flutter', 'dev'],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Memory(
      id: '2',
      type: 'idea',
      title: 'Implementar dark mode no app',
      content: 'Adicionar tema escuro com transição suave',
      tags: ['ui', 'design'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Memory(
      id: '3',
      type: 'note',
      title: 'Reunião com time',
      content: 'Discussão sobre novo roadmap do projeto',
      tags: ['meeting', 'work'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Memórias'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: memories.length,
        itemBuilder: (context, index) {
          return _MemoryCard(memory: memories[index]);
        },
      ),
    );
  }
}

class Memory {
  final String id;
  final String type; // 'link', 'idea', 'note', 'text', 'file'
  final String title;
  final String content;
  final List<String> tags;
  final DateTime createdAt;

  Memory({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.tags,
    required this.createdAt,
  });
}

class _MemoryCard extends StatelessWidget {
  final Memory memory;

  const _MemoryCard({required this.memory});

  IconData get typeIcon {
    switch (memory.type) {
      case 'link':
        return Icons.link;
      case 'idea':
        return Icons.lightbulb_outline;
      case 'note':
        return Icons.note_outlined;
      case 'text':
        return Icons.description_outlined;
      default:
        return Icons.folder_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF334155),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                typeIcon,
                color: const Color(0xFF6366F1),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  memory.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text('Editar'),
                  ),
                  const PopupMenuItem(
                    child: Text('Deletar'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            memory.content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFCBD5E1),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 6,
                children: memory.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Text(
                _formatDate(memory.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoje';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d atrás';
    } else {
      return '${(difference.inDays / 7).floor()}s atrás';
    }
  }
}
