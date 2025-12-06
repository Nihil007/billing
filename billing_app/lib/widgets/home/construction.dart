import 'package:flutter/material.dart';

class Construction extends StatelessWidget {
  final String categoryTitle;

  const Construction({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F1FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TOP PURPLE BAR ----------------
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 40),
            decoration: const BoxDecoration(
              color: Color(0xFFD69ADE),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child:
                      const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 10),
                Text(
                  categoryTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------------- CONTENT CARD ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "This section is under development.\n\n"
                "Construction category content will be added here.\n\n"
                "Developed by HIG Ai Automation",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
