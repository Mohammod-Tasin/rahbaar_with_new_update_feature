import 'package:flutter/material.dart';

// Defines the data structure for a single card.
class CardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;


  const CardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

// This is the list of all items that will be displayed in the GridView.
// By keeping it in a separate file, your UI code stays clean.
const List<CardItem> cardItems = [
  CardItem(
    title: "Alumni page",
    subtitle: "Get Info of Alumni's connected to Tabligh",
    icon: Icons.school_rounded,
    color: Color(0xFF000832),
  ),
  CardItem(
    title: "Current Student Page",
    subtitle: "Get Info of current students connected to Tabligh",
    icon: Icons.people_rounded,
    color: Color(0xFF000832),
  ),
  // CardItem(
  //   title: "Job Board",
  //   subtitle: "New opportunities",
  //   icon: Icons.work,
  //   color: Colors.black,
  // ),
  // CardItem(
  //   title: "News",
  //   subtitle: "Latest updates",
  //   icon: Icons.article,
  //   color: Colors.black,
  // ),
  // CardItem(
  //   title: "Gallery",
  //   subtitle: "Event photos",
  //   icon: Icons.photo_album,
  //   color: Colors.black,
  // ),
  // CardItem(
  //   title: "Mentorship",
  //   subtitle: "Connect with mentors",
  //   icon: Icons.school,
  //   color: Colors.black,
  // ),
  CardItem(
    title: "Queries or Suggestions",
    subtitle: "Any suggestions or queries are welcomed",
    icon: Icons.comment_rounded,
    color: Color(0xFF000832),
  ),
];