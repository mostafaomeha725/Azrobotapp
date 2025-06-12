import 'package:flutter/material.dart';

class EditTextFieldWidget extends StatefulWidget {
  final String title;
  final String text;
  final Function(String) onChanged;
  final Future<void> Function(String) onSubmit;

  const EditTextFieldWidget({
    super.key,
    required this.title,
    required this.text,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  State<EditTextFieldWidget> createState() => _EditTextFieldWidgetState();
}

class _EditTextFieldWidgetState extends State<EditTextFieldWidget> {
  late TextEditingController controller;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.title);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final value = controller.text.trim();
    if (value.isNotEmpty) {
      await widget.onSubmit(value);
      setState(() => isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(widget.text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1752A8),
                )),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
        
            child: Row(
              children: [
                Expanded(
                  child: isEditing
                      ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                        child: TextField(
                          
                            controller: controller,
                            onChanged: widget.onChanged,
                            autofocus: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                      )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 8),
                          child: Text(
                            controller.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                ),
                IconButton(
                  icon: Icon(isEditing ? Icons.check : Icons.edit),
                  onPressed: () {
                    if (isEditing) {
                      _submit();
                    } else {
                      setState(() => isEditing = true);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
