import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prometheus_app/pages/administration/properties/properties_management_page.dart';
import 'package:prometheus_app/pages/administration/rents/rents_management_page.dart';
import 'package:prometheus_app/pages/administration/tenants/tenant_management_page.dart';
import 'package:prometheus_app/pages/profile/profile_page.dart';
import 'package:prometheus_app/pages/administration/administration_page.dart';
import 'package:prometheus_app/pages/notifications/notifications_page.dart';
import 'package:prometheus_app/controllers/auth_controller.dart';
import 'package:prometheus_app/pages/administration/payments/payments_management_page.dart';

// Constants
class AppConstants {
  static const String appTitle = 'Prometheus';
  static const double defaultPadding = 16.0;
  static const double defaultSpacing = 20.0;
  static const double smallSpacing = 10.0;
  static const double iconSize = 30.0;
  static const double avatarRadius = 30.0;
}

// Models
class RelevantItem {
  final String title;
  final String count;
  final VoidCallback? onTapMore;

  const RelevantItem({
    required this.title,
    required this.count,
    this.onTapMore,
  });
}

class QuickAccessItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const QuickAccessItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = Get.find();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const BuscarPage(),
    const NotificacionesPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppConstants.appTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _authController.signOut,
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      items: const [
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
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInformativeCards(),
          const SizedBox(height: AppConstants.defaultSpacing),
          _buildQuickAccessSection(context),
        ],
      ),
    );
  }

  Widget _buildInformativeCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Información Importante',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: AppConstants.smallSpacing),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: const Text(
              'Mantén actualizados los datos de tus propiedades para facilitar la gestión de inquilinos y pagos.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.smallSpacing),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: const Text(
              'Recuerda revisar las notificaciones regularmente para estar al tanto de pagos pendientes.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.smallSpacing),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: const Text(
              'Configura alertas para vencimientos y nuevos alquileres desde el panel de administración.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessSection(BuildContext context) {
    final List<QuickAccessItem> quickAccessItems = [
      QuickAccessItem(
        title: 'Alquileres',
        icon: Icons.home_work,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentsManagementPage(),
          ),
        ),
      ),
      QuickAccessItem(
        title: 'Inquilinos',
        icon: Icons.people,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TenantsManagementPage(),
          ),
        ),
      ),
      QuickAccessItem(
        title: 'Pagos',
        icon: Icons.attach_money,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentPlanManagement(),
          ),
        ),
      ),
      QuickAccessItem(
        title: 'Propiedades',
        icon: Icons.house,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertiesManagementPage(),
          ),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acceso rápido',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: AppConstants.smallSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: quickAccessItems
              .map((item) => _buildQuickAccessButton(item))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildQuickAccessButton(QuickAccessItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: AppConstants.avatarRadius,
            backgroundColor: Colors.grey.shade200,
            child: Icon(item.icon,
                size: AppConstants.iconSize, color: Colors.black),
          ),
          const SizedBox(height: 6),
          Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}


