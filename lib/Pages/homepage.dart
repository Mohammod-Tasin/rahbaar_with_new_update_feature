import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rahbar_restarted/Data/card_data.dart';
import 'package:rahbar_restarted/Pages/allAlumniPage.dart';
import 'package:rahbar_restarted/Pages/queriPage.dart';
import 'package:rahbar_restarted/Pages/currentStudentPage.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // ===== ভার্সন ভ্যারিয়েবল =====
  String _currentVersion = "";

  // ===== অ্যানিমেশন কন্ট্রোল করার জন্য ভ্যারিয়েবল =====
  bool _startEnglishAnimation = false;

  final String _repoUrl =
      'https://api.github.com/repos/Mohammod-Tasin/rahbaar_with_new_update_feature/releases/latest';

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _currentVersion = packageInfo.version;
        });
      }
    } catch (e) {
      print("Failed to get package info: $e");
    }
  }

  // ===== ইন-অ্যাপ আপডেট ফাংশন =====
  Future<void> _checkForUpdate() async {
    if (kIsWeb || (!Platform.isWindows && !Platform.isMacOS)) {
      return;
    }
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      final response = await http.get(Uri.parse(_repoUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        String latestVersionTag = json['tag_name'] ?? 'v0.0.0';
        String latestVersion = latestVersionTag.replaceFirst('v', '');

        if (latestVersion.compareTo(currentVersion) > 0) {
          final List<dynamic> assets = json['assets'] ?? [];
          final Map<String, dynamic>? asset = assets.firstWhere(
                (a) => a['name'].endsWith('.zip'),
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

  void _launchDownloadUrl(String url) async {
    final Uri downloadUri = Uri.parse(url);
    if (await canLaunchUrl(downloadUri)) {
      await launchUrl(downloadUri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }

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
            Image.asset(
              'assets/Rahbar Logo.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 5),
            Text("A H B A R", style: GoogleFonts.ubuntu(
                color: Color(0xFF000832)
            )),
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
                child: Text("R A H B A R", style: TextStyle(fontSize: 35, color: Color(0xFF000832))),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.school_rounded),
              title: Text("Alumni", style: GoogleFonts.ubuntu(fontSize: 23, color: Color(0xFF000832))),
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
                      color: Color(0xFF000832)
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
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                _currentVersion.isNotEmpty ? "Version v$_currentVersion" : "Loading version...",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
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
                    constraints: const BoxConstraints(maxWidth: 800),
                    // ===== অ্যানিমেটেড টেক্সট সেকশন =====
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // আরবি টেক্সট (এটি আগে অ্যানিমেট হবে)
                        DefaultTextStyle(
                          style: GoogleFonts.amiri( // কুরআনিক স্টাইল ফন্ট
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000832),
                            height: 2.5, // লাইন হাইট বাড়ানো হয়েছে যাতে অক্ষর কেটে না যায়
                          ),
                          textAlign: TextAlign.center,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'وَأْمُرْ أَهْلَكَ بِٱلصَّلَوٰةِ وَٱصْطَبِرْ عَلَيْهَا ۖ لَا نَسْـَٔلُكَ رِزْقًۭا ۖ نَّحْنُ نَرْزُقُكَ ۗ وَٱلْعَـٰقِبَةُ لِلتَّقْوَىٰ',
                                speed: const Duration(milliseconds: 100),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            isRepeatingAnimation: false, // লুপ হবে না
                            totalRepeatCount: 1,
                            onFinished: () {
                              // আরবি শেষ হলে ইংরেজি শুরু হবে
                              setState(() {
                                _startEnglishAnimation = true;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ইংরেজি টেক্সট (আরবি শেষ হওয়ার পর এটি আসবে)
                        if (_startEnglishAnimation)
                          DefaultTextStyle(
                            style: GoogleFonts.lora( // ক্লাসিক স্টাইল ফন্ট
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFC5A059),
                            ),
                            textAlign: TextAlign.center,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Bid your people to pray, and be diligent in ˹observing˺ it. We do not ask you to provide. It is We Who provide for you. And the ultimate outcome is ˹only˺ for ˹the people of˺ righteousness. 20:132',
                                  speed: const Duration(milliseconds: 50),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              isRepeatingAnimation: false,
                              totalRepeatCount: 1,
                            ),
                          ),
                      ],
                    ),
                    // ===================================
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