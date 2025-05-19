import 'package:flutter/material.dart';

class RepeatWidgetReminders extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  const RepeatWidgetReminders({super.key, this.onChanged});

  @override
  State<RepeatWidgetReminders> createState() => _RepeatWidgetRemindersState();
}

class _RepeatWidgetRemindersState extends State<RepeatWidgetReminders> {
  String selected = 'Once';
  final List<String> options = ['Once', 'Daily', 'Monthly'];

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
            options.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TextButton(
                  onPressed: () {
                    setState(() => selected = option);
                    if (widget.onChanged != null) widget.onChanged!(option);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        selected == option
                            ? Color(0xFF41D5C5) 
                            : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Color(0xFF41D5C5),

                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: selected == option ? Colors.white : Colors.blue,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
