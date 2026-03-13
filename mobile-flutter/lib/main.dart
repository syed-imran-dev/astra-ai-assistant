import 'package:flutter/material.dart';
import 'services/api_service.dart';

// 1. The Global Entry Point (Must be outside the class)
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AxiomDashboard(),
  ));
}

class AxiomDashboard extends StatefulWidget {
  const AxiomDashboard({super.key});

  @override
  State<AxiomDashboard> createState() => _AxiomDashboardState();
}

class _AxiomDashboardState extends State<AxiomDashboard> {
  // 2. Define Class Variables (These must be INSIDE the State class)
  final AxiomApiService _api = AxiomApiService();
  final TextEditingController _input = TextEditingController();
  
  String _explanation = "Welcome to Axiom\nType a math problem below to see the 3D proof.";
  bool _isLoading = false;

  // 3. Define the Logic Function
  void _handleSolve() async {
    if (_input.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final response = await _api.solveMath(_input.text);
      final payload = response['payload'];

      setState(() {
        // Sanitize HTML for the fallback view
        _explanation = payload['text_solution']
            .toString()
            .replaceAll(RegExp(r'<[^>]*>'), ''); 
        _isLoading = false;
      });
      
      print("3D Data: ${payload['objects']}");
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Axiom: Spatial Math Tutor"),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // TOP: 3D Visualization Placeholder
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: const Center(
                child: Text(
                  "3D VISUALIZATION ACTIVE",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          
          // BOTTOM: The Solution Text
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: SelectableText(
                        _explanation,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ),
                  
                  if (_isLoading) const LinearProgressIndicator(),

                  const SizedBox(height: 10),
                  
                  TextField(
                    controller: _input,
                    onSubmitted: (_) => _handleSolve(),
                    decoration: InputDecoration(
                      hintText: "Enter a math problem...",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15), 
                        borderSide: BorderSide.none
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send), 
                        onPressed: _handleSolve
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
