enum IngridientType { grain, vegetable, meat, diary, fruit, crafted, spices }

class Ingridient {
  final String id;
  final String name;
  final IngridientType type;
  final double calories;

  const Ingridient({
    required this.id,
    required this.name,
    required this.type,
    required this.calories,
  });
}
