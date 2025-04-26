import 'package:flutter/material.dart';

class EditListDialog extends StatefulWidget {
  final String title;
  final String nameLabel;
  final String nameHint;
  final String nameInitialValue;
  final String itemsLabel;
  final List<String> itemsInitialValue;
  final String itemHint;
  final String buttonText;
  final Function(String, List<String>) onUpdate;

  const EditListDialog({
    super.key,
    required this.title,
    required this.nameLabel,
    required this.nameHint,
    required this.nameInitialValue,
    required this.itemsLabel,
    required this.itemsInitialValue,
    required this.itemHint,
    required this.buttonText,
    required this.onUpdate,
  });

  @override
  State<EditListDialog> createState() => _EditListDialogState();
}

class _EditListDialogState extends State<EditListDialog> {
  late final TextEditingController nameController;
  late List<String> currentItems;
  late final TextEditingController newItemController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.nameInitialValue);
    currentItems = List<String>.from(widget.itemsInitialValue);
    newItemController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    newItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.nameLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: widget.nameHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.itemsLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...currentItems.map((item) => ListTile(
                title: Text(item),
                leading: const Icon(Icons.person),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      currentItems.remove(item);
                    });
                  },
                ),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: newItemController,
                        decoration: InputDecoration(
                          hintText: widget.itemHint,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Color(0xff45c4b0)),
                      onPressed: () {
                        if (newItemController.text.isNotEmpty) {
                          setState(() {
                            currentItems.add(newItemController.text);
                            newItemController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onUpdate(nameController.text, currentItems);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff45c4b0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.buttonText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 