import 'package:prometheus_app/pages/home_page.dart';
import 'package:prometheus_app/pages/auth/login_page.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart'; // Importar GetStorage
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var isLoading = false.obs; // Observa si se está cargando una operación
  var user = Rxn<User>(); // Observa el estado del usuario

  final storage =
      GetStorage(); // Crear una instancia de GetStorage para almacenar las credenciales

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      this.user.value = user;
    });
    _autoLogin(); // Intentar login automático al iniciar
  }

  // Método para registrar el usuario y guardar datos en Firestore
  Future<void> register(String document, String firstName, String lastName,
      String phoneNumber, String email, String password) async {
    try {
      isLoading.value = true;
      User? newUser = await _firebaseService.registerWithEmail(
          document, firstName, lastName, phoneNumber, email, password);

      if (newUser != null) {
        user.value = newUser; // Usuario registrado exitosamente
        await _saveCredentials(email, password); // Guardar credenciales
        Get.offAll(() => const HomePage()); // Redirigir a la vista principal
      } else {
        Get.snackbar("Error", "No se pudo registrar el usuario");
      }
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error durante el registro");
    } finally {
      isLoading.value = false;
    }
  }

  // Método para iniciar sesión
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      User? loggedInUser =
          await _firebaseService.loginWithEmail(email, password);
      if (loggedInUser != null) {
        user.value = loggedInUser; // Usuario inició sesión exitosamente
        await _saveCredentials(email, password); // Guardar credenciales
        Get.offAll(() => const HomePage()); // Redirigir a la vista principal
      } else {
        Get.snackbar("Error", "No se pudo iniciar sesión");
      }
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error durante el inicio de sesión");
    } finally {
      isLoading.value = false;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _firebaseService.signOut();
    await _clearCredentials(); // Eliminar credenciales guardadas
    user.value = null; // Usuario ha cerrado sesión
    Get.snackbar("Sesión cerrada", "Hasta pronto");
    Get.offAll(() => LoginPage()); // Redirigir a la vista de login
  }

  // Guardar las credenciales de usuario usando GetStorage
  Future<void> _saveCredentials(String email, String password) async {
    storage.write('email', email);
    storage.write('password', password);
  }

  // Intentar login automático
  Future<void> _autoLogin() async {
    try {
      String? email = storage.read('email');
      String? password = storage.read('password');
      if (email != null && password != null) {
        isLoading.value = true;
        await login(email, password);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Eliminar las credenciales guardadas
  Future<void> _clearCredentials() async {
    storage.remove('email');
    storage.remove('password');
  }
}
