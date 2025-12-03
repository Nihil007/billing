import 'package:flutter/material.dart';
import 'package:billing_app/widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState(); 
}
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

String _selectedState = 'Tamil Nadu';

final List<String> _states = [
  'Andhra Pradesh',
  'Arunachal Pradesh',
  'Assam',
  'Bihar',
  'Chhattisgarh',
  'Goa',
  'Gujarat',
  'Haryana',
  'Himachal Pradesh',
  'Jharkhand',
  'Karnataka',
  'Kerala',
  'Madhya Pradesh',
  'Maharashtra',
  'Manipur',
  'Meghalaya',
  'Mizoram',
  'Nagaland',
  'Odisha',
  'Punjab',
  'Rajasthan',
  'Sikkim',
  'Tamil Nadu',
  'Telangana',
  'Tripura',
  'Uttar Pradesh',
  'Uttarakhand',
  'West Bengal',
  // Union Territories
  'Andaman & Nicobar Islands',
  'Chandigarh',
  'Dadra & Nagar Haveli and Daman & Diu',
  'Delhi',
  'Jammu & Kashmir',
  'Ladakh',
  'Lakshadweep',
  'Puducherry',
];


class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Map<String, String>> categories = [
    {'title': 'General', 'asset': 'images/bill.png'},
    {'title': 'Construction', 'asset': 'images/construction.png'},
    {'title': 'Supermarket', 'asset': 'images/supermart.png'},
    {'title': 'Traveler', 'asset': 'images/traveler.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double iconRadius = width * 0.08; // Responsive radius


    return Scaffold(
      key: _scaffoldKey, 
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Location + Notification
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedState,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                        items: _states.map((state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          if (newVal == null) return;
                          setState(() {
                            _selectedState = newVal;
                          });
                        },
                      ),
                    ),
                  ),
                  const Icon(Icons.notifications_none)
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search products...",
                        ),
                      ),
                    ),
                    Icon(Icons.search),
                  ],
                ),
              ),
            ),

            // Banner
            Container(
              width: double.infinity,
              height: width * 0.36,
              margin: const EdgeInsets.only(top: 14),
              child: Image.asset(
                "images/billing_software.jpg",
                fit: BoxFit.cover,
              ),
            ),

            Container(height: 4, color: Colors.blue.shade900),

            // Categories
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Container(
                            width: iconRadius * 2,
                            height: iconRadius * 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFD69ADE), // background color
                            ),
                            padding: EdgeInsets.all(iconRadius * 0.28), // adjust as needed
                            child: Image.asset(
                              cat['asset']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cat['title']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const Expanded(child: SizedBox()), // Remaining white space
          ],
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
          onTap: (i) {
              if (i == 4) {
                _scaffoldKey.currentState?.openDrawer();  // 👈 opens sidebar
              } else {
                setState(() => _selectedIndex = i);
              }
            },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: "Sell"),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: "Status"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
    );
  }
}
