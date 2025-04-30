import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            // "All" chip
            _buildCategoryChip(
              context,
              'All',
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
            ),
            
            // Category chips
            ...categories.map((category) => _buildCategoryChip(
              context,
              _formatCategoryName(category),
              isSelected: selectedCategory == category,
              onTap: () => onCategorySelected(category),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor: isSelected ? Colors.deepPurple : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  String _formatCategoryName(String category) {
    // Capitalize first letter of each word
    return category.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
