import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final box = GetStorage(); // Acceder a los datos locales almacenados
  String name = 'No tiene aun';
  String email = 'No tiene aun';
  String phone = 'No tiene aun';
  String whatsapp = 'No tiene aun';

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Cargar los datos del usuario al iniciar la página
  }

  // Cargar los datos del usuario desde GetStorage
  void _loadUserData() {
    setState(() {
      name = box.read('name') ?? 'No tiene aun';
      email = box.read('email') ?? 'No tiene aun';
      phone = box.read('phone') ?? 'No tiene aun';
      whatsapp = box.read('whatsapp') ?? 'No tiene aun';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar el nombre del usuario
            ListTile(
              title: Text('Nombre'),
              subtitle: Text(name),
            ),
            Divider(),
            // Mostrar el correo del usuario
            ListTile(
              title: Text('Correo electrónico'),
              subtitle: Text(email),
            ),
            Divider(),
            // Mostrar el número de teléfono
            ListTile(
              title: Text('Teléfono'),
              subtitle: Text(phone),
            ),
            Divider(),
            // Mostrar el número de WhatsApp
            ListTile(
              title: Text('WhatsApp'),
              subtitle: Text(whatsapp),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}


