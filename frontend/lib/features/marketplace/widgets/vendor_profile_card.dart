// features/marketplace/widgets/vendor_profile_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/responsive_helper.dart';

class VendorProfileCard extends StatelessWidget {
  final Map<String, dynamic> vendor;
  final VoidCallback? onTap;
  final VoidCallback? onContact;
  final VoidCallback? onViewProducts;

  const VendorProfileCard({
    super.key,
    required this.vendor,
    this.onTap,
    this.onContact,
    this.onViewProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildBio(),
              const SizedBox(height: 16),
              _buildStats(),
              const SizedBox(height: 16),
              _buildSpecialties(),
              const SizedBox(height: 16),
              _buildPaymentMethods(),
              const SizedBox(height: 16),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Vendor avatar
        Stack(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.orange.withValues(alpha: 0.1),
              backgroundImage: vendor['profileImage']?.isNotEmpty == true
                  ? CachedNetworkImageProvider(vendor['profileImage'])
                  : null,
              child: vendor['profileImage']?.isEmpty != false
                  ? Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.orange[700],
                    )
                  : null,
            ),
            // Verification badge
            if (vendor['verified'] == true)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Vendor info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      vendor['name'] ?? 'Vendor',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (vendor['verified'] == true)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'VERIFIED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      vendor['location'] ?? 'KZN',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${vendor['rating'] ?? 0.0}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${vendor['totalSales'] ?? 0} sales)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBio() {
    return Text(
      vendor['bio'] ?? 'Traditional artisan and cultural keeper.',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStatItem(
          'Years Active',
          '${vendor['yearsActive'] ?? 0}',
          Icons.access_time,
        ),
        const SizedBox(width: 24),
        _buildStatItem(
          'Products',
          '${(vendor['products'] as List?)?.length ?? 0}',
          Icons.inventory,
        ),
        const SizedBox(width: 24),
        _buildStatItem(
          'Languages',
          '${(vendor['languages'] as List?)?.length ?? 1}',
          Icons.language,
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.orange[700],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialties() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specialty',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          vendor['specialty'] ?? 'Traditional crafts',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    final paymentMethods = vendor['paymentMethods'] as List<dynamic>? ?? [];

    if (paymentMethods.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Methods',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: paymentMethods.map((method) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPaymentMethodColor(method.toString()).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getPaymentMethodColor(method.toString()).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getPaymentMethodIcon(method.toString()),
                    size: 14,
                    color: _getPaymentMethodColor(method.toString()),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getPaymentMethodLabel(method.toString()),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getPaymentMethodColor(method.toString()),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onContact,
            icon: const Icon(Icons.message, size: 16),
            label: const Text('Contact'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onViewProducts,
            icon: const Icon(Icons.storefront, size: 16),
            label: const Text('View Items'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Color _getPaymentMethodColor(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Colors.green;
      case 'snapscan':
        return Colors.blue;
      case 'zapper':
        return Colors.purple;
      case 'payshap':
        return Colors.orange;
      case 'card':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Icons.payments;
      case 'snapscan':
      case 'zapper':
      case 'payshap':
        return Icons.qr_code;
      case 'card':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentMethodLabel(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return 'Cash';
      case 'snapscan':
        return 'SnapScan';
      case 'zapper':
        return 'Zapper';
      case 'payshap':
        return 'PayShap';
      case 'card':
        return 'Card';
      default:
        return method.toUpperCase();
    }
  }
}
