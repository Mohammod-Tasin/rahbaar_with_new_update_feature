import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rahbar_restarted/Pages/alumniDetailsPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:substring_highlight/substring_highlight.dart';

class Allalumnipage extends StatefulWidget {
  const Allalumnipage({super.key});

  @override
  State<Allalumnipage> createState() => _AllalumnipageState();
}

class _AllalumnipageState extends State<Allalumnipage> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allAlumni = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllAlumni();
  }

  Future<void> _fetchAllAlumni() async {
    try {
      final List<Map<String, dynamic>> data = await Supabase.instance.client
          .from('CSV')
          .select('*')
          .order('name', ascending: true);
      if (mounted) {
        setState(() {
          _allAlumni = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching alumni: $e')),
        );
      }
    }
  }

  Future<List<Map<String, dynamic>>> _searchAlumniInDatabase(String searchTerm) async {
    if (searchTerm.isEmpty) {
      return [];
    }
    try {
      final List<Map<String, dynamic>> data = await Supabase.instance.client
          .rpc('search_alumni', params: {'search_term': searchTerm});
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
        title: Text("Alumni Directory", style: GoogleFonts.ubuntu()),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TypeAheadField<Map<String, dynamic>>(
              // debounceDuration: const Duration(milliseconds: 500),
              controller: _searchController,
              suggestionsCallback: (pattern) async {
                return await _searchAlumniInDatabase(pattern);
              },
              itemBuilder: (context, suggestion) {
                final imageUrl = suggestion['profile_image_url'] ?? '';
                final alumniName = suggestion['name'] ?? 'N/A';
                final department = suggestion['Department'] ?? '';
                final series = suggestion['Series']?.toString() ?? '';

                return ListTile(
                  tileColor: Colors.white,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage: (imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute)
                        ? NetworkImage(imageUrl)
                        : null,
                    child: (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute)
                        ? Text(alumniName.isNotEmpty ? alumniName[0].toUpperCase() : '')
                        : null,
                  ),
                  title: SubstringHighlight(
                    text: alumniName,
                    term: _searchController.text,
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textStyleHighlight: TextStyle(
                      color: Theme.of(context).primaryColorDark,
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
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(' - ', style: TextStyle(color: Colors.grey[700])),
                      SubstringHighlight(
                        text: series,
                        term: _searchController.text,
                        textStyle: TextStyle(color: Colors.grey[700]),
                        textStyleHighlight: TextStyle(
                          color: Theme.of(context).primaryColor,
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
                    builder: (context) => Alumnidetailspage(alumnus: suggestion),
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

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _allAlumni.isEmpty
                    ? const Center(child: Text('No alumni found.'))
                    : ListView.builder(
                        itemCount: _allAlumni.length,
                        itemBuilder: (context, index) {
                          final alumni = _allAlumni[index];
                          final imageUrl = alumni['profile_image_url'] ?? '';
                          final alumniName = alumni['name'] ?? 'N/A';
                          final alumniDept = alumni['Department'] ?? '';
                          final alumniSeries = alumni['Series']?.toString() ?? '';

                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: (imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute)
                                    ? NetworkImage(imageUrl)
                                    : null, // <-- এখানে কোলন (:) হবে
                                child: (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute)
                                    ? Text(alumniName.isNotEmpty ? alumniName[0].toUpperCase() : 'A',
                                        style: TextStyle(color: Colors.grey[700]),
                                      )
                                    : null, // <-- এখানেও কোলন (:) হবে
                              ),
                              title: Text(alumniName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('$alumniDept - $alumniSeries'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Alumnidetailspage(alumnus: alumni),
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