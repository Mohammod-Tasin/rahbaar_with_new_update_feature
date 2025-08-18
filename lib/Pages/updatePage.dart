import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Updatepage extends StatefulWidget {
  const Updatepage({super.key});

  @override
  State<Updatepage> createState() => _UpdatepageState();
}

class _UpdatepageState extends State<Updatepage> {
  late Future<List<dynamic>> _releasesFuture;

  @override
  void initState() {
    super.initState();
    _releasesFuture = _fetchGitHubReleases();
  }

  Future<List<dynamic>> _fetchGitHubReleases() async {
    // নিচের লিংকে আপনার ইউজারনেম ও রিপোজিটরির নাম দিন
   const String repoUrl = 'https://api.github.com/repos/Mohammod-Tasin/rahbaar_with_new_update_feature/releases';

    try {
      final response = await http.get(Uri.parse(repoUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load releases');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // URL চালু করার জন্য helper function
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Download Versions", style: GoogleFonts.ubuntu()),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _releasesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No releases found.'));
          }

          final releases = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: releases.length,
            itemBuilder: (context, index) {
              final release = releases[index];
              final String tagName = release['tag_name'] ?? 'N/A';
              final String releaseName = release['name'] ?? 'Release';
              final List<dynamic> assets = release['assets'] ?? [];

              // ===== পরিবর্তন ১: সর্বশেষ ভার্সন চিহ্নিত করা =====
              // GitHub API ডিফল্টভাবে নতুন রিলিজ আগে পাঠায়, তাই index 0 মানেই সর্বশেষ
              final bool isLatest = index == 0;

              return Card(
                color: Colors.white, // কার্ডের الخلفية সাদা
                elevation: isLatest ? 4 : 2, // সর্বশেষ ভার্সনের কার্ড একটু বেশি ভাসমান থাকবে
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    // সর্বশেষ ভার্সনের বর্ডার কালো এবং মোটা হবে
                    color: isLatest ? Colors.black : Colors.grey.shade300,
                    width: isLatest ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '$releaseName ($tagName)',
                              style: GoogleFonts.ubuntu(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // টেক্সটের রঙ কালো
                              ),
                            ),
                          ),
                          // সর্বশেষ ভার্সন হলে "Latest" ট্যাগ দেখানো হবে
                          if (isLatest)
                            Chip(
                              label: const Text('Latest'),
                              backgroundColor: Colors.black,
                              labelStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            ),
                        ],
                      ),
                      const Divider(color: Colors.black26),

                      ...assets.map((asset) {
                        final String fileName = asset['name'] ?? 'file';
                        final String downloadUrl = asset['browser_download_url'] ?? '';
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          // ===== পরিবর্তন ২: আইকনের রঙ কালো করা হয়েছে =====
                          leading: const Icon(Icons.download_for_offline_rounded, color: Colors.black),
                          title: Text(fileName, style: const TextStyle(color: Colors.black)),
                          onTap: () => _launchURL(downloadUrl),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}