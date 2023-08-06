enum IngredientType {
  grain,
  vegetable,
  meat,
  diary,
  fruit,
  spices,
  oil,
  product,
  sauce,
}

class Ingredient {
  final String id;
  final String name;
  final IngredientType type;

  const Ingredient({
    required this.id,
    required this.name,
    required this.type,
  });
}