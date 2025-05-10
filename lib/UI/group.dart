// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drivepay/UI/createGroup.dart';
import 'package:drivepay/logic/group/group_controller.dart';
import 'package:drivepay/UI/component/group_card.dart';
import 'package:drivepay/UI/component/list_modal.dart';
import 'package:drivepay/UI/component/confirm_dialog.dart';
import 'package:drivepay/UI/component/edit_list_dialog.dart';
class GroupPage extends ConsumerStatefulWidget {
  const GroupPage({super.key});
  @override
  ConsumerState<GroupPage> createState() => _GroupPageState();
}
class _GroupPageState extends ConsumerState<GroupPage> {
  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(groupControllerProvider);
    // ignore: unused_local_variable
    final controller = ref.read(groupControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'グループ一覧',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff45c4b0),
      ),
      backgroundColor: const Color(0xffDCFFF9),
      floatingActionButton: FloatingActionButton(
        heroTag: 'uniqueGroupPageFAB',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGroupPage()),
          );
        },
        backgroundColor: const Color(0xff45c4b0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: groupState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupState.groups.isEmpty
              ? Center(
                 child: Text(
                    'グループがありません\n右下の+ボタンから作成してください',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                      ),
                )
              : ListView.builder(
                  itemCount: groupState.groups.length,
                  itemBuilder: (context, index) {
                    final group = groupState.groups[index];
                    return GroupCard(
                      title: group['name'],
                      subtitle: '${group['members'].length}名のメンバー',
                      onTap: () => _showMembersModal(group['members']),
                      menuItems: [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Color(0xFF45C4B0)),
                              SizedBox(width: 8),
                              Text('編集'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('削除', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onMenuSelected: (value) {
                        if (value == 'edit') {
                          _showEditGroupDialog(group);
                        } else if (value == 'delete') {
                          _showDeleteConfirmDialog(group['id'], group['name']);
                        }
                      },
                    );
                  },
                ),
    );
  }
  void _showDeleteConfirmDialog(String groupId, String groupName) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'グループの削除',
        content: '「$groupName」を削除してもよろしいですか？',
        confirmText: '削除',
        onConfirm: () async {
          try {
            await ref.read(groupControllerProvider.notifier).deleteGroup(groupId);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('グループを削除しました'),
                  backgroundColor: Color(0xff45c4b0),
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('グループの削除に失敗しました'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }
  void _showMembersModal(List<String> members) {
    showDialog(
      context: context,
      builder: (context) => ListModal(
        title: 'メンバー一覧',
        items: members,
        itemIcon: Icons.person,
      ),
    );
  }
  void _showEditGroupDialog(Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (context) => EditListDialog(
        title: 'グループを編集',
        nameLabel: 'グループ名',
        nameHint: 'グループ名を入力',
        nameInitialValue: group['name'],
        itemsLabel: 'メンバー',
        itemsInitialValue: List<String>.from(group['members']),
        itemHint: 'メンバー名を入力',
        buttonText: '更新',
        onUpdate: (name, members) async {
          try {
            await ref.read(groupControllerProvider.notifier).updateGroup(
              group['id'],
              name,
              members,
            );
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('グループを更新しました'),
                  backgroundColor: Color(0xff45c4b0),
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('グループの更新に失敗しました'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
