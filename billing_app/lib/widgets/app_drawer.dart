import 'package:flutter/material.dart';
import 'package:billing_app/widgets/info/about_us.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool infoExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      child: Column(
        children: [
          // ---------------- HEADER ----------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            color: const Color(0xFFD69ADE),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(height: 10),
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Bill is proof of what you own",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // MAIN MENU LIST
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _menuTile(Icons.category, "Categories", () {}),
                _menuTile(Icons.post_add, "My Post", () {}),
                _menuTile(Icons.help_outline, "FAQ", () {}),

                // ---------------- INFO EXPANDABLE ----------------
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Info"),
                  trailing: Icon(
                    infoExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onTap: () {
                    setState(() => infoExpanded = !infoExpanded);
                  },
                ),

                if (infoExpanded) ...[
                  _subMenu("Privacy Policy"),
                  _subMenu("Terms of Service"),
                  _subMenu(
                    "About Us",
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutUsScreen(),
                        ),
                      );
                    },
                  ),
                  _subMenu("Shipping Policy"),
                ],

                const Divider(height: 20),

                _menuTile(Icons.contact_page, "Contact Us", () {}),
                _menuTile(Icons.help_center, "Help & Support", () {}),
                _menuTile(Icons.settings, "Settings", () {}),
                _menuTile(Icons.logout, "Login", () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- REUSABLE MENU TILE ----------------
  Widget _menuTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  // ---------------- SUBMENU STYLE (accepts optional onTap) ----------------
  Widget _subMenu(String title, [VoidCallback? onTap]) {
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: ListTile(
        leading: const Icon(Icons.shield_outlined, size: 20),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        onTap: onTap,
      ),
    );
  }
}
