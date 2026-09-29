import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const CookingCompanion());
}

// ------------------------------------------------------
// MAIN APP
// ------------------------------------------------------

class CookingCompanion extends StatelessWidget {
  const CookingCompanion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cooking Companion',

      // App theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),

        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 3,
        ),
      ),

      home: const HomePage(),
    );
  }
}

// ------------------------------------------------------
// HOME PAGE
// ------------------------------------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Stores the number of saved favorite recipes.
  int favoriteCount = 0;

  @override
  void initState() {
    super.initState();

    // Load saved favorites when the Home page starts.
    loadFavorites();
  }

  // Load favorites from the device.
  Future<void> loadFavorites() async {
    final prefs = SharedPreferencesAsync();

    final savedFavorites =
        await prefs.getStringList('favorite_recipes') ?? [];

    setState(() {
      favoriteCount = savedFavorites.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Kitchen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor:
            Theme.of(context).colorScheme.primary,

        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Welcome section
              const Text(
                'Welcome to your Cooking Companion!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Keep your recipes, meals, and grocery list organized.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              // Featured recipe
              const Text(
                'Featured Recipe',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              buildFeaturedRecipe(),

              const SizedBox(height: 24),

              // Favorite count
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),

                  title: const Text(
                    'Favorite Recipes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    '$favoriteCount recipe(s) saved as favorites',
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Kitchen section
              const Text(
                'My Kitchen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Recipes and Meal Plan
              Row(
                children: [

                  Expanded(
                    child: buildMenuCard(
                      context,
                      icon: Icons.restaurant_menu,
                      title: 'Recipes',
                      subtitle: 'View your recipes',

                      onPressed: () async {

                        // Open Recipe List.
                        // Wait for the page to close.
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const RecipeListPage(),
                          ),
                        );

                        // Reload favorites when returning.
                        loadFavorites();
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: buildMenuCard(
                      context,
                      icon: Icons.calendar_month,
                      title: 'Meal Plan',
                      subtitle: 'Plan your meals',

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const MealPlanPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Grocery List
              buildMenuCard(
                context,
                icon: Icons.shopping_cart,
                title: 'Grocery List',
                subtitle: 'Keep track of what you need',

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const GroceryListPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Recently Added
              const Text(
                'Recently Added',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              buildRecipeItem(
                icon: Icons.local_pizza,
                title: 'Homemade Pizza',
                details: 'Dinner • Easy',
              ),

              buildRecipeItem(
                icon: Icons.breakfast_dining,
                title: 'Pancakes',
                details: 'Breakfast • Easy',
              ),

              buildRecipeItem(
                icon: Icons.cookie,
                title: 'Chocolate Chip Cookies',
                details: 'Dessert • Medium',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // FEATURED RECIPE
  // ----------------------------------------------------

  Widget buildFeaturedRecipe() {
    return SizedBox(
      height: 180,

      child: Stack(
        children: [

          Container(
            width: double.infinity,

            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          Positioned(
            left: 20,
            bottom: 20,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: const [

                Text(
                  'Chicken Alfredo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  '⭐ Easy    ⏱ 30 minutes',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // MENU CARD
  // ----------------------------------------------------

  Widget buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: InkWell(
        onTap: onPressed,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Icon(
                icon,
                size: 35,
                color: Colors.blue,
              ),

              const SizedBox(height: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // RECIPE ITEM
  // ----------------------------------------------------

  Widget buildRecipeItem({
    required IconData icon,
    required String title,
    required String details,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          children: [

            Icon(
              icon,
              size: 35,
              color: Colors.blue,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(details),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------
// RECIPE LIST PAGE
// ------------------------------------------------------

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() =>
      _RecipeListPageState();
}

class _RecipeListPageState
    extends State<RecipeListPage> {

  // Recipe information.
  final List<Map<String, String>> recipes = [
    {
      'name': 'Chicken Alfredo',
      'category': 'Dinner',
      'difficulty': 'Easy',
      'time': '30 minutes',
      'description':
          'A creamy pasta dish made with chicken, pasta, and Alfredo sauce.',
    },

    {
      'name': 'Homemade Pizza',
      'category': 'Dinner',
      'difficulty': 'Easy',
      'time': '45 minutes',
      'description':
          'A homemade pizza with your favorite toppings and cheese.',
    },

    {
      'name': 'Pancakes',
      'category': 'Breakfast',
      'difficulty': 'Easy',
      'time': '20 minutes',
      'description':
          'Fluffy pancakes that are perfect for a weekend breakfast.',
    },

    {
      'name': 'Chocolate Chip Cookies',
      'category': 'Dessert',
      'difficulty': 'Medium',
      'time': '35 minutes',
      'description':
          'Classic chocolate chip cookies with a soft center.',
    },
  ];

  // Stores the favorite recipes.
  Set<String> favoriteRecipes = {};

  @override
  void initState() {
    super.initState();

    // Load saved favorites when this screen opens.
    loadFavorites();
  }

  // ----------------------------------------------------
  // LOAD FAVORITES
  // ----------------------------------------------------

  Future<void> loadFavorites() async {
    final prefs = SharedPreferencesAsync();

    final savedFavorites =
        await prefs.getStringList('favorite_recipes') ?? [];

    setState(() {
      favoriteRecipes = savedFavorites.toSet();
    });
  }

  // ----------------------------------------------------
  // SAVE FAVORITES
  // ----------------------------------------------------

  Future<void> saveFavorites() async {
    final prefs = SharedPreferencesAsync();

    await prefs.setStringList(
      'favorite_recipes',
      favoriteRecipes.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),

        backgroundColor:
            Theme.of(context).colorScheme.primary,

        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: recipes.length,

        itemBuilder: (context, index) {

          final recipe = recipes[index];

          final recipeName = recipe['name']!;

          final isFavorite =
              favoriteRecipes.contains(recipeName);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              leading: const Icon(
                Icons.restaurant,
                color: Colors.blue,
                size: 35,
              ),

              title: Text(
                recipeName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                '${recipe['category']} • ${recipe['time']}',
              ),

              trailing: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,

                color: isFavorite
                    ? Colors.red
                    : Colors.grey,
              ),

              // Open recipe details.
              onTap: () async {

                // Send recipe data FORWARD.
                final result =
                    await Navigator.push<bool>(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                        RecipeDetailsPage(
                      recipe: recipe,
                      isFavorite: isFavorite,
                    ),
                  ),
                );

                // Data comes BACK from Recipe Details.
                if (result == true) {

                  setState(() {

                    if (favoriteRecipes
                        .contains(recipeName)) {

                      // Remove favorite.
                      favoriteRecipes
                          .remove(recipeName);

                    } else {

                      // Add favorite.
                      favoriteRecipes
                          .add(recipeName);
                    }
                  });

                  // Save the updated favorites
                  // to the device.
                  await saveFavorites();
                }
              },
            ),
          );
        },
      ),
    );
  }
}

// ------------------------------------------------------
// RECIPE DETAILS PAGE
// ------------------------------------------------------

class RecipeDetailsPage extends StatelessWidget {

  // Recipe information passed from
  // the Recipe List page.
  final Map<String, String> recipe;

  // Whether the recipe is already a favorite.
  final bool isFavorite;

  const RecipeDetailsPage({
    super.key,
    required this.recipe,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name']!),

        backgroundColor:
            Theme.of(context).colorScheme.primary,

        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // Recipe title
            Text(
              recipe['name']!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Recipe information
            Row(
              children: [

                const Icon(Icons.category),

                const SizedBox(width: 6),

                Text(recipe['category']!),

                const SizedBox(width: 20),

                const Icon(Icons.timer),

                const SizedBox(width: 6),

                Text(recipe['time']!),
              ],
            ),

            const SizedBox(height: 24),

            // Description
            const Text(
              'About This Recipe',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              recipe['description']!,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 24),

            // Ingredients
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '• Ingredients will be added in a future milestone.\n'
              '• More recipe information will be added later.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            // Favorite button
            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {

                  // Send TRUE back to the Recipe List.
                  Navigator.pop(context, true);
                },

                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),

                label: Text(
                  isFavorite
                      ? 'Remove from Favorites'
                      : 'Add to Favorites',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------
// MEAL PLAN PAGE
// ------------------------------------------------------

class MealPlanPage extends StatelessWidget {
  const MealPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),

        backgroundColor:
            Theme.of(context).colorScheme.primary,

        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Weekly Meal Plan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            buildDay('Monday', 'Chicken Alfredo'),

            buildDay('Tuesday', 'Homemade Pizza'),

            buildDay('Wednesday', 'Pancakes'),

            buildDay(
              'Thursday',
              'No meal planned',
            ),

            buildDay(
              'Friday',
              'No meal planned',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDay(String day, String meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        leading: const Icon(
          Icons.calendar_today,
          color: Colors.blue,
        ),

        title: Text(
          day,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(meal),
      ),
    );
  }
}

// ------------------------------------------------------
// GROCERY LIST PAGE
// ------------------------------------------------------

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({super.key});

  @override
  State<GroceryListPage> createState() =>
      _GroceryListPageState();
}

class _GroceryListPageState
    extends State<GroceryListPage> {

  final List<String> groceries = [
    'Chicken',
    'Pasta',
    'Alfredo Sauce',
    'Cheese',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),

        backgroundColor:
            Theme.of(context).colorScheme.primary,

        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: groceries.length,

        itemBuilder: (context, index) {

          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.shopping_cart,
                color: Colors.blue,
              ),

              title: Text(groceries[index]),

              trailing: const Icon(
                Icons.check_box_outline_blank,
              ),
            ),
          );
        },
      ),
    );
  }
}

