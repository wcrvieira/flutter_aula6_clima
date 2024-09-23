import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
 {
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController(); 

  String _temperature = '';
  String _umidade = '';

  Future<void> getWeather() async {
  final latitude = double.parse(_latitudeController.text);
  final longitude = double.parse(_longitudeController.text);
  final response = await http.get(Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m&current=relative_humidity_2m'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    setState(() {
      _temperature = '${data['current']['temperature_2m']}°C';
      _umidade = '${data['current']['relative_humidity_2m']}%';
    });
  } else {
    // Handle error
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima atual'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column( 
          children: [
            TextField(
              controller: _latitudeController,
              decoration: const InputDecoration(labelText: 'Latitude'), 

            ),
            TextField(
              controller: _longitudeController,
              decoration: const InputDecoration(labelText: 'Longitude'), 

            ),
            ElevatedButton(
              onPressed: getWeather,
              child: const Text('Buscar clima atual'),
            ),
            Text('Temperatura: $_temperature'),
            Text('Umidade: $_umidade'),
          ],
        ),
      ),
    );
  }
}