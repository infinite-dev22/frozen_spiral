import 'dart:math';

import 'package:async_searchable_dropdown/async_searchable_dropdown.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown(
      {super.key, required this.list, this.onChanged, required this.hint});

  final List<String> list;
  final String hint;
  final Function(String?)? onChanged;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return _buildSearchableDropdown();
  }

  Future<List<String>> getData(String? search) async {
    if (Random().nextBool()) throw 'sdd';
    return widget.list.where((e) => e.contains(search ?? '')).toList();
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
              remoteItems: (value) => getData((value!.length > 2) ? value : ''),
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
                hintText: widget.hint,
                hintStyle: const TextStyle(
                    fontSize: 16, color: AppColors.inActiveColor),
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
