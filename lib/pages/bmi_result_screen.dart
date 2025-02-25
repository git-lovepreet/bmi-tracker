import 'package:flutter/material.dart';

class BmiResultScreen extends StatelessWidget {
  final double weight;
  final double height;
  final String gender;

  BmiResultScreen({
    required this.weight,
    required this.height,
    required this.gender,
  });

  String _calculateBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return "Normal weight";
    } else if (bmi >= 25.0 && bmi < 29.9) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightInMeters = height / 100;
    double bmi = weight / (heightInMeters * heightInMeters);
    String bmiCategory = _calculateBmiCategory(bmi);

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Result', style: theme.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your BMI is:',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                bmi.toStringAsFixed(1),
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Category: $bmiCategory',
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: 20),
              Text(
                'Gender: $gender',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Calculate Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.tertiary
                ),

              ),
            ],
        ),
      ),
    );
  }
}
