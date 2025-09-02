// widgets/booking_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/date_formatter.dart';
import 'status_badge.dart';

class BookingCard extends StatelessWidget {
  final String title;
  final String location;
  final DateTime date;
  final String time;
  final int participants;
  final double price;
  final String currency;
  final String status;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onModify;

  const BookingCard({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.participants,
    required this.price,
    required this.currency,
    required this.status,
    required this.imageUrl,
    required this.onTap,
    this.onCancel,
    this.onModify, required bool isPast,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: status),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'Date',
                      DateFormatter.dayMonth(date),
                      Icons.calendar_today,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'Time',
                      time,
                      Icons.schedule,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'Participants',
                      participants.toString(),
                      Icons.group,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'Price',
                      '$currency${price.toInt()}',
                      Icons.monetization_on,
                    ),
                  ),
                ],
              ),

              if (onCancel != null || onModify != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (onModify != null) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onModify,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text('Modify'),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (onCancel != null)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
