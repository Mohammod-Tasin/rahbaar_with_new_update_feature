import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Studentdetailspage extends StatelessWidget {
  final Map<String, dynamic> student;

  const Studentdetailspage({super.key, required this.student});

  // ===== Email ar Phone launch korar function =====
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
    if (phoneNumber.isEmpty ||
        phoneNumber == 'N/A' ||
        phoneNumber == 'Not Available') return;

    final String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanedNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open phone app for $phoneNumber')),
      );
    }
  }

  // ===== Info Row Widget =====
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
            // ===== পরিবর্তন: আইকনের রঙ Grey করা হয়েছে =====
            Icon(icon, size: 20, color: Colors.grey),
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

  @override
  Widget build(BuildContext context) {
    final name = student['name'] ?? 'N/A';
    final series = student['series']?.toString() ?? 'N/A';
    final department = student['dept'] ?? 'N/A';
    final email = student['email'] ?? 'N/A';
    final phone = student['phone_no_whatsapp']?.toString() ?? 'N/A';

    final alternativePhone = student['alternative_phone_no']?.toString() ?? '';
    final homeDistrict = student['Home District'] ?? 'N/A';
    final bloodGroup = student['Blood Group'] ?? 'N/A';

    final presentAddress = student['present_address'] ?? 'N/A';
    final college = student['College'] ?? 'N/A';
    final imageUrl = student['img_url'] ?? '';
    final daysInTableegh = student['Days in Tableegh']?.toString() ?? '';

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
              // ===== Profile Section =====
              CircleAvatar(
                radius: 60,
                // প্রোফাইল ছবির ব্যাকগ্রাউন্ডটি লোগোর রঙেই (Navy Blue) রাখা হয়েছে
                backgroundColor: (imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute)
                    ? Colors.white
                    : const Color(0xFF0D253F),
                backgroundImage: (imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute)
                    ? NetworkImage(imageUrl)
                    : null,
                child: (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute)
                    ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'A',
                  style: const TextStyle(fontSize: 48, color: Colors.white),
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
                "Series: $series | Dept: $department",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 24),

              // ===== Details Card =====
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
                        title: "Phone (WhatsApp)",
                        value: phone,
                        onTap: () => _launchPhone(phone, context),
                      ),

                      if (alternativePhone.isNotEmpty && alternativePhone != 'N/A') ...[
                        const Divider(),
                        _buildInfoRow(
                          icon: Icons.phone_android_outlined,
                          title: "Alternative Phone No",
                          value: alternativePhone,
                          onTap: () => _launchPhone(alternativePhone, context),
                        ),
                      ],

                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.location_on_outlined,
                        title: "Present Address",
                        value: presentAddress,
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.home,
                        title: "Home District",
                        value: homeDistrict,
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.school,
                        title: "Previous College",
                        value: college,
                      ),
                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.bloodtype,
                        title: "Blood Group",
                        value: bloodGroup,
                      ),

                      const Divider(),
                      _buildInfoRow(
                        icon: Icons.shield_moon,
                        title: "Days In Tableegh",
                        value: daysInTableegh,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}