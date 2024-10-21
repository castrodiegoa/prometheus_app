import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prometheus_app/pages/profile_page.dart';
import 'package:prometheus_app/pages/buscar_page.dart';
import 'package:prometheus_app/pages/AdministrationEntitiesPage.dart';
import '../controllers/controlador_propiedad.dart';
import 'notifications_page.dart';
import '../controllers/auth_controller.dart';
import 'package:prometheus_app/pages/payments_plan_1.dart';

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

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePageContent(),
    BuscarPage(),
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
        title: const Text('Prometheus'),
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
  //final UsuarioController usuarioController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de registros recientes
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.insert_chart_outlined_rounded, size: 40),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Registros recientes: José Guillén ha eliminado un registro de propiedades con id 090417 el 10/05/2024.',
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
          const SizedBox(height: 20),
          // Sección de acceso rápido
          const Text('Acceso rápido',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdministrationEntitiesPage(
                        sectionTitle: 'Alquileres',
                        items: [
                          {
                            'title': 'Alquiler 90410',
                            'description': 'Desde 10/01/2023 Hasta 10/01/2024'
                          },
                          {
                            'title': 'Alquiler 90411',
                            'description': 'Desde 11/01/2023 Hasta 11/01/2024'
                          },
                        ],
                      ),
                    ),
                  );
                },
                child: _quickAccessButton('Alquileres', Icons.home_work),
              ),
              GestureDetector(
                onTap: () {
                  // Acción al presionar el botón de Inquilinos
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdministrationEntitiesPage(
                        sectionTitle: 'Inquilinos',
                        items: [
                          {
                            'title': 'Inquilino José Guillén',
                            'description': 'Contrato desde 10/01/2023'
                          },
                          {
                            'title': 'Inquilino María Ramírez',
                            'description': 'Contrato desde 12/01/2023'
                          },
                        ],
                      ),
                    ),
                  );
                },
                child: _quickAccessButton('Inquilinos', Icons.people),
              ),
              GestureDetector(
                onTap: () {
                  // Acción al presionar el botón de Pagos
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPlanManagement(),
                    ),
                  );
                },
                child: _quickAccessButton('Pagos', Icons.attach_money),
              ),
              GestureDetector(
                onTap: () {
                  // Acción al presionar el botón de Propiedades
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdministrationEntitiesPage(
                        sectionTitle: 'Propiedades',
                        items: [
                          {'title': 'Propiedad 90410'},
                          {'title': 'Propiedad 90411'},
                        ],
                      ),
                    ),
                  );
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
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(logs),
            ],
          ),
          TextButton(
            onPressed: () {},
            child:
                const Text('Ver más', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}
