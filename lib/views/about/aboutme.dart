import 'package:flutter/material.dart';

class Aboutme extends StatelessWidget {
  const Aboutme({
    super.key,
    required this.parametro,
    required this.metodoNavegacion,
  });

  final String parametro;
  final String metodoNavegacion;

  final List<Map<String, dynamic>> menuItems = const [
    {'icon': Icons.person, 'title': 'Perfil', 'color': Colors.blue},
    {'icon': Icons.school, 'title': 'Educación', 'color': Colors.green},
    {'icon': Icons.work, 'title': 'Experiencia', 'color': Colors.orange},
    {'icon': Icons.code, 'title': 'Proyectos', 'color': Colors.purple},
    {'icon': Icons.email, 'title': 'Contacto', 'color': Colors.red},
    {'icon': Icons.download, 'title': 'CV', 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(parametro),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: item['color'].withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], size: 48, color: item['color']),
                          SizedBox(height: 8),
                          Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: item['color'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
