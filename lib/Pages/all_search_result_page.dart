// lib/Pages/AllSearchResultsPage.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rahbar_restarted/Pages/alumniDetailsPage.dart';
import 'package:rahbar_restarted/Pages/studentDetailsPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AllSearchResultsPage extends StatefulWidget {
  const AllSearchResultsPage({super.key});

  @override
  State<AllSearchResultsPage> createState() => _AllSearchResultsPageState();
}

class _AllSearchResultsPageState extends State<AllSearchResultsPage> {
  final TextEditingController _searchController = TextEditingController();

  // Supabase থেকে ডেটা আনার ফাংশন
  Future<List<Map<String, dynamic>>> _searchAll(String searchTerm) async {
    if (searchTerm.isEmpty) return [];
    try {
      final List<dynamic> data = await Supabase.instance.client
          .rpc('search_all', params: {'search_term': searchTerm});

      // ডেটা কাস্ট করা হচ্ছে
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error searching: $e');
      return [];
    }
  }

  // বিস্তারিত তথ্য আনার জন্য হেল্পার ফাংশন
  Future<void> _navigateToDetails(Map<String, dynamic> result, BuildContext context) async {
    final int id = result['id'];
    final String type = result['type'];

    try {
      if (type == 'Alumni') {
        // Alumni টেবিল থেকে পুরো ডেটা আনা
        final data = await Supabase.instance.client
            .from('CSV') // আপনার Alumni টেবিলের নাম
            .select('*')
            .eq('id', id)
            .single();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Alumnidetailspage(alumnus: data)),
        );
      } else {
        // Student টেবিল থেকে পুরো ডেটা আনা
        final data = await Supabase.instance.client
            .from('CS_CSV_2') // আপনার Student টেবিলের নাম
            .select('*')
            .eq('id', id)
            .single();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Studentdetailspage(student: data)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search All", style: GoogleFonts.ubuntu()),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TypeAheadField<Map<String, dynamic>>(
              controller: _searchController,
              suggestionsCallback: (pattern) async {
                return await _searchAll(pattern);
              },
              itemBuilder: (context, suggestion) {
                final name = suggestion['name'] ?? 'N/A';
                final dept = suggestion['department'] ?? '';
                final series = suggestion['series'] ?? '';
                final imageUrl = suggestion['image_url'] ?? '';
                final type = suggestion['type'] ?? '';

                return ListTile(
                  tileColor: Colors.white,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage: (imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute)
                        ? NetworkImage(imageUrl)
                        : null,
                    child: (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute)
                        ? Text(name.isNotEmpty ? name[0].toUpperCase() : '')
                        : null,
                  ),
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('$dept - $series'),
                  trailing: Chip(
                    label: Text(type, style: const TextStyle(fontSize: 10, color: Colors.white)),
                    backgroundColor: type == 'Alumni' ? Colors.teal : Colors.blueAccent,
                    padding: EdgeInsets.zero,
                  ),
                );
              },
              onSelected: (suggestion) {
                _navigateToDetails(suggestion, context);
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true, // পেজে ঢোকার সাথে সাথেই কিবোর্ড ওপেন হবে
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search Alumni or Students...',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}