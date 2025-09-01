// widgets/accommodation_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccommodationCard extends StatelessWidget {
  final String name;
  final String description;
  final String location;
  final double pricePerNight;
  final String currency;
  final int maxGuests;
  final int bedrooms;
  final double rating;
  final int reviewCount;
  final List<String> amenities;
  final List<String> imageUrls;
  final bool hasARTour;
  final VoidCallback onTap;
  final VoidCallback? onViewAR;
  final VoidCallback onBook;

  const AccommodationCard({
    super.key,
    required this.name,
    required this.description,
    required this.location,
    required this.pricePerNight,
    required this.currency,
    required this.maxGuests,
    required this.bedrooms,
    required this.rating,
    required this.reviewCount,
    required this.amenities,
    required this.imageUrls,
    this.hasARTour = false,
    required this.onTap,
    this.onViewAR,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                color: Colors.grey[200],
              ),
              child: imageUrls.isNotEmpty && imageUrls.first.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrls.first,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.home, size: 40, color: Colors.grey),
                    ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16),

                  // Property details
                  Row(
                    children: [
                      _buildDetailChip(
                        Icons.people,
                        '$maxGuests guests',
                      ),
                      const SizedBox(width: 8),
                      _buildDetailChip(
                        Icons.bed,
                        '$bedrooms bedroom${bedrooms > 1 ? 's' : ''}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Price and actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From $currency ${pricePerNight.toInt()}/night',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            '($reviewCount reviews)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (hasARTour && onViewAR != null)
                            OutlinedButton(
                              onPressed: onViewAR,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                minimumSize: const Size(0, 0),
                              ),
                              child: const Text('View in AR'),
                            ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: onBook,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: const Size(0, 0),
                            ),
                            child: const Text('Book'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
   Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
