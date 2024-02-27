import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:smart_case/database/local/notifications.dart';
import 'package:smart_case/theme/color.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({
    super.key,
    required this.title,
    required this.time,
    required this.body,
    required this.read,
    required this.box,
    required this.index,
    required this.onDismissed,
  });

  final String title;
  final String time;
  final String body;
  final bool read;
  final Box<Notifications> box;
  final int index;
  final Function() onDismissed;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  late bool _showContent;

  final double _height = 200;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => setState(() {
        _showContent = !_showContent;
        widget.box.getAt(widget.index)!.read = true;
      }),
      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: ValueKey("${widget.title}-${widget.title}-${Random.secure()}"),
        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                widget.onDismissed;
                dispose();
              },
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: Card(
          color: AppColors.white,
          elevation: 2,
          margin: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                          color:
                              widget.read ? AppColors.darker : AppColors.gray,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.time,
                      style: const TextStyle(
                        color: AppColors.inActiveColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _showContent
                    ? SizedBox(
                        height: _height,
                        child: Text(
                          widget.body,
                          style: TextStyle(
                              color: widget.read
                                  ? AppColors.darker
                                  : AppColors.gray,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    : Text(
                        widget.body,
                        style: TextStyle(
                            color:
                                widget.read ? AppColors.darker : AppColors.gray,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _showContent = false;
  }
}
