// lib/Pages/studentDetailsPage.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Studentdetailspage extends StatelessWidget {
  final Map<String, dynamic> student; // 'alumnus' theke 'student' kora hoyeche

  const Studentdetailspage({super.key, required this.student});

  // ===== Email ar Phone launch korar function (Oporibortito) =====
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

  Future<void> _launchPhone(String phoneNumber, BuildContext context) async {
    if (phoneNumber.isEmpty || phoneNumber == 'N/A' || phoneNumber == 'Not Available') return;
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open phone app for $phoneNumber')),
      );
    }
  }

  // ===== Info Row Widget (Oporibortito) =====
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
                      decoration: isClickable ? TextDecoration.underline : TextDecoration.none,
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

  // ===== Career Tile Widget (Oporibortito) =====
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
    // ===== Data gulo 'student' variable theke neya hocche =====
    final name = student['name'] ?? 'N/A';
    final series = student['Series']?.toString() ?? 'N/A';
    final department = student['Department'] ?? 'N/A';
    final email = student['email'] ?? 'N/A';
    final phone = student['Phone No.'] ?? 'N/A';
    final alternativePhone = student['Alternative Phone No.'] ?? 'Not Available';
    final presentAddress = student['Present Address in Detail'] ?? 'Not Available';
    final college = student['College'] ?? 'N/A';
    final daysInTableegh = student['Days in Tableegh'] ?? 'N/A';
    final homeDistrict = student['Home District'] ?? 'N/A';
    final bloodGroup = student['Blood Group'] ?? 'N/A';
    final List<dynamic> careerHistory = student['career_history'] ?? [];
    final imageUrl = student['profile_image_url'] ?? '';

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
              // Profile Section
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                backgroundImage: (imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute)
                    ? NetworkImage(imageUrl)
                    : null,
                child: (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute)
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'A',
                        style: const TextStyle(fontSize: 36, color: Colors.white),
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
              // Details Card
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
                      _buildInfoRow(
                        icon: Icons.email_outlined,
                        title: "Email",
                        value: email,
                        onTap: () => _launchEmail(email, context),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.phone_outlined,
                        title: "Phone",
                        value: phone,
                        onTap: () => _launchPhone(phone, context),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.phone_android_outlined,
                        title: "Alternative Phone",
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
              // Career History Section
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
                        final job = careerHistory[index] as Map<String, dynamic>;
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