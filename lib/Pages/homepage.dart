import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rahbar_restarted/Data/card_data.dart';
import 'package:rahbar_restarted/Pages/allAlumniPage.dart';
import 'package:rahbar_restarted/Pages/queriPage.dart';
import 'package:rahbar_restarted/Pages/currentStudentPage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart'; // লিংক ওপেন করার জন্য এটি প্রয়োজন

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // ইংরেজি অ্যানিমেশন শুরু করার জন্য ফ্ল্যাগ
  bool _startEnglishAnimation = false;

  // ===== সরাসরি ডাউনলোড লিংক ওপেন করার ফাংশন =====
  Future<void> _launchDownloadUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // যদি লিংক ওপেন না হয়, একটি এরর মেসেজ দেখাবে
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    }
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
              'assets/icon/Logo.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 8),
            Text(
              "Rahbaar",
              style: GoogleFonts.ubuntu(color: const Color(0xFF000832)),
            ),
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
                child: Text(
                  "R A H B A R",
                  style: TextStyle(fontSize: 35, color: Color(0xFF000832)),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.school_rounded),
              title: Text("Alumnus",
                  style: GoogleFonts.ubuntu(
                      fontSize: 23, color: const Color(0xFF000832))),
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
                    color: const Color(0xFF000832),
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
                    color: const Color(0xFF000832),
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
                    constraints: const BoxConstraints(maxWidth: 800),
                    // ===== অ্যানিমেটেড টেক্সট সেকশন =====
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // আরবি টেক্সট (এটি আগে অ্যানিমেট হবে)
                        DefaultTextStyle(
                          style: GoogleFonts.amiri(
                            // কুরআনিক স্টাইল ফন্ট
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000832),
                            height: 2.5, // ওভারল্যাপ ঠিক করার জন্য লাইন হাইট বাড়ানো হয়েছে
                          ),
                          textAlign: TextAlign.center,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'وَأْمُرْ أَهْلَكَ بِٱلصَّلَوٰةِ وَٱصْطَبِرْ عَلَيْهَا ۖ لَا نَسْـَٔلُكَ رِزْقًۭا ۖ نَّحْنُ نَرْزُقُكَ ۗ وَٱلْعَـٰقِبَةُ لِلتَّقْوَىٰ',
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
                            style: GoogleFonts.lora(
                              // ক্লাসিক সেরিফ ফন্ট
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFF555555), // একটু হালকা রঙ
                            ),
                            textAlign: TextAlign.center,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Bid your people to pray, and be diligent in ˹observing˺ it. We do not ask you to provide. It is We Who provide for you. And the ultimate outcome is ˹only˺ for ˹the people of˺ righteousness.',
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

  // একটি helper widget যা প্রতিটি কার্ড তৈরি করবে
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
          // টাইটেলের নাম চেক করে নেভিগেশন
          if (item.title.contains("Alumnus")) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Allalumnipage()),
            );
          } else if (item.title.contains("Current Students")) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Currentstudentpage()),
            );
          } else if (item.title.contains("Queries or Suggestions")) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Queripage()),
            );
          }
          // ===== পরিবর্তন: সরাসরি ডাউনলোডের লজিক =====
          else if (item.title.contains("Updates") || item.title.contains("Download")) {
            // এখানে আপনার .apk ফাইলের ডাইরেক্ট ডাউনলোড লিংক দিন
            _launchDownloadUrl('https://github.com/Mohammod-Tasin/rahbaar_with_new_update_feature/releases/latest/download/app-release.apk');
          }
          // =========================================
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
}