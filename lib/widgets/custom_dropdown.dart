import 'package:dropdown_button2/dropdown_button2.dart';
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
    return _buildBody();
  }

  _buildBody() {
    TextEditingController sampleController = TextEditingController();

    return Column(
      children: [
        (widget.value.isNotEmpty && widget.value != '')
            ? DropdownButtonFormField2<String>(
                dropdownSearchData: DropdownSearchData(
                  searchController: sampleController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      onChanged: widget.onSearch,
                      controller: sampleController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Search for an item...',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().contains(searchValue);
                  },
                ),
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    sampleController.clear();
                    widget.list.clear();
                    widget.list.add('');
                    setState(() {});
                  }
                },
                value: widget.value,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textBoxColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                hint: Text(
                  widget.placeHolder,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.inActiveColor,
                  ),
                ),
                items: widget.list
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select ${widget.placeHolder}.';
                  }
                  return null;
                },
                onChanged: widget.onChanged,
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(right: 8),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 24,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              )
            : DropdownButtonFormField2<String>(
                dropdownSearchData: DropdownSearchData(
                  searchController: sampleController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: sampleController,
                      onChanged: widget.onSearch,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Search for an item...',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().contains(searchValue);
                  },
                ),
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    sampleController.clear();
                    widget.list.clear();
                    widget.list.add('');
                    setState(() {});
                  }
                },
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textBoxColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                hint: Text(
                  widget.placeHolder,
                  style: const TextStyle(fontSize: 14),
                ),
                items: widget.list
                    .map((item) => (item == '')
                        ? DropdownMenuItem<String>(
                            enabled: false,
                            value: '',
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )
                        : DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select ${widget.placeHolder}.';
                  }
                  return null;
                },
                onChanged: widget.onChanged,
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(right: 8),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 24,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
