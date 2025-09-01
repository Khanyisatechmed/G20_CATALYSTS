
import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int experiences;
  final int reviews;
  final int points;

  const ProfileStats({
    super.key,
    required this.experiences,
    required this.reviews,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          'Experiences',
          experiences.toString(),
        ),
        _buildStatItem(
          'Reviews',
          reviews.toString(),
        ),
        _buildStatItem(
          'Points',
          points.toString(),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
