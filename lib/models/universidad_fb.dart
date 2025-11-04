class UniversidadFb {
  final String id;
  final String nit;
  final String nombre;
  final String direccion;
  final String telefono;
  final String pagina_web;

  UniversidadFb({
    required this.id,
    required this.nit,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.pagina_web,
  });

  factory UniversidadFb.fromMap(String id, Map<String, dynamic> data) {
    return UniversidadFb(
      id: id,
      nit: data['nit'] ?? '',
      nombre: data['nombre'] ?? '',
      direccion: data['direccion'] ?? '',
      telefono: data['telefono'] ?? '',
      pagina_web: data['pagina_web'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nit': nit,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'pagina_web': pagina_web,
    };
  }
}
