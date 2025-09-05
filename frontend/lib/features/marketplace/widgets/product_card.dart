// Fix for ProductCard overflow issues
// features/marketplace/widgets/product_card_fixed.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/responsive_helper.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;
  final VoidCallback? onARTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onFavorite;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onARTap,
    this.onAddToCart,
    this.onFavorite,
    this.isWishlisted = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: _isHovered ? 8 : 3,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fixed height for image to prevent overflow
                    SizedBox(
                      height: ResponsiveHelper.isMobile(context) ? 140 : 160,
                      child: _buildImageHeader(context),
                    ),
                    // Use Expanded to allow content to flex
                    Expanded(
                      child: _buildContent(context),
                    ),
                    // Fixed height for action buttons
                    SizedBox(
                      height: 60,
                      child: _buildActionButtons(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Widget _buildImageHeader(BuildContext context) {
    final imageUrl = widget.product['imageUrl'] as String? ??
                    widget.product['image'] as String? ?? '';

    return Stack(
      children: [
        Positioned.fill(
          child: _buildImage(imageUrl),
        ),
        // Gradient overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
        ),
        // AR Badge
        if (widget.product['hasAR'] == true)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: widget.onARTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.view_in_ar, color: Colors.white, size: 12),
                    SizedBox(width: 2),
                    Text(
                      'AR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // Wishlist button
        Positioned(
          top: 8,
          left: 8,
          child: GestureDetector(
            onTap: widget.onFavorite,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: widget.isWishlisted ? Colors.red : Colors.grey[600],
                size: 16,
              ),
            ),
          ),
        ),
        // Stock status overlay
        if (widget.product['isInStock'] == false)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Text(
                  'OUT OF STOCK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(),
              size: 32,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 4),
            Text(
              _getCategoryName().toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[100],
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getCategoryIcon(), size: 32, color: Colors.grey[400]),
            const SizedBox(height: 4),
            Text(
              _getCategoryName().toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product title - Fixed height to prevent overflow
          SizedBox(
            height: 32,
            child: Text(
              widget.product['title'] ?? widget.product['name'] ?? 'Ubuntu Handcraft',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),

          // Artisan name - Fixed height
          SizedBox(
            height: 16,
            child: Row(
              children: [
                Icon(Icons.person, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    'by ${widget.product['artisan'] ?? widget.product['maker'] ?? 'Local Artisan'}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Rating and location - Fixed height
          SizedBox(
            height: 16,
            child: Row(
              children: [
                const Icon(Icons.star, size: 12, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  '${widget.product['rating'] ?? 4.5}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${widget.product['reviewCount'] ?? widget.product['reviews'] ?? 0})',
                  style: TextStyle(fontSize: 9, color: Colors.grey[500]),
                ),
                const Spacer(),
                if (widget.product['location'] != null) ...[
                  Icon(Icons.location_on, size: 10, color: Colors.grey[600]),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      widget.product['location'],
                      style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Use remaining space for price and features
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 4),
                _buildPriceSection(),
                const SizedBox(height: 4),
                _buildFeaturesRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    final price = (widget.product['price'] ?? 200).toDouble();
    final originalPrice = widget.product['originalPrice']?.toDouble();
    final currency = widget.product['currency'] ?? 'ZAR';
    final discount = widget.product['discount'] ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (originalPrice != null && originalPrice > price)
                Text(
                  '$currency ${originalPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              Row(
                children: [
                  Text(
                    '$currency ${price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  if (discount > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        '-$discount%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (widget.product['isInStock'] != false)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'In Stock',
              style: TextStyle(
                fontSize: 9,
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeaturesRow() {
    final features = <Widget>[];

    if (widget.product['hasAR'] == true) {
      features.add(_buildFeatureBadge('AR', Colors.purple));
    }
    if (widget.product['isUbuntu'] == true) {
      features.add(_buildFeatureBadge('Ubuntu', Colors.orange));
    }
    if (widget.product['isFairTrade'] == true) {
      features.add(_buildFeatureBadge('Fair Trade', Colors.green));
    }

    if (features.isEmpty) {
      features.add(_buildFeatureBadge('Authentic', Colors.blue));
    }

    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: features.take(2).toList(), // Limit to 2 features to prevent overflow
    );
  }

  Widget _buildFeatureBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 8,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          if (widget.onARTap != null && widget.product['hasAR'] == true) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onARTap,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  side: const BorderSide(color: Colors.purple),
                  foregroundColor: Colors.purple,
                  minimumSize: const Size(0, 32),
                ),
                child: const Text('AR', style: TextStyle(fontSize: 11)),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: widget.product['isInStock'] != false ? widget.onAddToCart : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.product['isInStock'] != false
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 4),
                minimumSize: const Size(0, 32),
              ),
              child: Text(
                widget.product['isInStock'] != false ? 'Add to Cart' : 'Out of Stock',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName() {
    final category = widget.product['category']?.toString().toLowerCase() ?? 'craft';
    switch (category) {
      case 'artwork':
        return 'Artwork';
      case 'textile':
        return 'Textile';
      case 'pottery':
        return 'Pottery';
      case 'food':
        return 'Food';
      case 'jewelry':
        return 'Jewelry';
      default:
        return 'Handcraft';
    }
  }

  IconData _getCategoryIcon() {
    final category = widget.product['category']?.toString().toLowerCase() ?? 'craft';
    switch (category) {
      case 'artwork':
        return Icons.palette;
      case 'textile':
        return Icons.checkroom;
      case 'pottery':
        return Icons.emoji_objects;
      case 'food':
        return Icons.restaurant;
      case 'jewelry':
        return Icons.diamond;
      default:
        return Icons.handyman;
    }
  }
}
