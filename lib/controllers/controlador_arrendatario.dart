import 'package:get/get.dart';
import '../modelos/arrendatario.dart';

class ArrendatarioController extends GetxController {
  var arrendatarios = <Arrendatario>[].obs;

  @override
  void onInit() {
    // Inicializar algunos arrendatarios de ejemplo
    arrendatarios.addAll([
      Arrendatario(id: '1', nombre: 'Juan Perez'),
      Arrendatario(id: '2', nombre: 'Ana Gómez'),
    ]);
    super.onInit();
  }
}
