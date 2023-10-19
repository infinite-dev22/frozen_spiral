import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/bottom_search_item.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

import '../models/activity.dart';

class AsyncSearchableActivityBottomSheetContents extends StatefulWidget {
  const AsyncSearchableActivityBottomSheetContents(
      {super.key,
      required this.hint,
      required this.list,
      this.onTap,
      this.onSearch,
      required this.isLoading});

  final String hint;
  final List<Activity> list;
  final Function(Activity?)? onTap;
  final Function(String)? onSearch;
  final bool isLoading;

  @override
  State<AsyncSearchableActivityBottomSheetContents> createState() =>
      _AsyncSearchableActivityBottomSheetContentsState();
}

class _AsyncSearchableActivityBottomSheetContentsState
    extends State<AsyncSearchableActivityBottomSheetContents> {
  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: CustomTextBox(
            onChanged: widget.onSearch,
            hint: widget.hint,
            prefix: const Icon(Icons.search, color: Colors.grey),
            autoFocus: true,
          ),
        ),
        widget.isLoading
            ? Expanded(
                child: ListView.builder(
                  itemCount: widget.list.length,
                  itemBuilder: (context, index) => SearchItem<Activity>(
                    value: widget.list[index],
                    padding: 20,
                    color: AppColors.white,
                    onTap: widget.onTap,
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }
}
