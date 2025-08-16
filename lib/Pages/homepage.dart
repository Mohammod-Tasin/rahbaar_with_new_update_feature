import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rahbar_restarted/Data/card_data.dart';
import 'package:rahbar_restarted/Pages/allAlumniPage.dart';
import 'package:rahbar_restarted/Pages/queriPage.dart';
import 'package:rahbar_restarted/Pages/currentStudentPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
    // ===== আপডেট চেক করার ফাংশন কলটি সরিয়ে ফেলা হয়েছে =====
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // ===== ইন-অ্যাপ আপডেট সম্পর্কিত সব ফাংশন সরিয়ে ফেলা হয়েছে =====

  // একটি helper widget যা প্রতিটি কার্ড তৈরি করবে (অপরিবর্তিত)
  Widget _buildClickableCard(CardItem item) {
    return Card(
      elevation: 4,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          if (item.title == "Alumni page") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Allalumnipage()),
            );
          } else if (item.title == "Current Student Page") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Currentstudentpage()),
            );
          } else if (item.title == "Queries or Suggestions") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Queripage()),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(item.icon, size: 40, color: item.color),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item.subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // আপনার build মেথডটি সম্পূর্ণ অপরিবর্তিত
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hub_outlined),
            const SizedBox(width: 8),
            Text("Rahbaar", style: GoogleFonts.ubuntu()),
          ],
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             const DrawerHeader(
              child: Center(
                child: Text("R A H B A A R", style: TextStyle(fontSize: 35)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.school_rounded),
              title: Text("Alumni", style: GoogleFonts.ubuntu(fontSize: 25)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Allalumnipage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_rounded),
              title: Text("Current Students", style: GoogleFonts.ubuntu(
                fontSize: 25,
              )),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Currentstudentpage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_rounded),
              title: Text("Queries or Suggestions", style: GoogleFonts.ubuntu(
                fontSize: 25,
              )),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Queripage()),
                );
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth >= 600;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: SearchBar(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      hintText: "Search alumni, students ...",
                      leading: const Icon(Icons.search),
                      elevation: WidgetStateProperty.all(2),
                      shadowColor: WidgetStateProperty.all(Colors.black26),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: isDesktop
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20.0,
                            runSpacing: 20.0,
                            children: cardItems.map((item) {
                              return SizedBox(
                                width: 280,
                                height: 180,
                                child: _buildClickableCard(item),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        itemCount: cardItems.length,
                        itemBuilder: (context, index) {
                          final item = cardItems[index];
                          return Container(
                            height: 160,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: _buildClickableCard(item),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}