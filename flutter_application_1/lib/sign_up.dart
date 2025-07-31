
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: SignUpPage()));
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final contactNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(),
            _buildFormFields(),
            _buildTermsSection(),
            _buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.account_circle, size: 80, color: Colors.blue),
        SizedBox(height: 10),
        Text('Create Account',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextField(
          controller: firstNameController,
          decoration: InputDecoration(labelText: 'First Name'),
        ),
        TextField(
          controller: lastNameController,
          decoration: InputDecoration(labelText: 'Last Name'),
        ),
        TextField(
          controller: addressController,
          decoration: InputDecoration(labelText: 'Address'),
        ),
        TextField(
          controller: contactNumberController,
          decoration: InputDecoration(labelText: 'Phone Number'),
          keyboardType: TextInputType.phone,
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ),
        TextField(
          controller: passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
        TextField(
          controller: confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTermsSection() {
    return Column(
      children: [
        CheckboxListTile(
          value: _termsAccepted,
          onChanged: (v) => setState(() => _termsAccepted = v!),
          title: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text: 'I accept the '),
                TextSpan(
                  text: 'Terms and Conditions',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _showTermsDialog();
                    },
                ),
              ],
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: _privacyAccepted,
          onChanged: (v) => setState(() => _privacyAccepted = v!),
          title: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text: 'I accept the '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _showPrivacyDialog();
                    },
                ),
              ],
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _handleSignUp,
      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
      child: Text('SIGN UP'),
    );
  }

  void _handleSignUp() {
    if (!_termsAccepted || !_privacyAccepted) {
      _showErrorDialog('Please accept terms and privacy policy');
      return;
    }

    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        addressController.text.isEmpty ||
        contactNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Please fill in all the fields');
      return;
    }

    String phone = contactNumberController.text.trim();
    if (phone.length != 11 || !RegExp(r'^\d{11}$').hasMatch(phone)) {
      _showErrorDialog('Phone number must be exactly 11 digits and numeric only.');
      return;
    }

    String email = emailController.text.trim();
    if (!email.endsWith('@gmail.com')) {
      _showErrorDialog('Email must be a valid @gmail.com address.');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    _submitToBackend();
  }

  void _submitToBackend() async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.137.1/data_docuease/sign_up.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "first_name": firstNameController.text.trim(),
          "last_name": lastNameController.text.trim(),
          "address": addressController.text.trim(),
          "contact_no": contactNumberController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      print('Sign up response status: \${response.statusCode}');
      print('Sign up response body: \${response.body}');

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        _promptForOTP(emailController.text.trim());
      } else {
        _showErrorDialog(data['message'] ?? "Signup failed.");
      }
    } catch (e) {
      print('Error during sign up: \$e');
      _showErrorDialog('Failed to connect to server. Please try again laterr.');
    }
  }

  void _promptForOTP(String email) {
    TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text("Enter OTP"),
        content: TextField(
          controller: otpController,
          decoration: InputDecoration(labelText: "6-digit OTP"),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // close OTP dialog
              try {
                final otpResponse = await http.post(
                  Uri.parse("http://192.168.137.1/data_docuease/verify_otp.php"),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "email": email,
                    "otp": otpController.text.trim(),
                  }),
                );

                print('OTP verify response status: \${otpResponse.statusCode}');
                print('OTP verify response body: \${otpResponse.body}');

                final otpData = jsonDecode(otpResponse.body);
                if (otpData['success'] == true) {
                  _showSuccessDialog();
                } else {
                  _showErrorDialog(otpData['message'] ?? "OTP verification failed.");
                }
              } catch (e) {
                print('Error during OTP verification: \$e');
                _showErrorDialog('Failed to verify OTP. Please try again later.');
              }
            },
            child: Text("Verify"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Verified!'),
        content: Text('OTP verified. You can now log in.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms and Conditions'),
        content: SingleChildScrollView(
          child: Text(
            '''Welcome to the DocuEase Mobile Application, a digital service platform of the Civil Registrar’s Office. By using this app, you agree to the following Terms and Conditions. Please read them carefully.

1. Acceptance of Terms
By installing or using the DocuEase mobile app, you agree to be bound by these Terms. If you do not agree, please uninstall and discontinue use immediately.

2. Services Offered
The DocuEase mobile app allows users to:

Submit requests for civil registry documents (e.g., birth, marriage, death certificates)

Fill out required request forms

Upload a valid government-issued ID

Track the progress of submitted requests

View a partial receipt (for documentation purposes only)

3. User Responsibilities
You must provide accurate, truthful, and complete information.

Uploaded ID documents must be valid and legible.

You are responsible for the confidentiality of your request reference numbers and personal data.

4. ID Upload and Validity
Uploaded IDs are reviewed for verification purposes.

Misuse or submission of false documents may result in suspension of service or legal action.

5. Tracking and Receipts
The tracking feature is for informational use only and may not reflect real-time processing.

Partial receipts do not serve as proof of payment but confirm submission and request status.

6. Availability
We aim to keep the mobile app available at all times, but we may perform maintenance or experience interruptions. The Civil Registrar’s Office is not liable for any inconvenience caused.

7. Termination
We reserve the right to terminate your access if we detect misuse, fraud, or submission of misleading information.''',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            '''Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your data when using the DocuEase Mobile Application.

1. Information We Collect
We collect only the necessary information required to process your request, including:

Full name, address, and contact number

Birth details or related document info

Uploaded valid government-issued ID (image file)

Request details and timestamps

2. How Your Data Is Used
We use your data strictly for:

Processing and verifying your document request

Tracking progress and status notifications

Generating and displaying partial receipts

3. Data Protection and Security
All data is encrypted during upload and transmission.

Your ID and personal data are stored securely and only accessed by authorized personnel.

We do not sell, trade, or share your personal information with unauthorized third parties.

4. User Rights
You may:

Request access to your stored personal data

Request correction of incorrect data

Request deletion of your uploaded ID (subject to legal and processing requirements)

5. Data Retention
Uploaded data, including valid ID, is retained only for the duration necessary to fulfill your request and for government compliance purposes.

6. Updates to This Policy
We may update this Privacy Policy. Any major changes will be communicated through the app interface. Continued use of the app means you agree to the updated terms.''',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
