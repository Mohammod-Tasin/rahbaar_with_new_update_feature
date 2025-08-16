import 'package:flutter/material.dart';
import 'package:rahbar_restarted/Pages/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bafzluusqzpzilkfbpkt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJhZnpsdXVzcXpwemlsa2ZicGt0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMwNDg1NDUsImV4cCI6MjA2ODYyNDU0NX0.vcZOLoXPJjSdNZGK1iU6ug7ANVBimctcgerpiGX1ick',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
      debugShowCheckedModeBanner: false,
      title: "Rahbaar",
    );
  }
}
