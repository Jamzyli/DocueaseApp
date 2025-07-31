import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final String apiUrl = "http://192.168.137.1/data_docuease/request_handler.php";
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final contactNumberController = TextEditingController();
  final emailController = TextEditingController();
  String _selectedCertificateType = "Birth Certificate";

  final dateOfBirthController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final dateOfMarriageController = TextEditingController();
  final spouseNameController = TextEditingController();
  final dateOfDeathController = TextEditingController();
  final placeOfDeathController = TextEditingController();

  File? _selectedImage;

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    placeOfBirthController.dispose();
    dateOfMarriageController.dispose();
    spouseNameController.dispose();
    dateOfDeathController.dispose();
    placeOfDeathController.dispose();
    super.dispose();
  }

  void _clearCertificateSpecificFields() {
    dateOfBirthController.clear();
    placeOfBirthController.clear();
    dateOfMarriageController.clear();
    spouseNameController.clear();
    dateOfDeathController.clear();
    placeOfDeathController.clear();
  }

  Future<void> _pickImage() async {
    // Request permission before picking image
    var status = await Permission.photos.status;
    if (status.isDenied) {
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } else if (status.isPermanentlyDenied) {
      // The user has permanently denied access, guide them to settings
      _showPermissionDeniedDialog();
    } else if (status.isRestricted) {
      // iOS specific: The user cannot grant permission due to parental controls etc.
      _showPermissionRestrictedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Gallery Access Denied"),
          content: const Text(
              "Access to your photo gallery was permanently denied. Please enable it in your device settings to upload an ID."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Open Settings"),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // Opens the app settings
              },
            ),
          ],
        );
      },
    );
  }

  void _showPermissionRestrictedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Gallery Access Restricted"),
          content: const Text(
              "Access to your photo gallery is restricted. This might be due to parental controls or other system settings."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade800,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade800,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImage == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Missing Valid ID'),
          content: const Text('Please upload a valid ID image to proceed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    String? base64Image;
    try {
      List<int> imageBytes = await _selectedImage!.readAsBytes();
      base64Image = base64Encode(imageBytes);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Image Error'),
          content: Text('Failed to process image: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      print('Error encoding image: $e');
      return;
    }

    Map<String, dynamic> requestBody = {
      "certificate_type": _selectedCertificateType,
      "full_name": fullNameController.text,
      "address": addressController.text,
      "contact_number": contactNumberController.text,
      "email": emailController.text,
      "valid_id_base64": base64Image,
      "file_extension": _selectedImage!.path.split('.').last,
      "date_of_birth": null,
      "place_of_birth": null,
      "date_of_marriage": null,
      "spouse_name": null,
      "date_of_death": null,
      "place_of_death": null,
    };

    switch (_selectedCertificateType) {
      case "Birth Certificate":
        requestBody["date_of_birth"] = dateOfBirthController.text.isEmpty ? null : dateOfBirthController.text;
        requestBody["place_of_birth"] = placeOfBirthController.text.isEmpty ? null : placeOfBirthController.text;
        break;
      case "Marriage Certificate":
        requestBody["date_of_marriage"] = dateOfMarriageController.text.isEmpty ? null : dateOfMarriageController.text;
        requestBody["spouse_name"] = spouseNameController.text.isEmpty ? null : spouseNameController.text;
        break;
      case "Death Certificate":
        requestBody["date_of_death"] = dateOfDeathController.text.isEmpty ? null : dateOfDeathController.text;
        requestBody["place_of_death"] = placeOfDeathController.text.isEmpty ? null : placeOfDeathController.text;
        break;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final data = jsonDecode(response.body);

showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(data['success'] ? 'Success' : 'Error'),
          content: data['success']
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['message']),
                    const SizedBox(height: 10),
                    const Text(
                      "Please check the progress on our website to see the status of your request. You can claim it within 1 week after completing the request.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Text(data['message']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (data['success']) {
                  _formKey.currentState?.reset();
                  _clearCertificateSpecificFields();
                  setState(() {
                    _selectedImage = null;
                  });
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Network Error'),
          content: Text('Failed to connect to the server. Please check your internet connection and server URL. Error: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      print('Error submitting request: $e');
    }
  }

  Widget _buildCertificateFields() {
    switch (_selectedCertificateType) {
      case "Birth Certificate":
        return Column(
          children: [
            TextFormField(
              controller: dateOfBirthController,
              readOnly: true,
              onTap: () => _selectDate(context, dateOfBirthController),
              decoration: _inputDecoration("Date of Birth (YYYY-MM-DD)", Icons.calendar_today),
              validator: (value) => value!.isEmpty ? 'Please enter date of birth' : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: placeOfBirthController,
              decoration: _inputDecoration("Place of Birth", Icons.location_on),
              validator: (value) => value!.isEmpty ? 'Please enter place of birth' : null,
            ),
          ],
        );
      case "Marriage Certificate":
        return Column(
          children: [
            TextFormField(
              controller: dateOfMarriageController,
              readOnly: true,
              onTap: () => _selectDate(context, dateOfMarriageController),
              decoration: _inputDecoration("Date of Marriage (YYYY-MM-DD)", Icons.calendar_today),
              validator: (value) => value!.isEmpty ? 'Please enter date of marriage' : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: spouseNameController,
              decoration: _inputDecoration("Spouse Name", Icons.people),
              validator: (value) => value!.isEmpty ? 'Please enter spouse name' : null,
            ),
          ],
        );
      case "Death Certificate":
        return Column(
          children: [
            TextFormField(
              controller: dateOfDeathController,
              readOnly: true,
              onTap: () => _selectDate(context, dateOfDeathController),
              decoration: _inputDecoration("Date of Death (YYYY-MM-DD)", Icons.calendar_today),
              validator: (value) => value!.isEmpty ? 'Please enter date of death' : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: placeOfDeathController,
              decoration: _inputDecoration("Place of Death", Icons.location_on),
              validator: (value) => value!.isEmpty ? 'Please enter place of death' : null,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  InputDecoration _inputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Colors.blue.shade600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade300, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade800, width: 2.0),
      ),
      filled: true,
      fillColor: Colors.blue.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: const Text(
        "Certificate Request Form",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
      ),
      backgroundColor: Colors.blue[900],
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Section 1: Request Details
            _sectionCard(
              title: "Request Details",
              subtitle: "Select the type of certificate you are requesting.",
              child: DropdownButtonFormField<String>(
                value: _selectedCertificateType,
                decoration: _inputDecoration("Certificate Type", Icons.description),
                items: const [
                  "Birth Certificate",
                  "Marriage Certificate",
                  "Death Certificate",
                ].map((type) => DropdownMenuItem(value: type, child: Text(type, style: TextStyle(color: Colors.black)))).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCertificateType = val!;
                    _clearCertificateSpecificFields();
                  });
                },
                validator: (value) => value == null ? 'Please select a certificate type' : null,
              ),
            ),

            const SizedBox(height: 20),

            // Section 2: Personal Information
            _sectionCard(
              title: "Personal Information",
              subtitle: "Provide your complete personal details.",
              child: Column(
                children: [
                  _textField(fullNameController, "Full Name", Icons.person, "Please enter full name"),
                  const SizedBox(height: 12),
                  _textField(addressController, "Address", Icons.home, "Please enter address"),
                  const SizedBox(height: 12),
                  _textField(contactNumberController, "Contact Number", Icons.phone, "Please enter contact number", type: TextInputType.phone),
                  const SizedBox(height: 12),
                  _textField(emailController, "Email Address", Icons.email, "Please enter a valid email", type: TextInputType.emailAddress, isEmail: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 3: Certificate-specific details
            _sectionCard(
              title: "Certificate Information",
              subtitle: "Fill in details specific to your certificate type.",
              child: _buildCertificateFields(),
            ),

            const SizedBox(height: 20),

            // Section 4: Upload ID
            _sectionCard(
              title: "Identification",
              subtitle: "Upload a valid government-issued ID.",
              child: Column(
                children: [
                  _selectedImage == null
                      ? InkWell(
                          onTap: _pickImage,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.blue, width: 1.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: const [
                                Icon(Icons.upload_file, color: Colors.blue, size: 40),
                                SizedBox(height: 8),
                                Text("Tap to Upload", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text("PNG, JPG up to 5MB", style: TextStyle(color: Colors.black, fontSize: 12)),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(_selectedImage!, height: 150, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.change_circle, color: Colors.blue),
                              label: const Text("Change Image", style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Submit Request", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Section Card
Widget _sectionCard({required String title, required String subtitle, required Widget child}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 2,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black)),
          const Divider(height: 20, thickness: 1, color: Colors.blue),
          child,
        ],
      ),
    ),
  );
}

/// Text Field
  Widget _textField(TextEditingController controller, String label, IconData icon, String errorMsg,
      {TextInputType type = TextInputType.text, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon),
      keyboardType: type,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) return errorMsg;
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Please enter a valid email";
        if (label == "Contact Number") {
          if (!RegExp(r'^\d{11}$').hasMatch(value)) {
            return "Contact number must be exactly 11 digits";
          }
        }
        return null;
      },
    );
  }

/// Input Decoration
InputDecoration inputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.black),
    prefixIcon: Icon(icon, color: const Color.from(alpha: 1, red: 0.086, green: 0.522, blue: 0.875)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 2)),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    fillColor: Colors.white,
    filled: true,
  );
}
}

