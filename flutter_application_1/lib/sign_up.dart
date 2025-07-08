import 'package:flutter/material.dart';
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
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password'),
        ),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Confirm Password'),
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
          title: Text('I accept the Terms and Conditions'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: _privacyAccepted,
          onChanged: (v) => setState(() => _privacyAccepted = v!),
          title: Text('I accept the Privacy Policy'),
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
    // Basic validation
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

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    _submitToBackend();
  }

  void _submitToBackend() async {
    final response = await http.post(
      Uri.parse("http://192.168.137.1/data_docuease/sign_up.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "address": addressController.text,
        "contact_no": contactNumberController.text,
        "email": emailController.text,
        "password": passwordController.text,
      }),
    );

    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      _showSuccessDialog();
    } else {
      _showErrorDialog(data['message'] ?? "Signup failed.");
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Success!'),
        content: Text('Your account has been created successfully.'),
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
