// currentStudentPage.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rahbar_restarted/Pages/studentDetailsPage.dart'; // Your file path
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:substring_highlight/substring_highlight.dart';

class Currentstudentpage extends StatefulWidget {
  const Currentstudentpage({super.key});

  @override
  State<Currentstudentpage> createState() => _CurrentstudentpageState();
}

class _CurrentstudentpageState extends State<Currentstudentpage> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllStudents();
  }

  Future<void> _fetchAllStudents() async {
    try {
      final List<Map<String, dynamic>> data = await Supabase.instance.client
          .from('CS_CSV_2') // Updated table name
          .select('*')
          .order('name', ascending: true); // Updated column name
      if (mounted) {
        setState(() {
          _allStudents = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching students: $e')),
        );
      }
    }
  }

  Future<List<Map<String, dynamic>>> _searchStudentsInDatabase(
      String searchTerm) async {
    if (searchTerm.isEmpty) {
      return [];
    }
    try {
      final List<Map<String, dynamic>> data =
      await Supabase.instance.client.rpc('search_students', params: {
        'search_term': searchTerm,
      });
      return data;
    } catch (e) {
      print('Error searching: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Current Students", style: GoogleFonts.ubuntu(color: Color(0xFF000832))),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TypeAheadField<Map<String, dynamic>>(
              controller: _searchController,
              suggestionsCallback: (pattern) async {
                return await _searchStudentsInDatabase(pattern);
              },
              itemBuilder: (context, suggestion) {
                final imageUrl = suggestion['img_url'] ?? '';
                final studentName = suggestion['name'] ?? 'N/A'; // Updated column name
                final department = suggestion['dept'] ?? ''; // Updated column name// Updated column name
                final series = suggestion['series']?.toString()?? '';

                return ListTile(
                  tileColor: Colors.white,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage: (imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute)
                        ? NetworkImage(imageUrl)
                        : null,
                    child: (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute)
                        ? Text(studentName.isNotEmpty
                        ? studentName[0].toUpperCase()
                        : '')
                        : null,
                  ),
                  title: SubstringHighlight(
                    text: studentName,
                    term: _searchController.text,
                    textStyle: const TextStyle(
                      color: Color(0xFF000832),
                      fontWeight: FontWeight.bold,
                    ),
                    textStyleHighlight: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      SubstringHighlight(
                        text: department,
                        term: _searchController.text,
                        textStyle: TextStyle(color: Colors.grey[700]),
                        textStyleHighlight: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(' - ', style: TextStyle(color: Colors.grey[700])),
                      SubstringHighlight(
                        text: series,
                        term: _searchController.text,
                        textStyle: TextStyle(color: Colors.grey[700]),
                        textStyleHighlight: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
              onSelected: (suggestion) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Studentdetailspage(student: suggestion),
                  ),
                ).then((_) {
                  _searchController.clear();
                });
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search by Name, Dept, Roll, Series...',
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _allStudents.isEmpty
                ? const Center(child: Text('No students found.'))
                : ListView.builder(
              itemCount: _allStudents.length,
              itemBuilder: (context, index) {
                final student = _allStudents[index];
                final imageUrl = student['img_url'] ?? '';
                final studentName = student['name'] ?? 'N/A'; // Updated column name
                final studentDept = student['dept'] ?? ''; // Updated column name
                final series =
                    student['series']?.toString() ?? ''; // Updated column name

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      backgroundImage: (imageUrl.isNotEmpty &&
                          Uri.parse(imageUrl).isAbsolute)
                          ? NetworkImage(imageUrl)
                          : null,
                      child: (imageUrl.isEmpty ||
                          !Uri.parse(imageUrl).isAbsolute)
                          ? Text(
                        studentName.isNotEmpty
                            ? studentName[0].toUpperCase()
                            : 'A',
                        style:
                        TextStyle(color: Colors.grey[700]),
                      )
                          : null,
                    ),
                    title: Text(studentName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    subtitle: Text('$studentDept - $series'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Studentdetailspage(student: student),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}