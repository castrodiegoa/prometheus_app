import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prometheus_app/services/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _service = ProfileService();

  final TextEditingController documentNumberController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isSaving = false;

  Future<void> loadUserData() async {
    try {
      Map<String, dynamic> userData = await _service.loadUserData();
      documentNumberController.text = userData['document'] ?? '';
      emailController.text = userData['email'] ?? '';
      phoneController.text = userData['phoneNumber'] ?? '';
      firstNameController.text = userData['firstName'] ?? '';
      lastNameController.text = userData['lastName'] ?? '';
    } catch (e) {
      Get.snackbar('Error', 'Error al cargar los datos del perfil');
    }
  }

  Future<void> updateUserData(BuildContext context) async {
    Map<String, dynamic> userData = await _service.loadUserData();

    String documentNumber = documentNumberController.text.trim();
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();

    String? validationMessage =
        _validateFields(documentNumber, email, phone, firstName, lastName);

    if (validationMessage != null) {
      Get.snackbar('Advertencia', validationMessage,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isSaving = true;
    update();

    try {
      await _service.updateUserData({
        'document': documentNumber,
        'email': email,
        'phoneNumber': phone,
        'firstName': firstName,
        'lastName': lastName,
      });
      Get.snackbar(
          'Éxito', 'Datos actualizados correctamente excepto el email.');
      if (userData['email'] != email) {
        Get.snackbar('Éxito',
            'Se ha enviado correo para verificar su email. Este será actualizado cuando lo verifique.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSaving = false;
      update();
    }
  }

  Future<void> changePassword(BuildContext context) async {
    String currentPassword = currentPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    String? validationMessage =
        _validatePasswordFields(currentPassword, newPassword, confirmPassword);

    if (validationMessage != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(validationMessage)));
      return;
    }

    try {
      await _service.changePassword(currentPassword, newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña cambiada correctamente.')));
      Navigator.of(context).pop();
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Error al cambiar la contraseña. Verifica la contraseña actual.')));
    }
  }

  String? _validateFields(String documentNumber, String email, String phone,
      String firstName, String lastName) {
    if (documentNumber.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      return 'Todos los campos son obligatorios';
    }

    if (documentNumber.length < 7 || documentNumber.length > 15) {
      return 'El número de documento debe tener entre 7 y 15 caracteres';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(documentNumber)) {
      return 'El número de documento debe contener solo caracteres numéricos';
    }

    if (firstName.length > 50) {
      return 'El nombre no puede tener más de 50 caracteres';
    }

    if (lastName.length > 50) {
      return 'El apellido no puede tener más de 50 caracteres';
    }

    if (email.length > 255) {
      return 'El correo no puede tener más de 255 caracteres';
    }

    if (phone.length < 10 || phone.length > 15) {
      return 'El número de teléfono debe tener entre 10 y 15 caracteres';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'El número de teléfono debe contener solo caracteres numéricos';
    }

    return null;
  }

  String? _validatePasswordFields(
      String currentPassword, String newPassword, String confirmPassword) {
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      return 'Todos los campos son obligatorios';
    }

    if (newPassword.length < 6 || newPassword.length > 255) {
      return 'La nueva contraseña debe tener entre 6 y 255 caracteres';
    }

    if (newPassword != confirmPassword) {
      return 'Las nuevas contraseñas no coinciden';
    }

    return null;
  }
}
