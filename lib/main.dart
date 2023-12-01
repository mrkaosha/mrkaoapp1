import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_database/firebase_database.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Somewhere in your application, trigger that the user is online:
  DatabaseReference ref = FirebaseDatabase.instance.ref("users/123/status");
  await ref.set(true);
// And after;
// Create an OnDisconnect instance for your ref and set to false,
// the Firebase backend will then only set the value on your ref to false
// when your client goes offline.
  OnDisconnect onDisconnect = ref.onDisconnect();
  await onDisconnect.set(false);

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
