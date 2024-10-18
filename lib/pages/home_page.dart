import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prometheus_app/pages/payments_plan_1.dart';
import 'package:prometheus_app/pages/profile_page.dart';
import '../controllers/controlador_propiedad.dart';
import '../controllers/controlador_usuario.dart';
import 'rentas_pag.dart';
import 'notification_page.dart';
import '../controllers/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController =
      Get.find(); // Obtener el controlador de autenticación
  final PropiedadController propiedadController =
      Get.put(PropiedadController());
  final UsuarioController usuarioController = Get.put(UsuarioController());

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePageContent(),
    const PaymentPlanManagement(),
    NotificacionesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(usuarioController.obtenerNombreUsuario())),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authController.signOut(); // Llamar al método de cerrar sesión
            },
          ),
        ],
      ),
      body: _pages[
          _selectedIndex], // Cambia el cuerpo según la página seleccionada
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Cambia de página al hacer clic
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city_sharp),
            label: 'Gestionar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// Contenido de la página de inicio (antes PaginaInicio)
class HomePageContent extends StatelessWidget {
  final PropiedadController propiedadController = Get.find();
  final UsuarioController usuarioController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de registros recientes
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.insert_chart, size: 40),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Registros recientes: (user) ha (action) un registro de (entity name) con id (id entity) el (date).',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text('Ver todos los registros',
                      style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Sección de acceso rápido
          Text('Acceso rápido',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => RentasPage());
                },
                child: _quickAccessButton('Rentas', Icons.home_work),
              ),
              GestureDetector(
                onTap: () {
                  // Acción al presionar el botón de Inquilinos
                },
                child: _quickAccessButton('Inquilinos', Icons.people),
              ),
              GestureDetector(
                onTap: () {
                  // Acción al presionar el botón de Pagos
                },
                child: _quickAccessButton('Pagos', Icons.attach_money),
              ),
              GestureDetector(
                onTap: () {
                  // Acción al presionar el botón de Propiedades
                },
                child: _quickAccessButton('Propiedades', Icons.house),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Sección de relevantes
          const Text('Relevantes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          _relevantItem('Alquileres activos',
              '${propiedadController.alquileresActivos()}'),
          _relevantItem('Propiedades alquiladas',
              '${propiedadController.propiedadesAlquiladas()}'),
          _relevantItem('Inquilinos activos',
              '${propiedadController.inquilinosActivos()}'),
          _relevantItem('Propiedades disponibles',
              '${propiedadController.propiedadesDisponibles()}'),
        ],
      ),
    );
  }

  Widget _quickAccessButton(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, size: 30, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _relevantItem(String title, String logs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(logs),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: Text('Ver más', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}
