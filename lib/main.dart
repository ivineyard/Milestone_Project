import 'package:flutter/material.dart';

void main() {
  runApp(const CookingCompanion());
}

// Main application
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

        // Theme for cards
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 3,
        ),
      ),

      home: const HomePage(),
    );
  }
}

// Home page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar at the top
      appBar: AppBar(
        title: const Text(
          'My Kitchen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,

        // Profile icon
        actions: [
          IconButton(
            onPressed: () {
              // Profile feature will be added later
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),

      // Main page content
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

              // Featured recipe heading
              const Text(
                'Featured Recipe',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Featured recipe card
              buildFeaturedRecipe(),

              const SizedBox(height: 24),

              // Kitchen section heading
              const Text(
                'My Kitchen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Row containing the first two sections
              Row(
                children: [

                  // Recipes
                  Expanded(
                    child: buildMenuCard(
                      icon: Icons.restaurant_menu,
                      title: 'Recipes',
                      subtitle: 'View your recipes',
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Meal Planner
                  Expanded(
                    child: buildMenuCard(
                      icon: Icons.calendar_month,
                      title: 'Meal Plan',
                      subtitle: 'Plan your meals',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Grocery List
              buildMenuCard(
                icon: Icons.shopping_cart,
                title: 'Grocery List',
                subtitle: 'Keep track of what you need',
              ),

              const SizedBox(height: 24),

              // Recently added section
              const Text(
                'Recently Added',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Recipe examples
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

  // Creates the featured recipe card
  Widget buildFeaturedRecipe() {
    return SizedBox(
      height: 180,

      // Stack allows us to place information on top of another widget
      child: Stack(
        children: [

          // Background of the recipe card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // Recipe information
          Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

  // Creates a menu card
  Widget buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        // Column places the icon and text vertically
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }

  // Creates an individual recipe item
  Widget buildRecipeItem({
    required IconData icon,
    required String title,
    required String details,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),

        // Row places the icon and information side-by-side
        child: Row(
          children: [

            Icon(
              icon,
              size: 35,
              color: Colors.blue,
            ),

            const SizedBox(width: 12),

            // Expanded allows the text to use the available space
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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