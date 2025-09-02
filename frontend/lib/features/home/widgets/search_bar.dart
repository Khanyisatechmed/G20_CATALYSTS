// features/home/widgets/search_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool isEnabled;
  final bool showFilters;
  final List<String>? suggestions;
  final VoidCallback? onFilterTap;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.isEnabled = true,
    this.showFilters = true,
    this.suggestions,
    this.onFilterTap,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showSuggestions = false;
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.suggestions != null && _controller.text.isNotEmpty) {
      setState(() {
        _filteredSuggestions = widget.suggestions!
            .where((suggestion) => suggestion
                .toLowerCase()
                .contains(_controller.text.toLowerCase()))
            .take(5)
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _showSuggestions = false;
        _filteredSuggestions.clear();
      });
    }

    widget.onChanged?.call(_controller.text);
  }

  void _onSubmitted(String value) {
    setState(() {
      _showSuggestions = false;
    });
    widget.onSubmitted?.call(value);
    FocusScope.of(context).unfocus();
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    setState(() {
      _showSuggestions = false;
    });
    widget.onSubmitted?.call(suggestion);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: widget.isEnabled,
                    onTap: () {
                      widget.onTap?.call();
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                      });
                    },
                    onSubmitted: _onSubmitted,
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? 'Search experiences, places, culture...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_controller.text.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                _controller.clear();
                                widget.onChanged?.call('');
                                setState(() {
                                  _showSuggestions = false;
                                });
                              },
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                            ),
                          if (widget.showFilters) ...[
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: widget.onFilterTap ?? _showFilterBottomSheet,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.tune,
                                        color: Colors.grey[700],
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Filter',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 16,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Suggestions dropdown
        if (_showSuggestions) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _filteredSuggestions.map((suggestion) =>
                InkWell(
                  onTap: () => _selectSuggestion(suggestion),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200]!,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            suggestion,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.north_west,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ],
      ],
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),

          const Divider(),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    'Category',
                    ['Cultural', 'Art & Craft', 'Philosophy', 'Nature', 'History'],
                    Icons.category,
                  ),
                  const SizedBox(height: 24),
                  _buildFilterSection(
                    'Location',
                    ['Eastern Cape', 'KwaZulu-Natal', 'Mpumalanga', 'Johannesburg', 'Cape Town'],
                    Icons.location_on,
                  ),
                  const SizedBox(height: 24),
                  _buildFilterSection(
                    'Price Range',
                    ['Free', 'Under R200', 'R200 - R500', 'R500+'],
                    Icons.attach_money,
                  ),
                  const SizedBox(height: 24),
                  _buildFilterSection(
                    'Duration',
                    ['Under 1 hour', '1-3 hours', '3+ hours', 'Full day'],
                    Icons.access_time,
                  ),
                  const SizedBox(height: 24),
                  _buildFilterSection(
                    'Difficulty',
                    ['Easy', 'Moderate', 'Challenging'],
                    Icons.trending_up,
                  ),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Apply filters logic here
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) =>
            FilterChip(
              label: Text(option),
              selected: false, // You can manage selection state here
              onSelected: (selected) {
                // Handle filter selection
              },
              selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            ),
          ).toList(),
        ),
      ],
    );
  }
}

// Quick search suggestions widget
class QuickSearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;

  const QuickSearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: ActionChip(
              label: Text(suggestion),
              onPressed: () => onSuggestionTap(suggestion),
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Search results count widget
class SearchResultsHeader extends StatelessWidget {
  final int count;
  final String query;
  final VoidCallback? onSortTap;

  const SearchResultsHeader({
    super.key,
    required this.count,
    required this.query,
    this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count results found',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (query.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'for "$query"',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onSortTap != null)
            TextButton.icon(
              onPressed: onSortTap,
              icon: const Icon(Icons.sort, size: 18),
              label: const Text('Sort'),
            ),
        ],
      ),
    );
  }
}
