import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ReminderHomePage(),
    );
  }
}

class ReminderHomePage extends StatefulWidget {
  const ReminderHomePage({super.key});

  @override
  _ReminderHomePageState createState() => _ReminderHomePageState();
}

class _ReminderHomePageState extends State<ReminderHomePage> {
  final List<String> daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  final List<String> activities = [
    'Wake up', 'Go to gym', 'Breakfast', 'Meetings', 'Lunch','Quick nap', 'Go to library', 'Dinner', 'Go to sleep'
  ];

  String? selectedDay;
  TimeOfDay selectedTime = TimeOfDay.now();
  String? selectedActivity;
  final AudioPlayer audioPlayer = AudioPlayer();

  List<Map<String, dynamic>> reminders = [];

Future<void> _playSound() async {
  try {
    await audioPlayer.play(UrlSource('https://assets.mixkit.co/active_storage/sfx/2574/2574-preview.mp3'));
  } catch (e) {
    log('Error playing sound: $e');
  }
}

void _scheduleReminder() {
  if (selectedDay != null && selectedActivity != null) {
    final now = DateTime.now();
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    setState(() {
      reminders.add({
        'day': selectedDay,
        'time': DateFormat.jm().format(scheduledTime),
        'activity': selectedActivity,
        'completed': false,
      });
    });

    Future.delayed(scheduledTime.difference(now), () {
      log('Reminder triggered! Playing sound.');
      _playSound();
    });

    setState(() {
      selectedDay = null;
      selectedActivity = null;
      selectedTime = TimeOfDay.now();
    });
  }
}

  void _toggleCompletion(int index) {
    setState(() {
      reminders[index]['completed'] = !reminders[index]['completed'];
    });
  }

  void _deleteReminder(int index) {
    setState(() {
      reminders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: const Text('Select Day'),
              value: selectedDay,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDay = newValue;
                });
              },
              items: daysOfWeek.map((day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Selected Time: ${selectedTime.format(context)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      setState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              hint: const Text('Select Activity'),
              value: selectedActivity,
              onChanged: (String? newValue) {
                setState(() {
                  selectedActivity = newValue;
                });
              },
              items: activities.map((activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleReminder,
              child: const Text('Set Reminder'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: reminders[index]['completed'],
                      onChanged: (bool? value) {
                        _toggleCompletion(index);
                      },
                    ),
                    title: Text(
                      '${reminders[index]['activity']} on ${reminders[index]['day']} at ${reminders[index]['time']}',
                      style: TextStyle(
                        decoration: reminders[index]['completed']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.black),
                      onPressed: () => _deleteReminder(index), 
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
