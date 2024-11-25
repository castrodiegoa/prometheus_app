import 'package:flutter/material.dart';
import 'package:prometheus_app/controllers/rent_controller.dart';
import 'package:prometheus_app/models/rent_model.dart';
import 'package:prometheus_app/pages/administration/rents/new_rent_page.dart';
import 'package:prometheus_app/pages/administration/rents/edit_rent_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RentsManagementPage extends StatefulWidget {
  @override
  _RentsManagementPageState createState() => _RentsManagementPageState();
}

class _RentsManagementPageState extends State<RentsManagementPage> {
  final RentController _rentController = RentController();
  List<Rent> _rents = [];
  List<Rent> _filteredRents = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProperties);
    _loadRents();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProperties);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRents() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      _rents = await _rentController.getRents(currentUser.uid);
      setState(() {
        _filteredRents = _rents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar las rentas: ${e.toString()}';
      });
    }
  }

  void _filterProperties() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRents = _rents
          .where((property) =>
              property.id.toLowerCase().contains(query) ||
              (property.createdAt?.toString() ?? '')
                  .toLowerCase()
                  .contains(query))
          .toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filteredRents = _rents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Alquileres',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar alquiler',
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: _clearSearch,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_filteredRents.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No hay alquileres que coincidan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredRents.length,
                  itemBuilder: (context, index) {
                    final property = _filteredRents[index];
                    return SectionCard(
                      icon: Icons.person_outline,
                      title: property.id,
                      description:
                          'Registrada el ${property.createdAt?.toString() ?? 'N/A'}',
                      backgroundColor: Colors.green.shade100,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditRentPage(
                              entityId: property.id.toString(),
                              entityData: property.toFirestore(),
                            ),
                          ),
                        ).then((value) {
                          // Recargar los datos si se editó la propiedad
                          _loadRents();
                        });
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a NewRentPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewRentPage(),
                  ),
                ).then((value) {
                  // Este código se ejecutará cuando regrese a esta página desde NewRentPage.
                  _loadRents(); // Recargar los datos cuando regreses a la página anterior
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Center(
                child: Text(
                  'Nuevo alquiler',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color backgroundColor;
  final VoidCallback onTap;

  SectionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: backgroundColor,
          child: Icon(icon, color: Colors.green.shade400, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(description),
        onTap: onTap,
      ),
    );
  }
}
