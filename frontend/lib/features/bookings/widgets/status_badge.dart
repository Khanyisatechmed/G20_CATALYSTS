// features/bookings/widgets/status_badge.dart
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusData.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusData.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  StatusData _getStatusData(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return StatusData(
          text: 'Confirmed',
          color: Colors.green,
        );
      case 'pending':
        return StatusData(
          text: 'Pending',
          color: Colors.orange,
        );
      case 'cancelled':
        return StatusData(
          text: 'Cancelled',
          color: Colors.red,
        );
      case 'completed':
        return StatusData(
          text: 'Completed',
          color: Colors.blue,
        );
      case 'in-progress':
        return StatusData(
          text: 'In Progress',
          color: Colors.purple,
        );
      case 'refunded':
        return StatusData(
          text: 'Refunded',
          color: Colors.grey,
        );
      default:
        return StatusData(
          text: status.isNotEmpty
              ? status[0].toUpperCase() + status.substring(1).toLowerCase()
              : 'Unknown',
          color: Colors.grey,
        );
    }
  }
}

class StatusData {
  final String text;
  final Color color;

  StatusData({
    required this.text,
    required this.color,
  });
}
