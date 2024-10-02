import 'package:get/get.dart';
import '../modelos/usuario.dart';

class UsuarioController extends GetxController {
  var usuario = Usuario(id: '', nombre: '', correo: '').obs;

  @override
  void onInit() {
    // Inicializar un usuario de ejemplo
    usuario.value = Usuario(id: '1', nombre: 'Carlos Martinez', correo: 'carlos@example.com');
    super.onInit();
  }
String obtenerNombreUsuario() {
  return usuario.value.nombre;
}
}
