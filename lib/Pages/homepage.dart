import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rahbar_restarted/Data/card_data.dart'; // আপনার ফাইল পাথ
import 'package:rahbar_restarted/Pages/allAlumniPage.dart'; // আপনার ফাইল পাথ
import 'package:rahbar_restarted/Pages/queriPage.dart'; // আপনার ফাইল পাথ
import 'package:rahbar_restarted/Pages/currentStudentPage.dart'; // আপনার ফাইল পাথ

// ===== আপডেট কার্যকারিতার জন্য প্রয়োজনীয় ইম্পোর্ট =====
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  // ===== রিপোজিটরির তথ্য =====
  // ===== পরিবর্তনটি এখানে করা হয়েছে (সঠিক API URL) =====
  final String _repoUrl =
      'https://api.github.com/repos/Mohammod-Tasin/rahbaar_with_new_update_feature/releases/latest';

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
    // অ্যাপ চালু হওয়ার সময় আপডেট চেক করার জন্য ফাংশন কল
    _checkForUpdate();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // ===== ইন-অ্যাপ আপডেট ফাংশন (আপগ্রেড করা হয়েছে) =====

  Future<void> _checkForUpdate() async {
    // শুধুমাত্র ডেস্কটপ প্ল্যাটফর্মের জন্য আপডেট চেক করবে
    if (kIsWeb || (!Platform.isWindows && !Platform.isMacOS)) {
      return;
    }

    try {
      // ১. অ্যাপের বর্তমান ভার্সন চেক করা
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // ২. GitHub API থেকে সর্বশেষ রিলিজের তথ্য আনা
      final response = await http.get(Uri.parse(_repoUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        // ৩. ভার্সন তুলনা করা (ট্যাগ থেকে 'v' অক্ষরটি বাদ দিয়ে)
        String latestVersionTag = json['tag_name'] ?? 'v0.0.0';
        String latestVersion = latestVersionTag.replaceFirst('v', '');

        // compareTo ব্যবহার করে ভার্সন তুলনা করা
        // যদি GitHub ভার্সন > বর্তমান ভার্সন হয়, তবেই পপ-আপ দেখাবে
        if (latestVersion.compareTo(currentVersion) > 0) {
          // ৪. নতুন ভার্সন পেলে .zip ফাইলের URL খুঁজে বের করা
          final List<dynamic> assets = json['assets'] ?? [];
          final Map<String, dynamic>? asset = assets.firstWhere(
            (a) => a['name'].endsWith('.zip'), // .zip ফাইলটি খুঁজবে
            orElse: () => null,
          );

          if (asset != null) {
            String downloadUrl = asset['browser_download_url'];
            _showUpdateDialog(latestVersion, downloadUrl);
          }
        }
      }
    } catch (e) {
      print('Failed to check for updates: $e');
    }
  }

  // এই ফাংশনটি অপরিবর্তিত
  void _showUpdateDialog(String version, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("New Update Available!"),
          content: Text(
              "A new version (v$version) is available. Would you like to download it?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Later"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Download"),
              onPressed: () {
                Navigator.of(context).pop();
                _launchDownloadUrl(url);
              },
            ),
          ],
        );
      },
    );
  }

  // এই ফাংশনটি অপরিবর্তিত
  void _launchDownloadUrl(String url) async {
    final Uri downloadUri = Uri.parse(url);
    if (await canLaunchUrl(downloadUri)) {
      await launchUrl(downloadUri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }

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
              MaterialPageRoute(
                  builder: (context) => const Currentstudentpage()),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/Logo.png',
              height: 40, width: 40,
            ),
            const SizedBox(width: 8),
            Text("Rahbaar", style: GoogleFonts.ubuntu()),
          ],
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        width: 350,
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
              title: Text("Alumni", style: GoogleFonts.ubuntu(fontSize: 23)),
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
              title: Text("Current Students",
                  style: GoogleFonts.ubuntu(
                    fontSize: 23,
                  )),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Currentstudentpage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.comment_rounded),
              title: Text("Queries or Suggestions",
                  style: GoogleFonts.ubuntu(
                    fontSize: 23,
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Allalumnipage()),
                        );
                      },
                      hintText: "Search alumni, students ...",
                      leading: const Icon(Icons.search),
                      elevation: WidgetStateProperty.all(2),
                      shadowColor: WidgetStateProperty.all(Colors.black26),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
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