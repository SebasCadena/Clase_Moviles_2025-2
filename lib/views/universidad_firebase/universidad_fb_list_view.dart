import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talleres/models/universidad_fb.dart';
import 'package:talleres/services/universidad_service.dart';


import '../../widgets/custom_drawer.dart';

class UniversidadFbListView extends StatelessWidget {
  const UniversidadFbListView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades Disponibles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gestiona tus universidades en tiempo real'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: StreamBuilder<List<UniversidadFb>>(
        stream: UniversidadService.watchUniversidades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar universidades',
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final universidades = snapshot.data ?? [];

          if (universidades.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 80,
                    color: colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay universidades',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca el botón + para crear una',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: universidades.length,
              itemBuilder: (context, index) {
                final uni = universidades[index];
                return _UniversidadCard(universidad: uni, index: index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/universidades/create'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
    );
  }
}

class _UniversidadCard extends StatelessWidget {
  final UniversidadFb universidad;
  final int index;

  const _UniversidadCard({required this.universidad, required this.index});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/universidades/edit/${universidad.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      universidad.nombre,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      universidad.telefono.isEmpty
                          ? 'Sin teléfono'
                          : universidad.telefono,
                      style: TextStyle(
                        fontSize: 13,
                        color: universidad.telefono.isEmpty
                            ? colorScheme.onSurfaceVariant.withOpacity(0.5)
                            : colorScheme.onSurfaceVariant,
                        fontStyle: universidad.telefono.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Botón de acción
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: colorScheme.error.withOpacity(0.8),
                  size: 20,
                ),
                tooltip: 'Eliminar',
                visualDensity: VisualDensity.compact,
                onPressed: () => _showDeleteDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Estás seguro de eliminar esta universidad?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    universidad.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (universidad.telefono.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      universidad.telefono,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(fontSize: 12, color: colorScheme.error),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      try {
        await UniversidadService.deleteUniversidad(universidad.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Universidad "${universidad.nombre}" eliminada'),
              backgroundColor: colorScheme.primary,
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: colorScheme.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }
}
