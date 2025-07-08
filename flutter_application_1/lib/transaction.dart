import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  final Map<String, dynamic> requestData;

  const TransactionPage({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    final String refNumber =
        "TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(4, 10)}";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "E-Receipt",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Certificate Request E-Receipt",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1.2),
                  const SizedBox(height: 10),

                  _receiptItem("Certificate Type", requestData['certificate_type'] ?? "N/A"),
                  _receiptItem("Full Name", requestData['full_name'] ?? "N/A"),
                  _receiptItem("Date Submitted", requestData['submitted_at'] ?? "N/A"),
                  _receiptItem("Status", requestData['status'] ?? "N/A"),
                  _receiptItem("Reference Number", refNumber),

                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      "This receipt serves as proof of your document request.\nPlease keep a copy for reference.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _receiptItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
