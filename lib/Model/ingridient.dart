enum IngridientType {
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

enum Unit {
  // solids
  tableSpoon,
  teaSpoon,
  piece,
  grams,
  // liquids
  bottle,
  litre,
  miliLitre,
}

class Quantity {
  Unit unit;
  double count;
  Quantity(this.unit, this.count);
}

class Ingridient {
  final String id;
  final String name;
  final IngridientType type;

  const Ingridient({
    required this.id,
    required this.name,
    required this.type,
  });
}
