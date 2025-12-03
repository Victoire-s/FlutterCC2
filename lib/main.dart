import 'package:flutter/material.dart';
import 'slider_form_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SliderPage(),
    );
  }
}

class SliderPage extends StatefulWidget {
  const SliderPage({super.key});

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test SliderFormField')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SliderFormField(
                label: 'Âge',
                min: 0,
                max: 100,
                divisions: 100,
                initialValue: 18,
                validator: (value) =>
                    (value ?? 0) < 18 ? 'Doit être ≥ 18' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // OK
                  }
                },
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
