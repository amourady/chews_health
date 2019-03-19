

// Holds details of a menu item
class MenuItem {
  String restaurant;
  String name;
  var calories;
  var protein;
  var carbs;
  var fat;
  
  
  MenuItem (String newRes, String newName, var newCal, var newPro, var newCar, var newFat) {
    restaurant = newRes;
    name = newName;
    calories = newCal;
    protein = newPro;
    carbs = newCar;
    fat = newFat;
  }
}