// lib/Pages/alumniDetailsPage.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Alumnidetailspage extends StatelessWidget {
  final Map<String, dynamic> alumnus;

  const Alumnidetailspage({super.key, required this.alumnus});

  // ===== নতুন ফাংশন যোগ করা হয়েছে =====
  // ইমেইল অ্যাপ চালু করার ফাংশন
  Future<void> _launchEmail(String email, BuildContext context) async {
    if (email.isEmpty || email == 'N/A') return;

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Connecting from Rahbaar App',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open email app for $email')),
      );
    }
  }

  // ফোন ডায়ালার চালু করার ফাংশন
  Future<void> _launchPhone(String phoneNumber, BuildContext context) async {
    if (phoneNumber.isEmpty ||
        phoneNumber == 'N/A' ||
        phoneNumber == 'Not Available')
      return;

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open phone app for $phoneNumber')),
      );
    }
  }

  // ===== _buildInfoRow উইজেটটি আপডেট করা হয়েছে =====
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    final bool isClickable = onTap != null;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: isClickable ? Colors.blue[800] : Colors.grey[700],
                      decoration: isClickable
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Career সেকশনের কোড (আপনার কোড অনুযায়ী)
  Widget _buildCareerTile(Map<String, dynamic> job, {required bool isLast}) {
    final bool isPresent = job['is_present'] ?? false;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isPresent
                    ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                    : Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle,
                        ),
                      ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.teal.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['position'] ?? 'N/A',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isPresent ? Colors.green[800] : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job['company'] ?? 'N/A',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ডেটাবেজ থেকে তথ্যগুলো বের করে আনা হচ্ছে
    final name = alumnus['name'] ?? 'N/A';
    final series = alumnus['series']?.toString() ?? 'N/A';
    final department = alumnus['dept'] ?? 'N/A';
    final email = alumnus['email'] ?? 'N/A';
    final phone = alumnus['phone_wh'] ?? 'N/A';
    final alternativePhone =
        alumnus['alt_phn'] ?? 'Not Available';
    final presentAddress =
        alumnus['present_address'] ?? 'Not Available';
    final college = alumnus['college'] ?? 'N/A';
    final daysInTableegh = alumnus['days_in_tabligh'] ?? 'N/A';
    final homeDistrict = alumnus['home_district'] ?? 'N/A';
    final bloodGroup = alumnus['blood_group'] ?? 'N/A';

    final List<dynamic> careerHistory = alumnus['career_history'] ?? [];

    // ডেটাবেজ থেকে অন্যান্য তথ্যের সাথে ছবির URL টিও নিয়ে আসা হচ্ছে
    final imageUrl = alumnus['profile_img_url'] ?? '';

    careerHistory.sort((a, b) {
      bool isAPresent = a['is_present'] ?? false;
      bool isBPresent = b['is_present'] ?? false;
      if (isAPresent) return -1;
      if (isBPresent) return 1;
      int serialA = a['serial'] ?? 999;
      int serialB = b['serial'] ?? 999;
      return serialA.compareTo(serialB);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // build method এর ভেতরে...

              // ... বাকি কোড ...

              // ===== উপরের প্রোফাইল সেকশন (পরিবর্তিত) =====
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                // নিচের backgroundImage প্রপার্টি যোগ করা হয়েছে
                backgroundImage:
                    (imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute)
                    ? NetworkImage(
                        imageUrl,
                      ) // URL থাকলে নেটওয়ার্ক থেকে ছবি দেখাবে
                    : null,
                // URL না থাকলে আগের মতো নামের প্রথম অক্ষর দেখাবে
                child: (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute)
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'A',
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                name.toUpperCase(),
                style: GoogleFonts.ubuntu(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Series: $series | Department: $department",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // ===== onTap ফাংশনগুলো এখানে যোগ করা হয়েছে =====
                      _buildInfoRow(
                        icon: Icons.email_outlined,
                        title: "Email",
                        value: email,
                        onTap: () => _launchEmail(email, context),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.phone_outlined,
                        title: "Phone Number",
                        value: phone,
                        onTap: () => _launchPhone(phone, context),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.phone_android_outlined,
                        title: "Alternative Phone Number",
                        value: alternativePhone,
                        onTap: () => _launchPhone(alternativePhone, context),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.location_on_outlined,
                        title: "Present Address",
                        value: presentAddress,
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.school_rounded,
                        title: "College",
                        value: college,
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.shield_moon_rounded,
                        title: "Days in Tableegh",
                        value: daysInTableegh,
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.home_rounded,
                        title: "Home District",
                        value: homeDistrict,
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.bloodtype,
                        title: "Blood Group",
                        value: bloodGroup,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (careerHistory.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.work_history_outlined, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          'Career History',
                          style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      padding: const EdgeInsets.only(left: 4),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: careerHistory.length,
                      itemBuilder: (context, index) {
                        final job =
                            careerHistory[index] as Map<String, dynamic>;
                        final bool isLast = index == careerHistory.length - 1;
                        return _buildCareerTile(job, isLast: isLast);
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
