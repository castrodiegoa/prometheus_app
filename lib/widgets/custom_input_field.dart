import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const CustomInputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: hintText,
            labelStyle:
                const TextStyle(color: Colors.grey), // Color de la etiqueta
            prefixIcon: Icon(icon, color: Colors.grey), // Color del ícono
            suffixIcon:
                value.text.isNotEmpty // Mostrar el ícono solo si hay texto
                    ? suffixIcon
                    : null,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey
                    .shade300, // Borde gris claro solo en la parte inferior
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color:
                    Colors.grey.shade300, // Borde gris claro para estado normal
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color:
                    Colors.orange, // Borde color naranja cuando está enfocado
              ),
            ),
          ),
        );
      },
    );
  }
}
