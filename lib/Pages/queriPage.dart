import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Queripage extends StatelessWidget {
  const Queripage({super.key});

  // URL চালু করার জন্য একটি helper function
  Future<void> _launchURL(String urlString, BuildContext context) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }

  // প্রতিটি কন্টাক্ট আইটেম তৈরির জন্য একটি helper widget
  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.blue[800])),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Queries or Suggestions"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ===== ডেভেলপারের ছবি =====
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF000832),
                // আপনি চাইলে এখানে নেটওয়ার্ক থেকে ছবি দেখাতে পারেন
                // backgroundImage: NetworkImage('YOUR_IMAGE_URL_HERE'),
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),

              const SizedBox(height: 20),

              // ===== ডেভেলপারের নাম ও পরিচিতি =====
              Text(
                "Anonymous", // <-- আপনার নাম এখানে লিখুন
                style: GoogleFonts.ubuntu(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Slave of Almighty", // <-- আপনার পদবী বা পরিচিতি
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // ===== যোগাযোগের তথ্যের জন্য কার্ড =====
              Card(
                elevation: 2,
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildContactTile(
                      icon: Icons.email_outlined,
                      title: "Email",
                      subtitle: "anonymous32063047@gmail.com", // <-- আপনার ইমেইল
                      onTap: () => _launchURL(
                        'mailto:anonymous32063047@gmail.com?subject=Suggestions and queries about Rahbaar App', // <-- আপনার ইমেইল
                        context,
                      ),
                    ),
                    // const Divider(height: 1),
                    // _buildContactTile(
                    //   icon: Icons.link,
                    //   title: "LinkedIn",
                    //   subtitle: "linkedin.com/in/your-profile", // <-- আপনার লিংকডইন প্রোফাইল
                    //   onTap: () => _launchURL(
                    //     'https://www.linkedin.com/in/your-profile/', // <-- আপনার লিংকডইন প্রোফাইল
                    //     context,
                    //   ),
                    // ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}