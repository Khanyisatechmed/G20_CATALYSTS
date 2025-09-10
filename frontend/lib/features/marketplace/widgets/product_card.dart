// features/marketplace/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/theme/marketplace_theme.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;
  final VoidCallback? onARTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onFavorite;
  final bool isWishlisted;
  final bool showFullDetails;
  final bool isCompact;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onARTap,
    this.onAddToCart,
    this.onFavorite,
    this.isWishlisted = false,
    this.showFullDetails = false,
    this.isCompact = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
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
    final isMobile = ResponsiveHelper.isMobile(context);

    return MouseRegion(
      onEnter: (_) => _onHoverStart(),
      onExit: (_) => _onHoverEnd(),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: MarketplaceTheme.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 2),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(widget.isCompact ? 8 : (isMobile ? 12 : 16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleAndRating(),
                            const SizedBox(height: 6),
                            _buildArtisanInfo(),
                            if (!widget.isCompact) ...[
                              const SizedBox(height: 8),
                              _buildLocationAndRegion(),
                            ],
                            const SizedBox(height: 8),
                            _buildPriceSection(),
                            if (widget.showFullDetails) ...[
                              const SizedBox(height: 12),
                              _buildFeatureTags(),
                            ],
                            const Spacer(),
                            _buildActionButtons(),
                          ],
                        ),
                      ),
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

  Widget _buildImageSection() {
    final imageUrl = widget.product['imageUrl'] as String?;
    final hasAR = widget.product['hasAR'] == true;
    final isInStock = widget.product['isInStock'] == true;
    final discount = widget.product['discount'] as int?;
    final isHandmade = widget.product['isHandmade'] == true;

    return Container(
      height: widget.isCompact ? 160 : 200,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          // Main image with shimmer effect
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[100],
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: 32,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Image unavailable',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 32,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No image',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          // Gradient overlay for better text readability
          if (hasAR || !isInStock || discount != null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
            ),

          // Top row badges
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Stock status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isInStock
                        ? MarketplaceTheme.inStockColor
                        : MarketplaceTheme.outOfStockColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isInStock ? Icons.check_circle : Icons.cancel,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isInStock ? 'In Stock' : 'Out of Stock',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Wishlist button
                GestureDetector(
                  onTap: widget.onFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isWishlisted ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: widget.isWishlisted
                          ? Colors.red
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom row badges
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Feature badges row
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (hasAR)
                        MarketplaceTheme.createBadge(
                          text: 'AR',
                          type: 'ar',
                          fontSize: 9,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        ),
                      if (widget.product['isUbuntu'] == true)
                        MarketplaceTheme.createBadge(
                          text: 'Ubuntu',
                          type: 'ubuntu',
                          fontSize: 9,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        ),
                      if (widget.product['isFairTrade'] == true)
                        MarketplaceTheme.createBadge(
                          text: 'Fair Trade',
                          type: 'fair_trade',
                          fontSize: 9,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        ),
                      if (isHandmade)
                        MarketplaceTheme.createBadge(
                          text: 'Handmade',
                          type: 'handmade',
                          fontSize: 9,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        ),
                    ],
                  ),
                ),

                // Discount badge
                if (discount != null && discount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: MarketplaceTheme.getBadgeColor('discount'),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '-$discount%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // AR interactive overlay
          if (hasAR && widget.onARTap != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  onTap: widget.onARTap,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: MarketplaceTheme.arColor.withOpacity(0.15),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MarketplaceTheme.arColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: MarketplaceTheme.arColor.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.view_in_ar,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitleAndRating() {
    final title = widget.product['title'] as String? ?? 'Untitled Product';
    final rating = widget.product['rating'] as double?;
    final reviewCount = widget.product['reviewCount'] as int? ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: widget.isCompact ? 14 : 15,
            fontWeight: FontWeight.bold,
            color: MarketplaceTheme.textPrimary,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (rating != null && !widget.isCompact) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < rating.floor()
                      ? Icons.star_rounded
                      : index < rating
                          ? Icons.star_half_rounded
                          : Icons.star_border_rounded,
                  size: 14,
                  color: Colors.amber[600],
                );
              }),
              const SizedBox(width: 6),
              Text(
                '$rating',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MarketplaceTheme.textSecondary,
                ),
              ),
              if (reviewCount > 0) ...[
                Text(
                  ' ($reviewCount)',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildArtisanInfo() {
    final artisan = widget.product['artisan'] as String?;

    if (artisan == null) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(
          Icons.person_outline_rounded,
          size: 14,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            'by $artisan',
            style: TextStyle(
              fontSize: widget.isCompact ? 11 : 12,
              color: MarketplaceTheme.textSecondary,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationAndRegion() {
    final location = widget.product['location'] as String?;
    final region = widget.product['region'] as String?;

    if (location == null && region == null) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 12,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            location ?? region ?? '',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    final price = widget.product['price'] as num?;
    final originalPrice = widget.product['originalPrice'] as num?;
    final currency = widget.product['currency'] as String? ?? 'ZAR';
    final stockQuantity = widget.product['stockQuantity'] as int?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (originalPrice != null && originalPrice > (price ?? 0)) ...[
              Text(
                '$currency ${originalPrice.toInt()}',
                style: TextStyle(
                  fontSize: widget.isCompact ? 11 : 12,
                  color: Colors.grey[500],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              '$currency ${price?.toInt() ?? 0}',
              style: TextStyle(
                fontSize: widget.isCompact ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: MarketplaceTheme.primaryBlue,
              ),
            ),
          ],
        ),
        if (stockQuantity != null && stockQuantity <= 5 && stockQuantity > 0) ...[
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Only $stockQuantity left',
              style: TextStyle(
                fontSize: 9,
                color: Colors.orange[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeatureTags() {
    final features = <Map<String, String>>[];

    if (widget.product['isFairTrade'] == true) {
      features.add({'label': 'Fair Trade', 'type': 'fair_trade'});
    }
    if (widget.product['isHandmade'] == true) {
      features.add({'label': 'Handmade', 'type': 'handmade'});
    }
    if (widget.product['isUbuntu'] == true) {
      features.add({'label': 'Ubuntu', 'type': 'ubuntu'});
    }

    if (features.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: features.map((feature) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: MarketplaceTheme.getBadgeColor(feature['type']!).withOpacity(0.1),
            border: Border.all(
              color: MarketplaceTheme.getBadgeColor(feature['type']!).withOpacity(0.4),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            feature['label']!,
            style: TextStyle(
              fontSize: 9,
              color: MarketplaceTheme.getBadgeColor(feature['type']!),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    final isInStock = widget.product['isInStock'] == true;
    final hasAR = widget.product['hasAR'] == true;

    if (widget.isCompact) {
      return SizedBox(
        width: double.infinity,
        height: 32,
        child: ElevatedButton.icon(
          onPressed: isInStock ? widget.onAddToCart : null,
          icon: const Icon(Icons.add_shopping_cart, size: 14),
          label: Text(
            isInStock ? 'Add to Cart' : 'Out of Stock',
            style: const TextStyle(fontSize: 11),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isInStock
                ? MarketplaceTheme.primaryBlue
                : Colors.grey[400],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        if (hasAR && widget.onARTap != null) ...[
          SizedBox(
            width: double.infinity,
            height: 32,
            child: OutlinedButton.icon(
              onPressed: widget.onARTap,
              icon: const Icon(Icons.view_in_ar, size: 14),
              label: const Text('View in AR', style: TextStyle(fontSize: 11)),
              style: OutlinedButton.styleFrom(
                foregroundColor: MarketplaceTheme.arColor,
                side: BorderSide(color: MarketplaceTheme.arColor, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          width: double.infinity,
          height: 36,
          child: ElevatedButton.icon(
            onPressed: isInStock ? widget.onAddToCart : null,
            icon: const Icon(Icons.add_shopping_cart, size: 16),
            label: Text(
              isInStock ? 'Add to Cart' : 'Out of Stock',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isInStock
                  ? MarketplaceTheme.primaryBlue
                  : Colors.grey[400],
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: isInStock ? 2 : 0,
            ),
          ),
        ),
      ],
    );
  }

  void _onHoverStart() {
    if (!ResponsiveHelper.isMobile(context)) {
      setState(() => _isHovered = true);
      _animationController.forward();
    }
  }

  void _onHoverEnd() {
    if (!ResponsiveHelper.isMobile(context)) {
      setState(() => _isHovered = false);
      _animationController.reverse();
    }
  }
}
