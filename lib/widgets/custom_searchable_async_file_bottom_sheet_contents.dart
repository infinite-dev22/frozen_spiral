import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/bottom_search_item.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

import '../database/file/file_model.dart';

class AsyncSearchableSmartFileBottomSheetContents extends StatefulWidget {
  const AsyncSearchableSmartFileBottomSheetContents(
      {super.key,
      required this.hint,
      required this.list,
      this.onTap,
      this.onSearch,
      required this.isLoading});

  final String hint;
  final List<SmartFile> list;
  final Function(SmartFile?)? onTap;
  final Function(String)? onSearch;
  final bool isLoading;

  @override
  State<AsyncSearchableSmartFileBottomSheetContents> createState() =>
      _AsyncSearchableSmartFileBottomSheetContentsState();
}

class _AsyncSearchableSmartFileBottomSheetContentsState
    extends State<AsyncSearchableSmartFileBottomSheetContents> {
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
        !widget.isLoading
            ? Expanded(
                child: ListView.builder(
                  itemCount: widget.list.length,
                  itemBuilder: (context, index) => SearchItem<SmartFile>(
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
