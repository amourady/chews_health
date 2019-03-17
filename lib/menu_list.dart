//menu_list.dart

import 'package:flutter/material.dart';

import 'menu_card.dart';
import 'menuItem_model.dart';

class MenuList extends StatelessWidget {
  final List<MenuItem> menuItems;
  MenuList(this.menuItems);

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, int) {
        return MenuCard(menuItems[int]);
      },
    );
  }


}