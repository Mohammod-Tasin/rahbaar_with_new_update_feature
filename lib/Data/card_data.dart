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
    color: Colors.black,
  ),
  CardItem(
    title: "Current Student Page",
    subtitle: "Page is under construction",
    icon: Icons.people_rounded,
    color: Colors.black,
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
  CardItem(
    title: "Updates",
    subtitle: "You're using the latest version. You will be prompted here to install new versions as they become available.",
    icon: Icons.browser_updated_rounded,
    color: Colors.black,
  ),
  CardItem(
    title: "Queries or Suggestions",
    subtitle: "Any suggestions or queries are welcomed",
    icon: Icons.comment_rounded,
    color: Colors.black,
  ),
];