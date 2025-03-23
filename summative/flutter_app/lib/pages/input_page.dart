// lib/pages/input_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/result_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/prediction_response.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final _rainfallController = TextEditingController();
  final _pesticidesController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _yearController = TextEditingController();

  String? _selectedArea;
  String? _selectedItem;

  bool _isLoading = false;
  String? _errorMessage;

  // List of countries (Areas) from the dataset
  final List<String> _areas = [
    'Albania', 'Algeria', 'Angola', 'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan',
    'Bahamas', 'Bangladesh', 'Belarus', 'Belgium', 'Botswana', 'Brazil', 'Bulgaria', 'Burkina Faso',
    'Burundi', 'Cameroon', 'Canada', 'Central African Republic', 'Chile', 'Colombia', 'Croatia',
    'Czech Republic', 'Denmark', 'Dominican Republic', 'Ecuador', 'Egypt', 'El Salvador', 'Eritrea',
    'Estonia', 'Finland', 'France', 'Germany', 'Ghana', 'Greece', 'Guatemala', 'Guinea', 'Guyana',
    'Haiti', 'Honduras', 'Hungary', 'India', 'Indonesia', 'Iraq', 'Ireland', 'Italy', 'Jamaica',
    'Japan', 'Kazakhstan', 'Kenya', 'Latvia', 'Lebanon', 'Lesotho', 'Libya', 'Lithuania', 'Madagascar',
    'Malawi', 'Malaysia', 'Mali', 'Mauritania', 'Mauritius', 'Mexico', 'Montenegro', 'Morocco',
    'Mozambique', 'Namibia', 'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua', 'Niger', 'Norway',
    'Pakistan', 'Papua New Guinea', 'Peru', 'Poland', 'Portugal', 'Qatar', 'Romania', 'Rwanda',
    'Saudi Arabia', 'Senegal', 'Slovenia', 'South Africa', 'Spain', 'Sri Lanka', 'Sudan', 'Suriname',
    'Sweden', 'Switzerland', 'Tajikistan', 'Thailand', 'Tunisia', 'Turkey', 'Uganda', 'Ukraine',
    'United Kingdom', 'Uruguay', 'Zambia', 'Zimbabwe'
  ];

  // List of crops (Items) from the dataset
  final List<String> _items = [
    'Cassava', 'Maize', 'Plantains and others', 'Potatoes', 'Rice, paddy',
    'Sorghum', 'Soybeans', 'Sweet potatoes', 'Wheat', 'Yams'
  ];

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
          'rainfall': double.parse(_rainfallController.text),
          'pesticides': double.parse(_pesticidesController.text),
          'temperature': double.parse(_temperatureController.text),
          'item': _selectedItem,
          'area': _selectedArea,
          'year': int.parse(_yearController.text),
        }),
      );

      if (response.statusCode == 200) {
        final prediction = PredictionResponse.fromJson(jsonDecode(response.body));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              prediction: prediction,
              area: _selectedArea!,
              item: _selectedItem!,
              year: int.parse(_yearController.text),
            ),
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
    _rainfallController.dispose();
    _pesticidesController.dispose();
    _temperatureController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Yield Predictor'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Crop and Environmental Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomDropdown(
                    value: _selectedArea,
                    label: 'Country',
                    items: _areas,
                    onChanged: (value) {
                      setState(() {
                        _selectedArea = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomDropdown(
                    value: _selectedItem,
                    label: 'Crop Type',
                    items: _items,
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _rainfallController,
                    label: 'Rainfall (mm/year)',
                    hint: 'Enter rainfall (0-5000)',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter rainfall';
                      }
                      final numValue = double.tryParse(value);
                      if (numValue == null || numValue < 0 || numValue > 5000) {
                        return 'Rainfall must be between 0 and 5000';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _temperatureController,
                    label: 'Temperature (°C)',
                    hint: 'Enter temperature (-10 to 50)',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter temperature';
                      }
                      final numValue = double.tryParse(value);
                      if (numValue == null || numValue < -10 || numValue > 50) {
                        return 'Temperature must be between -10 and 50';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _pesticidesController,
                    label: 'Pesticides (tonnes)',
                    hint: 'Enter pesticides (0-200,000)',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter pesticides';
                      }
                      final numValue = double.tryParse(value);
                      if (numValue == null || numValue < 0 || numValue > 200000) {
                        return 'Pesticides must be between 0 and 200,000';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _yearController,
                    label: 'Year',
                    hint: 'Enter year (1900-2025)',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter year';
                      }
                      final numValue = int.tryParse(value);
                      if (numValue == null || numValue < 1900 || numValue > 2025) {
                        return 'Year must be between 1900 and 2025';
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
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          )
                        : ElevatedButton(
                            onPressed: _predict,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Predict'),
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
}