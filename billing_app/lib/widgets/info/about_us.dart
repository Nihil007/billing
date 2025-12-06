import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F1FF), // light purple background
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ---------------- TOP BLUE GRADIENT BAR ----------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 40),
            decoration: const BoxDecoration(
              color: Color(0xFFD69ADE),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Arrow + Title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),   
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "About Us",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "About Us\n\n"
                "This is billing application."
                " Developed by HIG Ai Automation",
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
