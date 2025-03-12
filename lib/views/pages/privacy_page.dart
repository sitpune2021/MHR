// import 'package:flutter/material.dart';

// class PrivacyScreen extends StatefulWidget {
//   const PrivacyScreen({super.key});

//   @override
//   State<PrivacyScreen> createState() => _PrivacyScreenState();
// }

// class _PrivacyScreenState extends State<PrivacyScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(

//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy for [Machine Hour Rate]',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Last Updated: [Date]',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Text(
                'At [Machine Hour Rate], we value your privacy and are committed to safeguarding your personal information. '
                'This Privacy Policy outlines how we collect, use, and protect your data when you use our mobile application ("App"). '
                'By accessing or using our App, you agree to the practices described in this policy.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '1. Information We Collect',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'We may collect the following types of information when you use our App:\n\n'
                '- Personal Information: Your name, email, phone number, etc.\n'
                '- Usage Data: Interaction data like pages visited and errors encountered.\n'
                '- Cookies and Tracking Technologies.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '2. How We Use Your Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'We use the information to provide, maintain, and improve the App, '
                'personalize your experience, communicate with you, monitor app usage, and comply with legal obligations.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '3. Sharing Your Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'We only share your data with trusted third-party service providers, '
                'for legal compliance, or in case of business transfers.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '4. Data Retention',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Your data is retained only as long as necessary. You can request data deletion by contacting us.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '5. Security',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'We implement reasonable measures to protect your information, '
                'but absolute security cannot be guaranteed.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '6. Your Rights',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'You have rights to access, update, delete your data, and withdraw consent.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '7. Third-Party Links',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'We are not responsible for third-party sites linked from our App.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '8. Children\'s Privacy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Our App is not intended for children under 13. If discovered, data will be deleted.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '9. Changes to This Privacy Policy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'We may update this policy. You are encouraged to review it periodically.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '10. Contact Us',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '[Your Company Name]\n[Email Address]\n[Phone Number]\n[Physical Address]',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
