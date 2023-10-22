import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_model.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/bottom_search_item.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

class AsyncSearchableBottomSheetContents<T extends SmartModel>
    extends StatefulWidget {
  const AsyncSearchableBottomSheetContents(
      {super.key,
      required this.hint,
      required this.list,
      this.onTap,
      this.onSearch,
      required this.isLoading});

  final String hint;
  final List<T> list;
  final Function(T?)? onTap;
  final Function(String)? onSearch;
  final bool isLoading;

  @override
  State<AsyncSearchableBottomSheetContents> createState() =>
      _AsyncSearchableBottomSheetContentsState<T>();
}

class _AsyncSearchableBottomSheetContentsState<T extends SmartModel>
    extends State<AsyncSearchableBottomSheetContents<T>> {
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
                  itemBuilder: (context, index) => SearchItem<T>(
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
