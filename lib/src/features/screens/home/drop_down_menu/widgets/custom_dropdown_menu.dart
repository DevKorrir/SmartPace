import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/screens/home/drop_down_menu/controllers/menu_controller.dart';

class CustomDropdownMenu extends StatelessWidget {
  final DmenuController menuController = Get.find<DmenuController>();

  CustomDropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItemModel>(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.black54,
      ),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      offset: const Offset(0, 40),
      itemBuilder: (BuildContext context) {
        return menuController.menuItems.map((MenuItemModel item) {
          return PopupMenuItem<MenuItemModel>(
            value: item,
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: item.isLogout ? Colors.red : Colors.grey[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  item.title,
                  style: TextStyle(
                    color: item.isLogout ? Colors.red : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (MenuItemModel item) {
        menuController.selectMenuItem(item);
      },
    );
  }
}

