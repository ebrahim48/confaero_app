import 'package:flutter/material.dart';

class AnnouncementModel {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final String? organizer;
  final String date;
  final IconData? secondaryIcon;

  AnnouncementModel({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    this.organizer,
    required this.date,
    this.secondaryIcon,
  });

  // From JSON - API theke data ashle
  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      icon: Icons.campaign, // API theke icon name ashle parse korte hobe
      iconColor: Colors.black,
      backgroundColor: Color(int.parse(json['backgroundColor'] ?? '0xFFE8F5E9')),
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      organizer: json['organizer'],
      date: json['date'] ?? '',
      secondaryIcon: json['isPinned'] == true ? Icons.push_pin : null,
    );
  }

  // To JSON - API te data pathate hole
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'organizer': organizer,
      'date': date,
      'isPinned': secondaryIcon != null,
    };
  }
}