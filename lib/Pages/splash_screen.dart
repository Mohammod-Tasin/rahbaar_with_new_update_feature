// lib/Pages/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:rahbar_restarted/Pages/homepage.dart'; // homepage.dart-এর পাথ

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // ৩ সেকেন্ড অপেক্ষা করবে
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // ৩ সেকেন্ড পর Homepage-এ চলে যাবে এবং এই পেজটি রিমুভ করে দেবে
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // আপনার কাঙ্ক্ষিত সাদা ব্যাকগ্রাউন্ড
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // আপনার লোগো ফাইল (যেটি আইকনের জন্য ব্যবহার করেছিলেন)
            Image.asset(
              'assets/Logo.png', // <-- আপনার লোগো ফাইলের সঠিক পাথ দিন
              width: 150, // আপনার পছন্দমতো সাইজ দিন
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}