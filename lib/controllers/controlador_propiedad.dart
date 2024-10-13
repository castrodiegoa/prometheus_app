import 'package:get/get.dart';
import '../modelos/propiedad.dart';
import '../modelos/arrendatario.dart';

class PropiedadController extends GetxController {
  var propiedades = <Propiedad>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Inicializar algunas propiedades de ejemplo
    propiedades.addAll([
      Propiedad(
        imagen: 'https://example.com/propiedad1.jpg',
        alquilado: true,
        alquiler: true,
        importe: 1000.0,
        totalPersonas: 3,
        arrendatario: Arrendatario(id: '1', nombre: 'Juan Perez'),
        nombrePropiedad: 'Casa en la playa',
        numeroMesesAlquiler: 12,
      ),
      Propiedad(
        imagen: 'https://example.com/propiedad2.jpg',
        alquilado: true,
        alquiler: false,
        importe: 750.0,
        totalPersonas: 2,
        arrendatario: Arrendatario(id: '2', nombre: 'Ana Gómez'),
        nombrePropiedad: 'Departamento en la ciudad',
        numeroMesesAlquiler: 6,
      ),
    ]);
  }

  int propiedadesAlquiladas() {
    return propiedades.where((propiedad) => propiedad.alquilado).length;
  }

  int alquileresActivos() {
    return propiedades.where((propiedad) => propiedad.alquiler).length;
  }

  int inquilinosActivos() {
    return propiedades.fold(0, (suma, propiedad) => suma + (propiedad.totalPersonas ?? 0));
  }

  int propiedadesDisponibles() {
    return propiedades.where((propiedad) => !propiedad.alquiler).length;
  }
}
