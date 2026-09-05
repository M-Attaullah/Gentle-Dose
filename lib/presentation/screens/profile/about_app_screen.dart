import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// About App Screen - Information about the app and developer
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'About App',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // App Version
            Center(
              child: Text(
                'Version: v2.1.3',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // App Description
            Text(
              'Gentle Dose Is Your Trusted Health Companion. Designed To Remind You Of Medications, Track Appointments, And Keep Your Wellness Routine On Schedule. With An Easy-To-Use Interface Built For All Ages, It Helps Elderly Users, Patients, And Caregivers Stay Organised And Worry-Free.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 40),

            // Developed By Section
            Text(
              'Developed By :',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Simphic.Com Tech',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 24),

            // Support Section
            Text(
              'For Support:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Handle email tap - could open email client
                _showSupportDialog(context);
              },
              child: Text(
                'Support@Gentledose.Com',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF407CE2),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Additional Information
            _buildInfoSection('Privacy Policy', () {
              // Navigate to privacy policy
            }),

            const SizedBox(height: 16),

            _buildInfoSection('Terms of Service', () {
              // Navigate to terms of service
            }),

            const SizedBox(height: 16),

            _buildInfoSection('Rate This App', () {
              // Navigate to app store rating
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Contact Support',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          content: Text(
            'You can reach out to our support team at:\n\nSupport@Gentledose.Com\n\nWe typically respond within 24 hours.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF407CE2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
