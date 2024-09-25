# Reminder App

## Overview
The lib/main.dart has the actual basic Implementation

The Reminder App is a Flutter application designed to help users set daily reminders for their activities. It allows users to choose a day, set a time, and select an activity. Upon reaching the scheduled time, the app plays a sound to alert the user.

## Features

- **Select Day**: Choose a day of the week for the reminder.
- **Set Time**: Use a time picker to select the desired reminder time.
- **Select Activity**: Choose from a predefined list of activities.
- **Play Sound**: An audio alert plays when the reminder is triggered.
- **Toggle Completion**: Mark reminders as completed with a checkbox.
- **Delete Reminders**: Remove reminders from the list.

## Technologies Used

- **Flutter**: The app is built using the Flutter framework for cross-platform development.
- **Dart**: The programming language used for writing the application logic.
- **AudioPlayers**: A package for playing audio files.
- **Intl**: A package for formatting dates and times.

## Installation

To run the Reminder App, ensure you have Flutter installed. Follow these steps:

1. Clone the repository:
    git clone <https://github.com/kir-an/Reminder_App.git>
    cd reminder_app

2. Install dependencies:
    flutter pub get

3. Run the app:
    flutter run
