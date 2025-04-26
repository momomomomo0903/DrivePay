// ignore_for_file: file_names, use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drivepay/UI/component/input_text.dart';
import 'package:drivepay/logic/group/group_creation_controller.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(groupCreationControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '新規グループ作成',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff45c4b0),
      ),
      backgroundColor: const Color(0xffDCFFF9),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'グループ名',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InputText(
                  controller: controller.groupNameController,
                  hintText: 'グループ名を入力',
                  width: double.infinity,
                  icon: Icons.group,
                ),
                const SizedBox(height: 24),
                const Text(
                  'メンバー',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...controller.memberManagement.memberControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final memberController = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InputText(
                            controller: memberController,
                            hintText: 'メンバー名を入力',
                            width: double.infinity,
                            icon: Icons.person,
                          ),
                        ),
                        if (controller.memberManagement.memberControllers.length > 1 && index > 0)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFdf5656)),
                            onPressed: () {
                              setState(() {
                                controller.memberManagement.removeMember(index);
                              });
                            },
                          ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      controller.memberManagement.addMember();
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF45C4B0), size: 24),
                  label: const Text('メンバーを追加', style: TextStyle(color: Color(0xFF45C4B0))),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading ? null : () => controller.createGroup(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff45c4b0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'グループを作成',
                            style: TextStyle(
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
          if (controller.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
