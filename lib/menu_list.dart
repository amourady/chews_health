//menu_list.dart

import 'package:flutter/material.dart';

import 'menu_card.dart';
import 'menuItem_model.dart';
import 'home.dart';

class MenuList extends StatefulWidget {
    final List<MenuItem> menuItems;
    final HomePageState parent;
    MenuList(this.menuItems, this.parent);

    @override
  MenuListState createState() => MenuListState();
}

class MenuListState extends State<MenuList> {


  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: widget.menuItems.length,
      itemBuilder: (context, int) {
        return MenuCard(widget.menuItems[int], widget.parent);
      },
    );
  }


}