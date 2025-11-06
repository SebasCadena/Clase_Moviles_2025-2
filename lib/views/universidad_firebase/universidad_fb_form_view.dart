import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/universidad_fb.dart';
import '../../services/universidad_service.dart';

class UniversidadFbFormView extends StatefulWidget {
  final String? id;

  const UniversidadFbFormView({super.key, this.id});

  @override
  State<UniversidadFbFormView> createState() => _UniversidadFbFormViewState();
}

class _UniversidadFbFormViewState extends State<UniversidadFbFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nitController = TextEditingController();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _paginaWebController = TextEditingController();
  bool _camposInicializados = false;

  Future<void> _guardar({String? docId}) async {
    if (_formKey.currentState!.validate()) {
      try {
        final universidad = UniversidadFb(
          id: docId ?? '',
          nit: _nitController.text.trim(),
          nombre: _nombreController.text.trim(),
          telefono: _telefonoController.text.trim(), 
          direccion: _direccionController.text.trim(), 
          pagina_web: _paginaWebController.text.trim(),
        );

        if (widget.id == null) {
          await UniversidadService.addUniversidad(universidad);
        } else {
          await UniversidadService.updateUniversidad(universidad);
        }

        if (mounted) {
          final colorScheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.id == null
                    ? 'Categoría creada exitosamente'
                    : 'Categoría actualizada exitosamente',
              ),
              backgroundColor: colorScheme.primary,
              duration: const Duration(seconds: 2),
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          final colorScheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar: $e'),
              backgroundColor: colorScheme.error,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  void _inicializarCampos(UniversidadFb universidad) {
    if (_camposInicializados) return;
    _nitController.text = universidad.nit;
    _nombreController.text = universidad.nombre;
    _telefonoController.text = universidad.telefono;
    _direccionController.text = universidad.direccion;
    _paginaWebController.text = universidad.pagina_web;
    _camposInicializados = true;
  }

  @override
  void dispose() {
    _nitController.dispose();
    _nombreController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _paginaWebController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool esNuevo = widget.id == null;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? 'Crear Categoría' : 'Editar Categoría'),
      ),
      body: esNuevo
          ? _buildFormulario(context, docId: null)
          : StreamBuilder<UniversidadFb?>(
              stream: UniversidadService.watchUniversidadById(widget.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar categoría',
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
                        const SizedBox(height: 24),
                        FilledButton.tonal(
                          onPressed: () => context.pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_off_outlined,
                          size: 60,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Categoría no encontrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.tonal(
                          onPressed: () => context.pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  );
                }

                final universidad = snapshot.data!;
                _inicializarCampos(universidad);
                return _buildFormulario(context, docId: universidad.id);
              },
            ),
    );
  }

  Widget _buildFormulario(BuildContext context, {String? docId}) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card con el formulario
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información básica',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nitController,
                      decoration: InputDecoration(
                        labelText: 'NIT',
                        hintText: 'Ingresa el NIT de la universidad',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El NIT es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Ingresa el nombre de la categoría',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es requerido';
                        }
                        if (value.trim().length < 3) {
                          return 'El nombre debe tener al menos 3 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telefonoController,
                      decoration: InputDecoration(
                        labelText: 'Teléfono',
                        hintText: 'Ingresa el teléfono',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El teléfono es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _direccionController,
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        hintText: 'Ingresa la dirección',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 2,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La dirección es requerida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _paginaWebController,
                      decoration: InputDecoration(
                        labelText: 'Página Web',
                        hintText: 'https://ejemplo.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.link),
                      ),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          // Validación básica de URL
                          if (!value.startsWith('http://') && 
                              !value.startsWith('https://')) {
                            return 'La URL debe comenzar con http:// o https://';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Botones de acción
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => _guardar(docId: docId),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Guardar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
