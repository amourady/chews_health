# chews_health

A new Flutter project that recommends menu items when entering into a restaurant to reach the User's goal weight. Read 'Getting Started' to learn how to run Flutter apps.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## Project Details

- main.dart: Loads in user data then launches the application.

- app.dart: Initializes the application's home page by setting the start route to be login page.

- globals.dart: A bunch of commonly used data and functions.

- home.dart: The home page. Runs mutliple asynchronous API calls to provide recommendations.

- menu_card.dart, menu_list.dart, menuItem.dart: Wrappers for widgets representing menu items.

- profile.dart: The profile page. Allows users to edit and view personal model and health state.

- signup.dart: Signup page for the user to sign up for an account.

- login.dart: Login page for user to enter home page and use primarily functionality.

## How to Run

Following 'Getting Started' is a good way to figure out how to run this application. 

Otherwise, in short, setup Flutter, run 'flutter packages get', open your editor up to a .dart file in the lib folder, and start debugging using a physical Android device. 

Theoretically, iOS devices also should work since Flutter is a cross-platform framework, but debugging requires a MacOS machine.

Recommended to run on VSCode.
