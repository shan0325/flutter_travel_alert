import 'package:flutter/material.dart';

class CountryDropdownButtonPage extends StatefulWidget {
  const CountryDropdownButtonPage({super.key});

  @override
  State<CountryDropdownButtonPage> createState() => _CountryDropdownButtonPageState();
}

class _CountryDropdownButtonPageState extends State<CountryDropdownButtonPage> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String> (
      value: null,
      hint: const Text('나라를 선택해주세요'),
      items: const [
        DropdownMenuItem(value: 'GH', child: Text('가나')),
        DropdownMenuItem(value: 'GA', child: Text('가봉')),
        DropdownMenuItem(value: 'GY', child: Text('가이아나')),
      ],
      onChanged: (String? value) {
        print(value);
      },
    );
  }
}