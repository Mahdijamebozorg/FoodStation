import 'package:food_app/Model/comment.dart';
import 'package:food_app/Model/food.dart';
import 'package:food_app/Model/ingredient.dart';

const dummyCats = [
  'Italian',
  'Quick',
  'Hamburgers',
  'German',
  'Light',
  'Exotic',
  'Breakfast',
  'Asian',
  'French',
  'Summer',
];

List<Ingredient> dummyIngs = const [
  Ingredient(
    id: "i1",
    name: "Spaghetti",
    type: IngredientType.product,
  ),
  Ingredient(
    id: "i2",
    name: "Tomato",
    type: IngredientType.vegetable,
  ),
  Ingredient(
    id: "i3",
    name: "Pepper",
    type: IngredientType.fruit,
  ),
  Ingredient(
    id: "i4",
    name: "Salt",
    type: IngredientType.spices,
  ),
  Ingredient(
    id: "i5",
    name: "Rice",
    type: IngredientType.grain,
  ),
  Ingredient(
    id: "i6",
    name: "Olive Oil",
    type: IngredientType.oil,
  ),
  Ingredient(
    id: "i7",
    name: "Onion",
    type: IngredientType.vegetable,
  ),
  Ingredient(
    id: "i8",
    name: "Spices",
    type: IngredientType.spices,
  ),
  Ingredient(
    id: "i9",
    name: "Cheese",
    type: IngredientType.diary,
  ),
  Ingredient(
    id: "i10",
    name: "White Bread",
    type: IngredientType.product,
  ),
  Ingredient(
    id: "i11",
    name: "Ham",
    type: IngredientType.meat,
  ),
  Ingredient(
    id: "i12",
    name: "Pineapple",
    type: IngredientType.fruit,
  ),
  Ingredient(
    id: "i13",
    name: "Butter",
    type: IngredientType.diary,
  ),
  Ingredient(
    id: "i14",
    name: "Cattle Hack",
    type: IngredientType.meat,
  ),
  Ingredient(
    id: "i15",
    name: "Cucumber",
    type: IngredientType.vegetable,
  ),
  Ingredient(
    id: "i16",
    name: "Ketchup",
    type: IngredientType.sauce,
  ),
  Ingredient(
    id: "i17",
    name: "Burger",
    type: IngredientType.meat,
  ),
  Ingredient(
    id: "i18",
    name: "Veal Cutlets",
    type: IngredientType.meat,
  ),
  Ingredient(
    id: "i19",
    name: "Egg",
    type: IngredientType.product,
  ),
  Ingredient(
    id: "i20",
    name: "Bread Crumbs",
    type: IngredientType.product,
  ),
  Ingredient(
    id: "i21",
    name: "Flour",
    type: IngredientType.product,
  ),
  Ingredient(
    id: "i22",
    name: "Butter",
    type: IngredientType.diary,
  ),
  Ingredient(
    id: "i23",
    name: "Vegetable Oil",
    type: IngredientType.oil,
  ),
  Ingredient(
    id: "i24",
    name: "Lemon slice",
    type: IngredientType.fruit,
  ),
  Ingredient(
    id: "i25",
    name: "Arugula",
    type: IngredientType.vegetable,
  ),
  Ingredient(
    id: "i26",
    name: "Lamb's Lettuce",
    type: IngredientType.vegetable,
  ),
  Ingredient(
    id: "i28",
    name: "Parsley",
    type: IngredientType.vegetable,
  ),
  Ingredient(
    id: "i29",
    name: "Fennel",
    type: IngredientType.vegetable,
  ),
  Ingredient(
    id: "i30",
    name: "Smoked Salmon",
    type: IngredientType.meat,
  ),
  Ingredient(
    id: "i31",
    name: "Mustard",
    type: IngredientType.spices,
  ),
  Ingredient(
    id: "i32",
    name: "Balsamic Vinegar",
    type: IngredientType.product,
  ),
  Ingredient(
    id: "i32",
    name: "Gelatine",
    type: IngredientType.product,
  ),
  Ingredient(
    id: "i32",
    name: "Orange Juice",
    type: IngredientType.fruit,
  ),
  Ingredient(
    id: "i32",
    name: "Sugar",
    type: IngredientType.spices,
  ),
  Ingredient(
    id: "i32",
    name: "Yoghurt",
    type: IngredientType.diary,
  ),
  Ingredient(
    id: "i32",
    name: "Creaml",
    type: IngredientType.diary,
  ),
  Ingredient(
    id: "i32",
    name: "Orange Peel",
    type: IngredientType.fruit,
  ),
];

Ingredient ing(String name) {
  return dummyIngs.firstWhere((ing) => ing.name == name);
}

List<Comment> dummyComments = [
  Comment(id: "c1", message: "tastes good", userId: "uid123", foodId: "m1"),
  Comment(id: "c1", message: "healthy and tasty", userId: "uid2315", foodId: "m1"),
];

List<Food> dummyfoods = [
  Food(
      id: 'm1',
      categories: [
        'Italian',
        'Quick',
      ],
      title: 'spaghetti with tomato sauce',
      affordability: Affordability.affordable,
      complexity: Complexity.simple,
      imageUrl: 'assets/images/Spaghetti.jpg',
      duration: 20,
      ingredients: [
        {"Tomato": Quantity(Unit.piece, 4)},
        {"Olive Oil": Quantity(Unit.tableSpoon, 4)},
        {"Onion": Quantity(Unit.piece, 1)},
        {"Spaghetti": Quantity(Unit.grams, 250)},
        {"Spices": null},
      ],
      steps: [
        'Cut the tomatoes and the onion into small pieces.',
        'Boil some water - add salt to it once it boils.',
        'Put the spaghetti into the boiling water - they should be done in about 10 to 12 minutes.',
        'In the meantime, heaten up some olive oil and add the cut onion.',
        'After 2 minutes, add the tomato pieces, salt, pepper and your other spices.',
        'The sauce will be done once the spaghetti are.',
        'Feel free to add some cheese on top of the finished dish.'
      ],
      isGlutenFree: false,
      isVegan: true,
      isLactoseFree: true,
      userId: "uid123"),
  Food(
      id: 'm2',
      categories: [
        'Quick',
      ],
      title: 'toast hawaii',
      affordability: Affordability.affordable,
      complexity: Complexity.simple,
      imageUrl: 'assets/images/Toast_Hawaii.jpg',
      duration: 10,
      ingredients: [
        {"Tomato": Quantity(Unit.piece, 4)},
        {"Ham": Quantity(Unit.piece, 1)},
        {"Pineapple": Quantity(Unit.piece, 1)},
        {"Cheese": Quantity(Unit.piece, 1)},
        {"Butter": Quantity(Unit.piece, 1)},
      ],
      steps: [
        'Butter one side of the white bread',
        'Layer ham, the pineapple and cheese on the white bread',
        'Bake the toast for round about 10 minutes in the oven at 200°C'
      ],
      isGlutenFree: false,
      isVegan: false,
      isLactoseFree: false,
      userId: "uid123"),
  Food(
      id: 'm3',
      categories: [
        'Quick',
        'Hamburgers',
      ],
      title: 'classic hamburger',
      affordability: Affordability.pricey,
      complexity: Complexity.simple,
      imageUrl: 'assets/images/Classic_Hamburger.jpg',
      duration: 45,
      ingredients: [
        {"Cattle Hack": Quantity(Unit.grams, 300)},
        {"Tomato": Quantity(Unit.piece, 1)},
        {"Cucumber": Quantity(Unit.piece, 1)},
        {"Onion": Quantity(Unit.piece, 1)},
        {"Ketchup": null},
        {"Burger": Quantity(Unit.piece, 2)},
      ],
      steps: [
        'Form 2 patties',
        'Fry the patties for c. 4 minutes on each side',
        'Quickly fry the buns for c. 1 minute on each side',
        'Bruch buns with ketchup',
        'Serve burger with tomato, cucumber and onion'
      ],
      isGlutenFree: false,
      isVegan: false,
      isLactoseFree: true,
      userId: "uid123"),
  Food(
      id: 'm4',
      categories: [
        'German',
      ],
      title: 'wiener schnitzel',
      affordability: Affordability.luxurious,
      complexity: Complexity.challenging,
      imageUrl: 'assets/images/Wiener_Schnitzel.jpg',
      duration: 60,
      ingredients: [
        {"Veal Cutlets": Quantity(Unit.piece, 8)},
        {"Egg": Quantity(Unit.piece, 4)},
        {"Bread Crumbs": Quantity(Unit.grams, 200)},
        {"Flour": Quantity(Unit.grams, 100)},
        {"Butter": Quantity(Unit.miliLitre, 300)},
        {"Vegetable Oil": Quantity(Unit.grams, 100)},
        {"Lemon slice": null},
        {"Salt": null},
      ],
      steps: [
        'Tenderize the veal to about 2–4mm, and salt on both sides.',
        'On a flat plate, stir the eggs briefly with a fork.',
        'Lightly coat the cutlets in flour then dip into the egg, and finally, coat in breadcrumbs.',
        'Heat the butter and oil in a large pan (allow the fat to get very hot) and fry the schnitzels until golden brown on both sides.',
        'Make sure to toss the pan regularly so that the schnitzels are surrounded by oil and the crumbing becomes ‘fluffy’.',
        'Remove, and drain on kitchen paper. Fry the parsley in the remaining oil and drain.',
        'Place the schnitzels on awarmed plate and serve garnishedwith parsley and slices of lemon.'
      ],
      isGlutenFree: false,
      isVegan: false,
      isLactoseFree: false,
      userId: "uid123"),
  Food(
    id: 'm5',
    categories: [
      'Quick'
          'Light',
      'Summer',
    ],
    title: 'salad with smoked salmon',
    affordability: Affordability.luxurious,
    complexity: Complexity.simple,
    imageUrl: 'assets/images/salmon.jpg',
    duration: 15,
    ingredients: [
      {"Arugula": null},
      {"Lamb's Lettuce": null},
      {"Parsley": null},
      {"Fennel": null},
      {"Smoked Salmon": Quantity(Unit.grams, 200)},
      {"Mustard": null},
      {"Balsamic Vinegar": null},
      {"Olive Oil": null},
      {"Salt": null},
      {"Pepper": null},
    ],
    steps: [
      'Wash and cut salad and herbs',
      'Dice the salmon',
      'Process mustard, vinegar and olive oil into a dessing',
      'Prepare the salad',
      'Add salmon cubes and dressing'
    ],
    isGlutenFree: true,
    isVegan: false,
    isLactoseFree: true,
    userId: "uid123",
  ),
  Food(
      id: 'm6',
      categories: [
        'Exotic',
        'Summer',
      ],
      title: 'delicious orange mousse',
      affordability: Affordability.affordable,
      complexity: Complexity.hard,
      imageUrl: 'assets/images/Delicious_Orange_Mousse.jpg',
      duration: 240,
      ingredients: [
        {"Gelatine": Quantity(Unit.sheets, 4)},
        {"Orange Juice": Quantity(Unit.miliLitre, 150)},
        {"Sugar": Quantity(Unit.grams, 80)},
        {"Yoghurt": Quantity(Unit.grams, 300)},
        {"Cream": Quantity(Unit.grams, 200)},
        {"Orange Peel": null},
      ],
      steps: [
        'Dissolve gelatine in pot',
        'Add orange juice and sugar',
        'Take pot off the stove',
        'Add 2 tablespoons of yoghurt',
        'Stir gelatin under remaining yoghurt',
        'Cool everything down in the refrigerator',
        'Whip the cream and lift it under die orange mass',
        'Cool down again for at least 4 hours',
        'Serve with orange peel',
      ],
      isGlutenFree: true,
      isVegan: false,
      isLactoseFree: false,
      userId: "uid123"),
  // Food(
  //   id: 'm7',
  //   categories: [
  //     'Breakfast',
  //   ],
  //   title: 'pancakes',
  //   affordability: Affordability.affordable,
  //   complexity: Complexity.simple,
  //   imageUrl: 'assets/images/Pancakes.jpg',
  //   duration: 20,
  //   ingredients: [
  //     '1 1/2 Cups all-purpose Flour',
  //     '3 1/2 Teaspoons Baking Powder',
  //     '1 Teaspoon Salt',
  //     '1 Tablespoon White Sugar',
  //     '1 1/4 cups Milk',
  //     '1 Egg',
  //     '3 Tablespoons Butter, melted',
  //   ],
  //   steps: [
  //     'In a large bowl, sift together the flour, baking powder, salt and sugar.',
  //     'Make a well in the center and pour in the milk, egg and melted butter; mix until smooth.',
  //     'Heat a lightly oiled griddle or frying pan over medium high heat.',
  //     'Pour or scoop the batter onto the griddle, using approximately 1/4 cup for each pancake. Brown on both sides and serve hot.'
  //   ],
  //   isGlutenFree: true,
  //   isVegan: false,
  //   isLactoseFree: false,
  //   userId: "uid123"
  // ),
  // Food(
  //   id: 'm8',
  //   categories: [
  //     'Asian',
  //   ],
  //   title: 'creamy indian chicken curry',
  //   affordability: Affordability.pricey,
  //   complexity: Complexity.challenging,
  //   imageUrl: 'assets/images/Creamy_Indian_Chicken_Curry.jpg',
  //   duration: 35,
  //   ingredients: [
  //     '4 Chicken Breasts',
  //     '1 Onion',
  //     '2 Cloves of Garlic',
  //     '1 Piece of Ginger',
  //     '4 Tablespoons Almonds',
  //     '1 Teaspoon Cayenne Pepper',
  //     '500ml Coconut Milk',
  //   ],
  //   steps: [
  //     'Slice and fry the chicken breast',
  //     'Process onion, garlic and ginger into paste and sauté everything',
  //     'Add spices and stir fry',
  //     'Add chicken breast + 250ml of water and cook everything for 10 minutes',
  //     'Add coconut milk',
  //     'Serve with rice'
  //   ],
  //   isGlutenFree: true,
  //   isVegan: false,
  //   isLactoseFree: true,
  //   userId: "uid123"
  // ),
  // Food(
  //   id: 'm9',
  //   categories: [
  //     'French',
  //   ],
  //   title: 'chocolate souffle',
  //   affordability: Affordability.affordable,
  //   complexity: Complexity.hard,
  //   imageUrl: 'assets/images/Chocolate_Souffle.jpg',
  //   duration: 45,
  //   ingredients: [
  //     '1 Teaspoon melted Butter',
  //     '2 Tablespoons white Sugar',
  //     '2 Ounces 70% dark Chocolate, broken into pieces',
  //     '1 Tablespoon Butter',
  //     '1 Tablespoon all-purpose Flour',
  //     '4 1/3 tablespoons cold Milk',
  //     '1 Pinch Salt',
  //     '1 Pinch Cayenne Pepper',
  //     '1 Large Egg Yolk',
  //     '2 Large Egg Whites',
  //     '1 Pinch Cream of Tartar',
  //     '1 Tablespoon white Sugar',
  //   ],
  //   steps: [
  //     'Preheat oven to 190°C. Line a rimmed baking sheet with parchment paper.',
  //     'Brush bottom and sides of 2 ramekins lightly with 1 teaspoon melted butter; cover bottom and sides right up to the rim.',
  //     'Add 1 tablespoon white sugar to ramekins. Rotate ramekins until sugar coats all surfaces.',
  //     'Place chocolate pieces in a metal mixing bowl.',
  //     'Place bowl over a pan of about 3 cups hot water over low heat.',
  //     'Melt 1 tablespoon butter in a skillet over medium heat. Sprinkle in flour. Whisk until flour is incorporated into butter and mixture thickens.',
  //     'Whisk in cold milk until mixture becomes smooth and thickens. Transfer mixture to bowl with melted chocolate.',
  //     'Add salt and cayenne pepper. Mix together thoroughly. Add egg yolk and mix to combine.',
  //     'Leave bowl above the hot (not simmering) water to keep chocolate warm while you whip the egg whites.',
  //     'Place 2 egg whites in a mixing bowl; add cream of tartar. Whisk until mixture begins to thicken and a drizzle from the whisk stays on the surface about 1 second before disappearing into the mix.',
  //     'Add 1/3 of sugar and whisk in. Whisk in a bit more sugar about 15 seconds.',
  //     'whisk in the rest of the sugar. Continue whisking until mixture is about as thick as shaving cream and holds soft peaks, 3 to 5 minutes.',
  //     'Transfer a little less than half of egg whites to chocolate.',
  //     'Mix until egg whites are thoroughly incorporated into the chocolate.',
  //     'Add the rest of the egg whites; gently fold into the chocolate with a spatula, lifting from the bottom and folding over.',
  //     'Stop mixing after the egg white disappears. Divide mixture between 2 prepared ramekins. Place ramekins on prepared baking sheet.',
  //     'Bake in preheated oven until scuffles are puffed and have risen above the top of the rims, 12 to 15 minutes.',
  //   ],
  //   isGlutenFree: true,
  //   isVegan: false,
  //   isLactoseFree: false,
  //   userId: "uid123"
  // ),
  // Food(
  //   id: 'm10',
  //   categories: [
  //     'Quick',
  //     'Light',
  //     'Summer',
  //   ],
  //   title: 'asparagus salad with cherry tomatoes',
  //   affordability: Affordability.luxurious,
  //   complexity: Complexity.simple,
  //   imageUrl: 'assets/images/Asparagus_Salad.jpg',
  //   duration: 30,
  //   ingredients: [
  //     'White and Green Asparagus',
  //     '30g Pine Nuts',
  //     '300g Cherry Tomatoes',
  //     'Salad',
  //     'Salt, Pepper and Olive Oil'
  //   ],
  //   steps: [
  //     'Wash, peel and cut the asparagus',
  //     'Cook in salted water',
  //     'Salt and pepper the asparagus',
  //     'Roast the pine nuts',
  //     'Halve the tomatoes',
  //     'Mix with asparagus, salad and dressing',
  //     'Serve with Baguette'
  //   ],
  //   isGlutenFree: true,
  //   isVegan: true,
  //   isLactoseFree: true,
  //   userId: "uid123"
  // ),
];
