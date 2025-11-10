// currentStudentPage.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rahbar_restarted/Pages/studentDetailsPage.dart'; // <-- Notun details page-ke import kora hoyeche
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

  List<Map<String, dynamic>> _allStudents = []; // 'allAlumni' theke 'allStudents'
  bool _isLoading = true;

  // ===== Filter state =====
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _fetchAllStudents();
  }

  Future<void> _fetchAllStudents() async {
    try {
      // ===== Poriborton: 'CSV' table-er bodole 'Current_Students' table =====
      final List<Map<String, dynamic>> data = await Supabase.instance.client
          .from('Current_Students') // <-- *** Apnar student table-er naam din ***
          .select('*')
          .order('name', ascending: true);
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
      // ===== Poriborton: 'search_alumni' RPC-er bodole 'search_students' RPC =====
      final List<Map<String, dynamic>> data =
          await Supabase.instance.client.rpc('search_students', params: { // <-- *** Notun RPC function ***
        'search_term': searchTerm,
        'filter_type': _selectedFilter
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
        title: Text("Current Students", style: GoogleFonts.ubuntu()),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Text("Search by: ",
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.black54)),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(value: 'name', child: Text('Name')),
                        DropdownMenuItem(
                            value: 'department', child: Text('Department')),
                        DropdownMenuItem(value: 'series', child: Text('Series')),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedFilter = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TypeAheadField<Map<String, dynamic>>(
              controller: _searchController,
              suggestionsCallback: (pattern) async {
                return await _searchStudentsInDatabase(pattern);
              },
              itemBuilder: (context, suggestion) {
                final imageUrl = suggestion['profile_image_url'] ?? '';
                final studentName = suggestion['name'] ?? 'N/A';
                final department = suggestion['Department'] ?? '';
                final series = suggestion['Series']?.toString() ?? '';

                return ListTile(
                  tileColor: Colors.white,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        (imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute)
                            ? NetworkImage(imageUrl)
                            : null,
                    child:
                        (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute)
                            ? Text(studentName.isNotEmpty
                                ? studentName[0].toUpperCase()
                                : '')
                            : null,
                  ),
                  title: SubstringHighlight(
                    text: studentName,
                    term: _selectedFilter == 'name' || _selectedFilter == 'all'
                        ? _searchController.text
                        : '',
                    textStyle: const TextStyle(
                      color: Colors.black,
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
                        term: _selectedFilter == 'department' ||
                                _selectedFilter == 'all'
                            ? _searchController.text
                            : '',
                        textStyle: TextStyle(color: Colors.grey[700]),
                        textStyleHighlight: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(' - ', style: TextStyle(color: Colors.grey[700])),
                      SubstringHighlight(
                        text: series,
                        term: _selectedFilter == 'series' ||
                                _selectedFilter == 'all'
                            ? _searchController.text
                            : '',
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
                    // ===== Poriborton: Notun details page-e navigate korbe =====
                    builder: (context) => Studentdetailspage(student: suggestion),
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
                    hintText: 'Search by Name, Department, Series...',
                  ),
                );
              },
            ),
          ),

          // List of all students
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _allStudents.isEmpty
                    ? const Center(child: Text('No students found.'))
                    : ListView.builder(
                        itemCount: _allStudents.length,
                        itemBuilder: (context, index) {
                          final student = _allStudents[index];
                          final imageUrl = student['profile_image_url'] ?? '';
                          final studentName = student['name'] ?? 'N/A';
                          final studentDept = student['Department'] ?? '';
                          final studentSeries =
                              student['Series']?.toString() ?? '';

                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
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
                              subtitle: Text('$studentDept - $studentSeries'),
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