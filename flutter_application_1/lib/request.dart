import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For date formatting
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // For File class

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  // Ensure this URL is correct and accessible from your device/emulator
  final String apiUrl = "http://192.168.137.1/data_docuease/request_handler.php";

  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final contactNumberController = TextEditingController();
  final emailController = TextEditingController();
  String _selectedCertificateType = "Birth Certificate"; // Default value

  final dateOfBirthController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final dateOfMarriageController = TextEditingController();
  final spouseNameController = TextEditingController();
  final dateOfDeathController = TextEditingController();
  final placeOfDeathController = TextEditingController();

  File? _selectedImage; // Variable to store the picked image file

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

  // Function to clear certificate-specific controllers when type changes
  void _clearCertificateSpecificFields() {
    dateOfBirthController.clear();
    placeOfBirthController.clear();
    dateOfMarriageController.clear();
    spouseNameController.clear();
    dateOfDeathController.clear();
    placeOfDeathController.clear();
  }

  // Function to pick an image from gallery or camera
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery); // Or ImageSource.camera

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)), // Allow future dates for some cases
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade800, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade800, // Button text color
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
      return; // Stop if form is not valid
    }

    // Check if an image is selected
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

    // Convert image to Base64 string
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

    // Prepare data based on selected certificate type
    Map<String, dynamic> requestBody = {
      "certificate_type": _selectedCertificateType,
      "full_name": fullNameController.text,
      "address": addressController.text,
      "contact_number": contactNumberController.text,
      "email": emailController.text,
      "valid_id_base64": base64Image, // Send Base64 encoded image
      "file_extension": _selectedImage!.path.split('.').last, // Send file extension
      // Initialize all specific fields to null, then populate if relevant
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
          content: Text(data['message']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (data['success']) {
                  _formKey.currentState?.reset(); // Clear form on success
                  _clearCertificateSpecificFields();
                  setState(() {
                    _selectedImage = null; // Clear selected image
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
              readOnly: true, // Make it read-only so date picker is used
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
      appBar: AppBar(
        title: const Text(
          "Request Certificate",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 0, // Remove shadow
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Submit Your Request",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(height: 25),
                      DropdownButtonFormField<String>(
                        value: _selectedCertificateType,
                        decoration: _inputDecoration("Certificate Type", Icons.description),
                        items: const [
                          "Birth Certificate",
                          "Marriage Certificate",
                          "Death Certificate",
                        ].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedCertificateType = val!;
                            _clearCertificateSpecificFields(); // Clear fields on type change
                          });
                        },
                        validator: (value) => value == null ? 'Please select a certificate type' : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: fullNameController,
                        decoration: _inputDecoration("Full Name", Icons.person),
                        validator: (value) => value!.isEmpty ? 'Please enter full name' : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: addressController,
                        decoration: _inputDecoration("Address", Icons.home),
                        validator: (value) => value!.isEmpty ? 'Please enter address' : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: contactNumberController,
                        decoration: _inputDecoration("Contact Number", Icons.phone),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.isEmpty ? 'Please enter contact number' : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: emailController,
                        decoration: _inputDecoration("Email", Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildCertificateFields(), // Dynamically build fields
                      const SizedBox(height: 25),
                      // Valid ID Upload Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade300, width: 1.0),
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Upload Valid ID",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: _selectedImage == null
                                  ? TextButton.icon(
                                      onPressed: _pickImage,
                                      icon: Icon(Icons.upload_file, color: Colors.blue.shade600),
                                      label: Text(
                                        "Select Image",
                                        style: TextStyle(color: Colors.blue.shade800),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: BorderSide(color: Colors.blue.shade600),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Image.file(
                                          _selectedImage!,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          _selectedImage!.path.split('/').last,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                        TextButton.icon(
                                          onPressed: _pickImage, // Allow re-picking
                                          icon: Icon(Icons.change_circle, color: Colors.blue.shade600),
                                          label: Text(
                                            "Change Image",
                                            style: TextStyle(color: Colors.blue.shade800),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800, // Button background color
                          foregroundColor: Colors.white, // Button text color
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),                                                                                                          
                        child: const Text(
                          "Submit Request",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
