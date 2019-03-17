//menu_card.dart

import 'package:flutter/material.dart';
import 'main.dart'; // for getting MenuItem class -- but we should move MenuItem into menuItem_model.dart





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
    // A new container
    // The height and width are arbitrary numbers for styling.
    return Container(
      width: 300.0,
      height: 115.0,
      child: Card(
        
        color: Colors.lightBlue,
        // Wrap children in a Padding widget in order to give padding.
        child: Padding(
          // The class that controls padding is called 'EdgeInsets'
          // The EdgeInsets.only constructor is used to set
          // padding explicitly to each side of the child.
          padding: const EdgeInsets.only(
            top: 3.0,
            bottom: 1.0,
            left: 10.0,
          ),
          // Column is another layout widget -- like stack -- that
          // takes a list of widgets as children, and lays the
          // widgets out from top to bottom.
          child: Column(
            // These alignment properties function exactly like
            // CSS flexbox properties.
            // The main axis of a column is the vertical axis,
            // `MainAxisAlignment.spaceAround` is equivalent of
            // CSS's 'justify-content: space-around' in a vertically
            // laid out flexbox.
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(widget.menuItem.name,
                  // Themes are set in the MaterialApp widget at the root of your app.
                  // They have default values -- which we're using because we didn't set our own.
                  // They're great for having consistent, app-wide styling that's easily changed.
                  style: Theme.of(context).textTheme.subhead),
              // Text(widget.menuItem.restaurant,
              //     style: Theme.of(context).textTheme.body1),



              Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add_circle),
                      onPressed: () => print("Pressed the button for food item ${widget.menuItem.name}"),
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