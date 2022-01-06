import 'package:flutter/material.dart';

class DataTracker extends StatelessWidget {
  final String title;
  final String totalValue;
  final String additionalValue;

  const DataTracker(
      {Key? key,
      required this.title,
      required this.totalValue,
      required this.additionalValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gap = 12.0;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildLabel(),
        const SizedBox(height: gap),
        Text(
          totalValue,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: gap),
        Text(additionalValue,
            style: const TextStyle(fontWeight: FontWeight.w100))
      ]),
    );
  }

  Widget _buildLabel(){
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration:
      BoxDecoration(border: Border.all(width: 1, color: Colors.white)),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }



}
