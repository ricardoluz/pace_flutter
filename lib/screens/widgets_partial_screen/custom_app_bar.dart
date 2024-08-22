import 'package:flutter/material.dart';
import '/services/authentication_service.dart';

customAppBar(String title){
  // DateTime currentDay = DateTime.now();
  return AppBar(
    title: Text(title,style: const TextStyle(fontSize: 24.0),
      // "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
    ),
    actions: [
      IconButton(
        onPressed: () {
          // refresh();
        },
        icon: const Icon(
          Icons.refresh,
        ),
      ),
    ],
  );
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              logout();
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'home');
            },
          )
        ],
      ),
    );
  }
}