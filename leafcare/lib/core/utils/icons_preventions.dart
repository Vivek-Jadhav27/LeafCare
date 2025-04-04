import 'package:flutter/material.dart';

class IconsPreventions {
  static final Map<String, Map<String, dynamic>> preventionIconMapping = {
    "resistant": {"icon": Icons.spa, "color": Colors.green}, // Healthy plant
    "rotate": {
      "icon": Icons.autorenew,
      "color": Colors.orange
    }, // Crop rotation
    "irrigation": {
      "icon": Icons.water_drop,
      "color": Colors.blue
    }, // Water control
    "moisture": {
      "icon": Icons.opacity,
      "color": Colors.blueAccent
    }, // Water/Moisture
    "prune": {
      "icon": Icons.content_cut,
      "color": Colors.brown
    }, // Pruning branches
    "fertilization": {
      "icon": Icons.eco,
      "color": Colors.greenAccent
    }, // Fertilizers/Soil health
    "sanitation": {
      "icon": Icons.cleaning_services,
      "color": Colors.grey
    }, // Cleaning tools
    "monitor": {
      "icon": Icons.visibility,
      "color": Colors.deepPurple
    }, // Regular monitoring
    "mulch": {
      "icon": Icons.layers,
      "color": Colors.deepOrange
    }, // Mulching soil
    "humidity": {
      "icon": Icons.ac_unit,
      "color": Colors.lightBlue
    }, // Controlling humidity
    "fungicide": {
      "icon": Icons.science,
      "color": Colors.purple
    }, // Fungicide application
    "pesticide": {
      "icon": Icons.bug_report,
      "color": Colors.red
    }, // Pest control
    "barrier": {
      "icon": Icons.security,
      "color": Colors.blueGrey
    }, // Protective barriers
    "spacing": {
      "icon": Icons.grid_on,
      "color": Colors.teal
    }, // Proper plant spacing
    "drainage": {
      "icon": Icons.landscape,
      "color": Colors.brown
    }, // Improving soil drainage
    "nutrition": {"icon": Icons.local_florist, "color": Colors.green},
  };

  static Map<String, dynamic> getIconForPreventionMethod(String method) {
    for (var keyword in preventionIconMapping.keys) {
      if (method.toLowerCase().contains(keyword)) {
        return preventionIconMapping[keyword]!;
      }
    }
    return {
      "icon": Icons.help_outline,
      "color": Colors.grey
    }; // Default icon and color
  }
}
