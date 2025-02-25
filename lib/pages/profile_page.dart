import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../themes/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double _weight = 70.0;
  double _height = 170.0;
  List<WeightEntry> weightHistory = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore();
  }

  Future<void> _fetchDataFromFirestore() async {
    final user = _auth.currentUser;

    if (user != null) {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          _weight = data['weight'] ?? _weight;
          _height = data['height'] ?? _height;
          weightHistory = (data['weightHistory'] as List<dynamic>?)
              ?.map((entry) => WeightEntry(
            DateTime.parse(entry['date']),
            entry['weight'],
          ))
              .toList() ??
              [];
        });
      }
    }
  }

  Future<void> _updateFirestore() async {
    final user = _auth.currentUser;

    if (user != null) {
      final newEntry = {
        'date': DateTime.now().toIso8601String(),
        'weight': _weight,
      };

      weightHistory.add(WeightEntry(DateTime.now(), _weight));
      if (weightHistory.length > 7) {
        weightHistory.removeAt(0);
      }

      await _firestore.collection('users').doc(user.uid).set({
        'weight': _weight,
        'height': _height,
        'weightHistory': weightHistory
            .map((entry) => {'date': entry.date.toIso8601String(), 'weight': entry.weight})
            .toList(),
      });
    }
  }

  List<WeightEntry> _getLastWeekData() {
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
    return weightHistory.where((entry) => entry.date.isAfter(oneWeekAgo)).toList();
  }

  double _calculateBmi() {
    double heightInMeters = _height / 100;
    return _weight / (heightInMeters * heightInMeters);
  }

  void _updateWeight(String value) {
    setState(() {
      _weight = double.tryParse(value) ?? _weight;
    });
  }

  void _updateHeight(String value) {
    setState(() {
      _height = double.tryParse(value) ?? _height;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<WeightEntry, DateTime>> series = [
      charts.Series<WeightEntry, DateTime>(
        id: 'Weight',
        data: _getLastWeekData(),
        domainFn: (WeightEntry entry, _) => entry.date,
        measureFn: (WeightEntry entry, _) => entry.weight,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Dark Mode"),
                  CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                    onChanged: (value) =>
                        Provider.of<ThemeProvider>(context, listen: false).toogleTheme(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Update Weight and Height",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Weight (kg)",
                border: OutlineInputBorder(),
              ),
              onChanged: _updateWeight,
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Height (cm)",
                border: OutlineInputBorder(),
              ),
              onChanged: _updateHeight,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _updateFirestore();
                setState(() {});
              },
              child: const Text("Update"),
            ),
            const SizedBox(height: 20),
            Text(
              "BMI: ${_calculateBmi().toStringAsFixed(1)}",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: charts.TimeSeriesChart(
                series,
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeightEntry {
  final DateTime date;
  final double weight;

  WeightEntry(this.date, this.weight);
}
