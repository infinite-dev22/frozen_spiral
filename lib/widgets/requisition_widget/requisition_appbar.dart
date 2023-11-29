import 'package:flutter/material.dart';
import 'package:smart_case/widgets/requisition_widget/requisition_filter.dart';

import '../custom_textbox.dart';

class RequisitionAppBar extends StatelessWidget {
  const RequisitionAppBar(
      {super.key,
      this.search = '',
      required this.onChanged,
      required this.filterController,
      required this.filters});

  final String search;
  final Function(String) onChanged;
  final TextEditingController filterController;
  final List<DropdownMenuItem> filters;

  @override
  Widget build(BuildContext context) {
    return _buildAppBar(context);
  }

  _buildAppBar(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: CustomTextBox(
              hint: "Search $search",
              prefix: const Icon(Icons.search, color: Colors.grey),
              onChanged: onChanged,
              autoFocus: false,
            )),
            const SizedBox(
              width: 20,
            ),
            RequisitionFilter(
              menuItems: filters,
              bgColor: Colors.white,
              icon: Icons.filter_list_rounded,
              onChanged: (value) {
                filterController.text = value!;
              },
            ),
          ],
        ),
      ],
    );
  }
}
