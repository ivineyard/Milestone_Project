
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CookingModel extends ChangeNotifier {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  // --------------------------------------------------
  // RECIPES
  // --------------------------------------------------

  final List<Map<String, String>> _recipes = [
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

  List<Map<String, String>> get recipes => List.unmodifiable(
        _recipes.map((recipe) => Map<String, String>.unmodifiable(recipe)),
      );

  void addRecipe(Map<String, String> recipe) {
    _recipes.add(Map<String, String>.from(recipe));
    notifyListeners();
    _saveRecipes();
  }

  void editRecipe(int index, Map<String, String> updatedRecipe) {
    if (index < 0 || index >= _recipes.length) return;

    final oldName = _recipes[index]['name'];
    final newName = updatedRecipe['name'];

    _recipes[index] = Map<String, String>.from(updatedRecipe);

    if (oldName != null && oldName != newName) {
      if (_favorites.remove(oldName)) {
        _favorites.add(newName ?? oldName);
      }

      for (final day in _mealPlan.keys.toList()) {
        if (_mealPlan[day] == oldName) {
          _mealPlan[day] = newName ?? oldName;
        }
      }

      _saveFavorites();
      _saveMealPlan();
    }

    notifyListeners();
    _saveRecipes();
  }

  void deleteRecipe(int index) {
    if (index < 0 || index >= _recipes.length) return;

    final name = _recipes[index]['name'];

    _recipes.removeAt(index);

    if (name != null) {
      _favorites.remove(name);

      for (final day in _mealPlan.keys.toList()) {
        if (_mealPlan[day] == name) {
          _mealPlan.remove(day);
        }
      }

      _saveFavorites();
      _saveMealPlan();
    }

    notifyListeners();
    _saveRecipes();
  }

  // --------------------------------------------------
  // SEARCH AND FILTER
  // --------------------------------------------------

  String searchText = '';
  String selectedCategory = 'All';

  List<Map<String, String>> get filteredRecipes {
    return _recipes.where((recipe) {
      final name = recipe['name']!.toLowerCase();
      final matchesSearch = name.contains(searchText.toLowerCase());
      final matchesCategory = selectedCategory == 'All' ||
          recipe['category'] == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void setSearchText(String value) {
    searchText = value;
    notifyListeners();
  }

  void setCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  // --------------------------------------------------
  // FAVORITES
  // --------------------------------------------------

  final Set<String> _favorites = {};

  Set<String> get favorites => Set.unmodifiable(_favorites);

  int get favoriteCount => _favorites.length;

  List<Map<String, String>> get favoriteRecipes {
    return _recipes
        .where((recipe) => _favorites.contains(recipe['name']))
        .toList();
  }

  bool isFavorite(String recipeName) {
    return _favorites.contains(recipeName);
  }

  void toggleFavorite(String recipeName) {
    if (!_favorites.add(recipeName)) {
      _favorites.remove(recipeName);
    }

    notifyListeners();
    _saveFavorites();
  }

  // --------------------------------------------------
  // MEAL PLAN
  // --------------------------------------------------

  final Map<String, String> _mealPlan = {
    'Monday': 'Chicken Alfredo',
    'Tuesday': 'Homemade Pizza',
    'Wednesday': 'Pancakes',
  };

  Map<String, String> get mealPlan => Map.unmodifiable(_mealPlan);

  void setMeal(String day, String recipeName) {
    _mealPlan[day] = recipeName;
    notifyListeners();
    _saveMealPlan();
  }

  void removeMeal(String day) {
    _mealPlan.remove(day);
    notifyListeners();
    _saveMealPlan();
  }

  // --------------------------------------------------
  // GROCERY LIST
  // --------------------------------------------------

  final List<String> _groceries = [
    'Chicken',
    'Pasta',
    'Alfredo Sauce',
    'Cheese',
  ];

  final Set<String> _checkedGroceries = {};

  List<String> get groceries => List.unmodifiable(_groceries);

  Set<String> get checkedGroceries => Set.unmodifiable(_checkedGroceries);

  void addGrocery(String item) {
    final cleanedItem = item.trim();

    if (cleanedItem.isEmpty ||
        _groceries.any((grocery) =>
            grocery.toLowerCase() == cleanedItem.toLowerCase())) {
      return;
    }

    _groceries.add(cleanedItem);
    notifyListeners();
    _saveGroceries();
  }

  void removeGrocery(String item) {
    _groceries.remove(item);
    _checkedGroceries.remove(item);
    notifyListeners();
    _saveGroceries();
  }

  void toggleGroceryChecked(String item) {
    if (!_checkedGroceries.add(item)) {
      _checkedGroceries.remove(item);
    }

    notifyListeners();
    _saveGroceries();
  }

  // --------------------------------------------------
  // LOCAL PERSISTENCE
  // --------------------------------------------------

  Future<void> loadSavedData() async {
    try {
      final savedRecipes = await _prefs.getString('saved_recipes');
      final savedFavorites =
          await _prefs.getStringList('favorite_recipes');
      final savedMealPlan = await _prefs.getString('saved_meal_plan');
      final savedGroceries = await _prefs.getString('saved_groceries');

      if (savedRecipes != null) {
        final decoded = jsonDecode(savedRecipes) as List;
        _recipes
          ..clear()
          ..addAll(decoded.map(
            (item) => Map<String, String>.from(item as Map),
          ));
      }

      if (savedFavorites != null) {
        _favorites
          ..clear()
          ..addAll(savedFavorites);
      }

      if (savedMealPlan != null) {
        _mealPlan
          ..clear()
          ..addAll(Map<String, String>.from(jsonDecode(savedMealPlan)));
      }

      if (savedGroceries != null) {
        final decoded = jsonDecode(savedGroceries) as Map;
        _groceries
          ..clear()
          ..addAll(List<String>.from(decoded['items'] as List));
        _checkedGroceries
          ..clear()
          ..addAll(List<String>.from(decoded['checked'] as List));
      }

      notifyListeners();
    } catch (_) {
      // If saved data cannot be read, keep the starter data.
    }
  }

  Future<void> _saveRecipes() async {
    await _prefs.setString('saved_recipes', jsonEncode(_recipes));
  }

  Future<void> _saveFavorites() async {
    await _prefs.setStringList('favorite_recipes', _favorites.toList());
  }

  Future<void> _saveMealPlan() async {
    await _prefs.setString('saved_meal_plan', jsonEncode(_mealPlan));
  }

  Future<void> _saveGroceries() async {
    await _prefs.setString(
      'saved_groceries',
      jsonEncode({
        'items': _groceries,
        'checked': _checkedGroceries.toList(),
      }),
    );
  }

  // --------------------------------------------------
  // API RECIPES AND API SCREEN STATES
  // --------------------------------------------------

  bool isLoadingApiRecipes = false;
  String? apiError;
  List<Map<String, dynamic>> apiRecipes = [];

  Future<void> fetchApiRecipes() async {
    isLoadingApiRecipes = true;
    apiError = null;
    notifyListeners();

    try {
      final url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=chicken',
        //https://this-address-does-not-exist-12345.com to force a no wifi screen
      );

      final response = await http.get(url).timeout(
            const Duration(seconds: 15),
          );

      if (response.statusCode != 200) {
        throw Exception('The server returned an error. Try again.');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = data['meals'];

      apiRecipes = meals == null
          ? []
          : List<Map<String, dynamic>>.from(meals as List);

      apiError = null;
    } catch (_) {
      apiError = 'Could not load recipes. Check your connection and try again.';
    } finally {
      isLoadingApiRecipes = false;
      notifyListeners();
    }
  }
}
