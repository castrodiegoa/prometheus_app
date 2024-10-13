import 'package:flutter/material.dart';


class RentasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rentals'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildTenantItem('José Guillén', '090412', '01/01/2023 - 12/31/2023'),
                _buildTenantItem('Fernando Alonso', '180223', '02/01/2023 - 01/31/2024'),
                _buildTenantItem('Marcia Ramírez', '090412', '03/01/2023 - 02/28/2024'),
                _buildTenantItem('Rosa Ospino', '201202', '04/01/2023 - 03/31/2024'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildTenantItem(String name, String id, String leaseDates) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(name[0]),
        backgroundColor: Colors.orange,
      ),
      title: Text(name),
      subtitle: Text('ID: $id\nLease: $leaseDates'),
    );
  }
}
