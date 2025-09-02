// features/home/widgets/experience_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExperienceCard extends StatelessWidget {
  final Map<String, dynamic> experience;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final bool showDetails;

  const ExperienceCard({
    super.key,
    required this.experience,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: showDetails ? 280 : 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              _buildImageSection(context),

              if (showDetails) ...[
                // Content section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleSection(),
                        const SizedBox(height: 8),
                        _buildLocationRow(),
                        const SizedBox(height: 8),
                        _buildDetailsRow(),
                        const Spacer(),
                        _buildPriceSection(context),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      height: showDetails ? 140 : 160,
      width: double.infinity,
      child: Stack(
        children: [
          // Background image or placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: _getCategoryGradient(),
            ),
            child: experience['image'] != null
                ? CachedNetworkImage(
                    imageUrl: experience['image'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildImagePlaceholder(),
                    errorWidget: (context, url, error) => _buildImagePlaceholder(),
                  )
                : _buildImagePlaceholder(),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),

          // Category badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _getCategoryColor(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                experience['category'] ?? 'Cultural',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Favorite button
          if (onFavorite != null)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey[600],
                    size: 20,
                  ),
                  onPressed: onFavorite,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
            ),

          // Duration badge
          if (experience['duration'] != null)
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${experience['duration']}min',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: _getCategoryColor().withValues(alpha: 0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(),
              size: 40,
              color: _getCategoryColor(),
            ),
            const SizedBox(height: 8),
            Text(
              experience['category'] ?? 'Experience',
              style: TextStyle(
                color: _getCategoryColor(),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Text(
      experience['title'] ?? 'Ubuntu Experience',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            experience['location'] ?? 'South Africa',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsRow() {
    return Row(
      children: [
        // Rating
        if (experience['rating'] != null) ...[
          Icon(
            Icons.star,
            size: 16,
            color: Colors.orange[600],
          ),
          const SizedBox(width: 4),
          Text(
            '${experience['rating']}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '(${experience['reviewCount'] ?? 0})',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],

        const SizedBox(width: 16),

        // Group size
        if (experience['groupSize'] != null) ...[
          Icon(
            Icons.people,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              experience['groupSize'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    final price = experience['price'] as int? ?? 0;
    final currency = experience['currency'] as String? ?? 'ZAR';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (price == 0) ...[
              Text(
                'FREE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$currency $price',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'per person',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
            if (experience['difficulty'] != null) ...[
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getDifficultyColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  experience['difficulty'],
                  style: TextStyle(
                    fontSize: 10,
                    color: _getDifficultyColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColor,
              size: 16,
            ),
            onPressed: onTap,
            padding: const EdgeInsets.all(8),
          ),
        ),
      ],
    );
  }

  // Helper methods for styling
  LinearGradient _getCategoryGradient() {
    switch (experience['category']?.toString().toLowerCase()) {
      case 'cultural':
        return LinearGradient(colors: [Colors.orange[400]!, Colors.orange[600]!]);
      case 'art & craft':
        return LinearGradient(colors: [Colors.purple[400]!, Colors.purple[600]!]);
      case 'philosophy':
        return LinearGradient(colors: [Colors.blue[400]!, Colors.blue[600]!]);
      case 'nature':
        return LinearGradient(colors: [Colors.green[400]!, Colors.green[600]!]);
      default:
        return LinearGradient(colors: [Colors.grey[400]!, Colors.grey[600]!]);
    }
  }

  Color _getCategoryColor() {
    switch (experience['category']?.toString().toLowerCase()) {
      case 'cultural':
        return Colors.orange[600]!;
      case 'art & craft':
        return Colors.purple[600]!;
      case 'philosophy':
        return Colors.blue[600]!;
      case 'nature':
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getCategoryIcon() {
    switch (experience['category']?.toString().toLowerCase()) {
      case 'cultural':
        return Icons.groups;
      case 'art & craft':
        return Icons.palette;
      case 'philosophy':
        return Icons.psychology;
      case 'nature':
        return Icons.nature;
      default:
        return Icons.local_activity;
    }
  }

  Color _getDifficultyColor() {
    switch (experience['difficulty']?.toString().toLowerCase()) {
      case 'easy':
        return Colors.green[600]!;
      case 'moderate':
        return Colors.orange[600]!;
      case 'hard':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}
