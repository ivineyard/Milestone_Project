import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cooking_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CookingModel()..loadSavedData(),
      child: const CookingCompanion(),
    ),
  );
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider keeps the favorite count updated across screens.
    final favoriteCount = context.watch<CookingModel>().favoriteCount;
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

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecipeListPage(),
                          ),
                        );
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

              const SizedBox(height: 12),

              // API recipes from the internet
              buildMenuCard(
                context,
                icon: Icons.cloud_download,
                title: 'Discover Recipes',
                subtitle: 'Load recipes from an online API',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ApiRecipesPage(),
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

 // ------------------------------------------------------
// RECIPE LIST PAGE
// ------------------------------------------------------

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Read shared recipes and favorites from Provider.
    final cooking = context.watch<CookingModel>();
    final recipes = cooking.filteredRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Favorite Recipes',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search recipes',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<CookingModel>().setSearchText(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              initialValue: cooking.selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Filter by category',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All')),
                DropdownMenuItem(value: 'Breakfast', child: Text('Breakfast')),
                DropdownMenuItem(value: 'Dinner', child: Text('Dinner')),
                DropdownMenuItem(value: 'Dessert', child: Text('Dessert')),
              ],
              onChanged: (value) {
                if (value != null) {
                  context.read<CookingModel>().setCategory(value);
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                final name = recipe['name']!;
                final isFavorite = cooking.isFavorite(name);

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.restaurant,
                      color: Colors.blue,
                    ),
                    title: Text(name),
                    subtitle: Text(
                      '${recipe['category']} • ${recipe['time']}',
                    ),
                    trailing: IconButton(
                      tooltip: isFavorite
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        context.read<CookingModel>().toggleFavorite(name);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailsPage(
                            recipeName: name,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEditRecipePage(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Recipe'),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------
// RECIPE DETAILS PAGE
// ------------------------------------------------------

class RecipeDetailsPage extends StatelessWidget {
  final String recipeName;

  const RecipeDetailsPage({
    super.key,
    required this.recipeName,
  });

  @override
  Widget build(BuildContext context) {
    final cooking = context.watch<CookingModel>();

    final recipe = cooking.recipes.firstWhere(
      (item) => item['name'] == recipeName,
      orElse: () => <String, String>{},
    );

    if (recipe.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recipe Details')),
        body: const Center(child: Text('Recipe not found.')),
      );
    }

    final isFavorite = cooking.isFavorite(recipeName);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipeName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text('${recipe['category']} • ${recipe['time']}'),
            const SizedBox(height: 24),
            const Text(
              'About This Recipe',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(recipe['description'] ?? ''),
            const SizedBox(height: 24),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingredients can be added to each recipe as the app develops.',
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<CookingModel>().toggleFavorite(recipeName);
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                label: Text(
                  isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditRecipePage(
                            recipeName: recipeName,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<CookingModel>().deleteRecipe(
                        cooking.recipes.indexWhere(
                          (item) => item['name'] == recipeName,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------
// FAVORITES PAGE
// ------------------------------------------------------

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cooking = context.watch<CookingModel>();
    final favorites = cooking.favoriteRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('You have no favorite recipes yet.'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final recipe = favorites[index];
                final name = recipe['name']!;

                return ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: Text(name),
                  subtitle: Text(recipe['category'] ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailsPage(
                          recipeName: name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

// ------------------------------------------------------
// ADD OR EDIT RECIPE PAGE
// ------------------------------------------------------

class AddEditRecipePage extends StatefulWidget {
  final String? recipeName;

  const AddEditRecipePage({super.key, this.recipeName});

  @override
  State<AddEditRecipePage> createState() => _AddEditRecipePageState();
}

class _AddEditRecipePageState extends State<AddEditRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();

  String _category = 'Dinner';
  String _difficulty = 'Easy';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.recipeName != null && _nameController.text.isEmpty) {
      final cooking = context.read<CookingModel>();
      final recipe = cooking.recipes.firstWhere(
        (item) => item['name'] == widget.recipeName,
      );

      _nameController.text = recipe['name'] ?? '';
      _descriptionController.text = recipe['description'] ?? '';
      _timeController.text = recipe['time'] ?? '';
      _category = recipe['category'] ?? 'Dinner';
      _difficulty = recipe['difficulty'] ?? 'Easy';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.recipeName != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Recipe' : 'Add Recipe'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Recipe name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter a recipe name'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Cooking time'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter the cooking time'
                        : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(value: 'Breakfast', child: Text('Breakfast')),
                  DropdownMenuItem(value: 'Dinner', child: Text('Dinner')),
                  DropdownMenuItem(value: 'Dessert', child: Text('Dessert')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _difficulty,
                decoration: const InputDecoration(labelText: 'Difficulty'),
                items: const [
                  DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _difficulty = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    final recipe = <String, String>{
                      'name': _nameController.text.trim(),
                      'category': _category,
                      'difficulty': _difficulty,
                      'time': _timeController.text.trim(),
                      'description': _descriptionController.text.trim(),
                    };

                    final cooking = context.read<CookingModel>();

                    if (isEditing) {
                      final index = cooking.recipes.indexWhere(
                        (item) => item['name'] == widget.recipeName,
                      );
                      cooking.editRecipe(index, recipe);
                    } else {
                      cooking.addRecipe(recipe);
                    }

                    Navigator.pop(context);
                  },
                  child: Text(isEditing ? 'Save Changes' : 'Add Recipe'),
                ),
              ),
            ],
          ),
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
    final cooking = context.watch<CookingModel>();
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Weekly Meal Plan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...days.map((day) {
            final plannedMeal = cooking.mealPlan[day] ?? '';
            return Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.blue),
                title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: DropdownButton<String>(
                  isExpanded: true,
                  value: plannedMeal.isNotEmpty && cooking.recipes.any((r) => r['name'] == plannedMeal)
                      ? plannedMeal
                      : null,
                  hint: const Text('Choose a meal'),
                  items: cooking.recipes.map((recipe) {
                    final name = recipe['name'] ?? '';
                    return DropdownMenuItem<String>(value: name, child: Text(name));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<CookingModel>().setMeal(day, value);
                    }
                  },
                ),
                trailing: IconButton(
                  tooltip: 'Clear meal',
                  icon: const Icon(Icons.clear),
                  onPressed: plannedMeal.isEmpty
                      ? null
                      : () => context.read<CookingModel>().removeMeal(day),
                ),
              ),
            );
          }),
        ],
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
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  final TextEditingController _groceryController = TextEditingController();

  @override
  void dispose() {
    _groceryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cooking = context.watch<CookingModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _groceryController,
                    decoration: const InputDecoration(
                      labelText: 'Add grocery item',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addGrocery(context),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Add item',
                  icon: const Icon(Icons.add),
                  onPressed: () => _addGrocery(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: cooking.groceries.isEmpty
                ? const Center(child: Text('Your grocery list is empty.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cooking.groceries.length,
                    itemBuilder: (context, index) {
                      final item = cooking.groceries[index];
                      final isChecked = cooking.checkedGroceries.contains(item);
                      return Card(
                        child: CheckboxListTile(
                          value: isChecked,
                          onChanged: (_) => context.read<CookingModel>().toggleGroceryChecked(item),
                          title: Text(item),
                          secondary: IconButton(
                            tooltip: 'Remove item',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context.read<CookingModel>().removeGrocery(item),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _addGrocery(BuildContext context) {
    final item = _groceryController.text.trim();
    if (item.isEmpty) return;
    context.read<CookingModel>().addGrocery(item);
    _groceryController.clear();
  }
}

// ------------------------------------------------------
// API RECIPES PAGE
// ------------------------------------------------------

class ApiRecipesPage extends StatefulWidget {
  const ApiRecipesPage({super.key});

  @override
  State<ApiRecipesPage> createState() => _ApiRecipesPageState();
}

class _ApiRecipesPageState extends State<ApiRecipesPage> {
  @override
  void initState() {
    super.initState();
    // Start loading API recipes when this screen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CookingModel>().fetchApiRecipes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cooking = context.watch<CookingModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Recipes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<CookingModel>().fetchApiRecipes(),
        child: Builder(
          builder: (context) {
            if (cooking.isLoadingApiRecipes && cooking.apiRecipes.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 220),
                  Center(child: CircularProgressIndicator()),
                  SizedBox(height: 16),
                  Center(child: Text('Loading recipes...')),
                ],
              );
            }

            if (cooking.apiError != null && cooking.apiRecipes.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 100),
                  const Icon(Icons.wifi_off, size: 56),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Could not load recipes.',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(child: Text(cooking.apiError!, textAlign: TextAlign.center)),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => context.read<CookingModel>().fetchApiRecipes(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              );
            }

            if (cooking.apiRecipes.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('No recipes were found. Pull down to refresh.')),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: cooking.apiRecipes.length,
              itemBuilder: (context, index) {
                final recipe = cooking.apiRecipes[index];
                final name = recipe['strMeal']?.toString() ?? 'Untitled recipe';
                final category = recipe['strCategory']?.toString() ?? 'Recipe';
                final area = recipe['strArea']?.toString() ?? 'International';

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.restaurant, color: Colors.blue, size: 32),
                    title: Text(name),
                    subtitle: Text('$category • $area'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

