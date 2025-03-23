// lib/pages/input_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/result_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/prediction_response.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final _salinityController = TextEditingController();
  final _waterTempController = TextEditingController();
  final _secchiDepthController = TextEditingController();
  final _airTempController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://summative-belf.onrender.com/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'salinity': double.parse(_salinityController.text),
          'water_temp': double.parse(_waterTempController.text),
          'secchi_depth': double.parse(_secchiDepthController.text),
          'air_temp': double.parse(_airTempController.text),
        }),
      );

      if (response.statusCode == 200) {
        final prediction =
            PredictionResponse.fromJson(jsonDecode(response.body));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(prediction: prediction),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Error: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to make prediction: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _salinityController.dispose();
    _waterTempController.dispose();
    _secchiDepthController.dispose();
    _airTempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Quality Predictor'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Water Quality Parameters',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _salinityController,
                  label: 'Salinity (ppt)',
                  hint: 'Enter salinity (0-10)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter salinity';
                    }
                    final numValue = double.tryParse(value);
                    if (numValue == null || numValue < 0 || numValue > 10) {
                      return 'Salinity must be between 0 and 10';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _waterTempController,
                  label: 'Water Temperature (°C)',
                  hint: 'Enter water temperature (0-40)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter water temperature';
                    }
                    final numValue = double.tryParse(value);
                    if (numValue == null || numValue < 0 || numValue > 40) {
                      return 'Water temperature must be between 0 and 40';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _secchiDepthController,
                  label: 'Secchi Depth (m)',
                  hint: 'Enter Secchi depth (0-5)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Secchi depth';
                    }
                    final numValue = double.tryParse(value);
                    if (numValue == null || numValue < 0 || numValue > 5) {
                      return 'Secchi depth must be between 0 and 5';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _airTempController,
                  label: 'Air Temperature (°C)',
                  hint: 'Enter air temperature (-20 to 50)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter air temperature';
                    }
                    final numValue = double.tryParse(value);
                    if (numValue == null || numValue < -20 || numValue > 50) {
                      return 'Air temperature must be between -20 and 50';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _predict,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            backgroundColor: Colors.blueAccent,
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text('Predict'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: validator,
    );
  }
}
