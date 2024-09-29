import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Confirma tu cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Te hemos enviado un código a tu correo electrónico. Ingresa ese código para confirmar tu cuenta.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Ingresa el código',
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Borde inferior gris claro
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Borde gris claro para estado normal
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange, // Borde color naranja cuando está enfocado
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/create-password');  // Navegar a Create a New Password
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Continuar',
                style: TextStyle(fontSize: 18 , color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                // Acción para reenviar el código
              },
              child: Text(
                'Reenviar código',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

