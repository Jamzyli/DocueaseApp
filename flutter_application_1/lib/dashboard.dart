import 'package:flutter/material.dart';
import 'request.dart';
import 'status.dart';
import 'transaction.dart';
import 'sign_in.dart';

void main() => runApp(MaterialApp(home: DashboardPage()));

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(serviceRequirements: serviceRequirements),
      RequestPage(),
      StatusPage(),
      TransactionPage(requestData: {},),
    ];
  }

  final Map<String, List<String>> serviceRequirements = {
    'REQUIREMENTS FOR LATE REGISTRATION OF BIRTH, MARRIAGE OR DEATH': [
      'Negative result from PSA.',
      'Affidavit of two (2) disinterested persons.',
      'Baptismal certificate.',
      'Marriage contract.',
      'Voter’s record.',
      'School records.',
      'Driver’s license.',
      'Land title.',
      'Any valid i.d.',
      'Cedula',
    ],
    'REQUIREMENTS FOR LEGITIMATION OF BIRTH': [
      'PSA birth certificate of the child to be legitimated.',
      'Joint Affidavit of legitimation of both parents.',
      'Marriage Contract of both parents.',
      'CENOMAR of both parents.',
      'Cedula of both parents.',
    ],
    'REQUIREMENTS FOR CHANGE OF SEX and/or DAY and/or MONTH IN THE DATE OF BIRTH (R.A. 10172)': [
      'PSA birth certificate (9 photocopies);',
      'Cedula; (1 copy)',
      'Supporting papers: (3 photocopies each)',
      'Baptismal certificate;',
      'Grade I School record;',
      'Marriage contract;',
      'Voter’s record;',
      'Driver’s license;',
      'Land title;',
      'Any valid i.d;',
      'NBI clearance;',
      'Police clearance;',
      'Clearance from employer if employed;',
      'Affidavit of non-employment if not employed;',
      'Newspaper publication and affidavit of publication;',
      'Medical records;',
      '*Medical Certificate (accredited gov’t. Physician) and Certificate of Authenticity from LCR. *(FOR CHANGE OF SEX ONLY).',
    ],
    'REQUIREMENTS FOR CHANGE OF FIRST NAME  (R.A.9048)': [
      'PSA birth certificate (9 photocopies);',
      'Cedula; (1 copy)',
      'Supporting papers: (3 photocopies each)',
      'Baptismal certificate;',
      'School records (diploma, transcript or card);',
      'Marriage contract;',
      'Voter’s record;',
      'Driver’s license;',
      'Land title;',
      'Any valid i.d;',
      'NBI clearance;',
      'Police clearance;',
      'Clearance from employer if employed;',
      'Affidavit of non-employment if not employed;',
      'Newspaper publication and affidavit of publication.',
    ],
    'REQUIREMENTS FOR CORRECTION OF CLERICAL ERROR (R.A.9048)': [
      'PSA birth certificate or Marriage Contract (9 photocopies); (document with error/s)',
      'Cedula; (1 copy)',
      'Supporting papers: (3 photocopies each)',
      'Baptismal certificate;',
      'School records (diploma, transcript or card);',
      'Marriage contract;',
      'Voter’s record;',
      'Driver’s license;',
      'Land title;',
      'Any valid i.d;',
    ],
    'APPLICATION AND ISSUANCE OF MARRIAGE LICENSE': [
      'Certified True Copy of Birth Certificate or Baptismal Certificates of both applicants',
      'If Widowed, certified true copy of death certificate of demise spouse',
      'If previous marriage was annulled, Copy of Court Decision and Absolute Decree of Finality from the Court',
      'Community Tax Certificates/Cedula of both applicants',
      'Family Planning and Counseling – Health Department Office, Social Service and Development (SSDD)',
      'Certificate of No Marriage (CENOMAR) PSA',
    ],
  };

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[900],
        title: Row(
          children: [
            Icon(Icons.account_balance, size: 26, color: Colors.white),
            SizedBox(width: 8),
            Text('Padre Garcia, Batangas', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('No new notifications'))),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
    );
  }
}

class HomePage extends StatelessWidget {
  final Map<String, List<String>> serviceRequirements;
  const HomePage({required this.serviceRequirements, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'Welcome to DocuEase',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[900]),
        ),
        SizedBox(height: 20),
        _buildNavigationCard(context, 'Request Certificates', 'Apply for certificates, transcripts, and other official documents', Icons.description, RequestPage()),
        _buildNavigationCard(context, 'Application Status', 'Monitor the status of your ongoing document requests', Icons.info_outline, StatusPage()),
        _buildNavigationCard(context, 'Transaction', 'See your partial receipt', Icons.receipt_long, TransactionPage(requestData: {},)),
        SizedBox(height: 30),
        Text('Other Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800])),
        SizedBox(height: 10),
        ...serviceRequirements.entries.map((entry) => Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 16),
                title: Text(entry.key, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                children: entry.value
                    .map((req) => ListTile(title: Text('• $req', style: TextStyle(fontSize: 14))))
                    .toList(),
              ),
            )),
      ],
    );
  }

  Widget _buildNavigationCard(BuildContext context, String title, String subtitle, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.blue[800]),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}
