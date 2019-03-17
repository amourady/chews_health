//menu_card.dart

import 'package:flutter/material.dart';
import 'main.dart'; // for updateCaloriesLeft()
import 'menuItem_model.dart';


class MenuCard extends StatefulWidget {
  final MenuItem menuItem;

  MenuCard(this.menuItem);
  @override
  _MenuCardState createState() => _MenuCardState(menuItem);
}

class _MenuCardState extends State<MenuCard> {
  MenuItem menuItem;

  _MenuCardState(this.menuItem);

  Widget get menuCard {
    return Container(
      width: 300.0,
      height: 115.0,
      child: Card(
        
        color: Colors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 3.0,
            bottom: 1.0,
            left: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(widget.menuItem.name,
                  style: Theme.of(context).textTheme.subhead),

              Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add_circle),
                    onPressed: () { 
                      updateCaloriesLeft(menuItem.calories);
                    },
                    ),

                  Text(' Calories: ${widget.menuItem.calories}      '),

                  Text('${minRunningToBurn(widget.menuItem.calories, testWeight).toStringAsFixed(0)} min run'),

                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget> [
                  Text('Protein: ${widget.menuItem.protein}'),
                  Text('Carbs: ${widget.menuItem.carbs}'),
                  Text('Fat: ${widget.menuItem.fat}'),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container (
        height: 110.0,
        child: Stack (
          children: <Widget> [
            Positioned (
              left: 50.0,
              child: menuCard,
            ),
        
            Positioned (top: 30.0, child: Icon(Icons.fastfood, size: 40.0)),
          ],
        ),
      ),
    );
  }
}