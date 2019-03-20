//menu_list.dart

import 'package:flutter/material.dart';

import 'menu_card.dart';
import 'menuItem_model.dart';

class MenuList extends StatefulWidget {
    final List<MenuItem> menuItems;
    MenuList(this.menuItems);

    @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {


  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: widget.menuItems.length,
      itemBuilder: (context, int) {
        return MenuCard(widget.menuItems[int]);
      },
    );
  }


}