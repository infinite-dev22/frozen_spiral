import 'dart:math';

import 'package:async_searchable_dropdown/async_searchable_dropdown.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown(
      {super.key,
      required this.placeHolder,
      required this.list,
      this.value = '',
      this.onChanged,
      this.onSearch});

  final String placeHolder;
  final List list;
  final String value;
  final Function(String?)? onChanged;
  final Function(String?)? onSearch;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return _buildSearchableDropdown();
  }

  final data = [
    "hello",
    "world",
    "hello world",
    "hello world 0",
    "hello world 1",
    "hello world 2",
    "hello world 3",
    "hello world 4",
    "hello world 5",
    "hello world 6",
    "hello world 7",
    "hello world 8",
    "hello world 9",
    "hello world 10",
    "hello world 11",
    "Romeo",
    "Juliet",
    "Jonathan",
    "Mark",
    "Brainer",
    "Aston",
  ];

  Future<List<String>> getData(String? search) async {
    await Future.delayed(const Duration(seconds: 2));
    if (Random().nextBool()) throw 'sdd';
    return data.where((e) => e.contains(search ?? '')).toList();
  }

  final ValueNotifier<String?> selectedValue = ValueNotifier<String?>(null);

  _buildSearchableDropdown() {
    return Column(
      children: [
        ValueListenableBuilder<String?>(
          valueListenable: selectedValue,
          builder: (context, value, child) {
            return SearchableDropdown<String>(
              value: value,
              dropDownListWidth: MediaQuery.of(context).size.width * .92,
              dropDownListHeight: 200,
              itemLabelFormatter: (value) {
                return value;
              },
              remoteItems: getData,
              onChanged: (value) {
                selectedValue.value = value;
              },
              inputDecoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textBoxColor,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Search for an item...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              borderRadius: BorderRadius.circular(10),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
