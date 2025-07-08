import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<dynamic> requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    // Hardcoded user_id for testing
    final int userId = 1;

    final response = await http.post(
      Uri.parse("http://192.168.137.1/data_docuease/get_requests_by_user.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    final data = jsonDecode(response.body);
    if (data['success']) {
      setState(() {
        requests = data['requests'];
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Icon getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Icon(Icons.schedule, color: Colors.orange);
      case 'approved':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'rejected':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.info, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Request Status",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
      ),
      body: requests.isEmpty
          ? const Center(child: Text("No requests found."))
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: requests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final request = requests[index];
                final status = request['status'];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: getStatusIcon(status),
                    title: Text(
                      request['certificate_type'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status: $status",
                            style: TextStyle(color: getStatusColor(status))),
                        const SizedBox(height: 4),
                        Text("Requested on: ${request['created_at']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
