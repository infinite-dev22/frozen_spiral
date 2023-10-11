import 'package:flutter/material.dart';

List modules = [
  {'icon': Icons.local_activity_outlined, 'name': 'Activities'},
  {'icon': Icons.list_rounded, 'name': 'Requisitions'},
  {'icon': Icons.calendar_month_rounded, 'name': 'Diary'},
  {'icon': Icons.task_outlined, 'name': 'Tasks'},
  {'icon': Icons.handshake_outlined, 'name': 'Engagements'},
  {'icon': Icons.bar_chart_rounded, 'name': 'Reports'},
];

List files = [
  {
    'name': 'Test name',
    'number': 'Test number',
    'date': '10/02/2023',
    'client': 'Test Client',
  },
];

List activities = [
  {
    'name': 'Test name',
    'date': '10/02/2023',
    'doneBy': 'Test Client',
  },
];

List notifications = [];
List locations = [];

Map<String, dynamic> profile = {
  'picture': 'assets/images/user_profile.jpg',
  'gender': 'Male',
  'email': 'adamfrostymundane@globalmain.build',
  'personal_email': 'adamfrostymundane@testmain.build',
  'telephone': '0123456789',
  'dob': '01/10/2000',
  'height': '175 cm',
  'code': 'CD-675189',
  'id_number': 'IDN65617658976571CWM',
  'nssf_number': '69867758567587567'
};
