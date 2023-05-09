import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  var valueController = TextEditingController();
  double? dollarVal;
  double convertedVal = 0;

  void convert() {
    convertedVal = dollarVal! * double.parse(valueController.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('rates').get(),
          builder: (context, snapshot) {
            var doc = snapshot.data?.docs;
            doc?.forEach(
              (element) {
                if (element.data().containsKey('usdollar') &&
                    element.data().containsKey('peso')) {
                  dollarVal = double.parse(element.get('usdollar').toString());
                }
              },
            );
            print('$dollarVal');
            return Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: valueController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: convert,
                    child: const Text('CONVERT'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      convertedVal.toString(),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
