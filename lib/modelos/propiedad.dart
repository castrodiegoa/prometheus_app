import 'arrendatario.dart'; // Importar Arrendatario

class Propiedad {
  String imagen;
  bool alquilado;
  bool alquiler;
  DateTime? fechaInicio;
  DateTime? fechaFinal;
  double importe;
  int? totalPersonas;
  Arrendatario? arrendatario;
  String? nombrePropiedad;
  int? numeroMesesAlquiler;

  Propiedad({
    required this.imagen,
    required this.alquilado,
    required this.alquiler,
    required this.importe,
    this.fechaInicio,
    this.fechaFinal,
    this.totalPersonas,
    this.arrendatario,
    this.nombrePropiedad,
    this.numeroMesesAlquiler,
  });
}
