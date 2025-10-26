class FoodScan {
  final int? id;
  final String foodName;
  final double calories;
  final String protein;
  final String carbs;
  final String fat;
  final String imagePath;
  final DateTime timestamp;

  FoodScan({
    this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imagePath,
    required this.timestamp,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create from Map (from database)
  factory FoodScan.fromMap(Map<String, dynamic> map) {
    return FoodScan(
      id: map['id'],
      foodName: map['foodName'],
      calories: map['calories'],
      protein: map['protein'],
      carbs: map['carbs'],
      fat: map['fat'],
      imagePath: map['imagePath'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
