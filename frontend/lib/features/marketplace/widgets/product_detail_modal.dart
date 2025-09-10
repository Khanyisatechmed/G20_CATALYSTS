// features/marketplace/widgets/product_detail_modal.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/theme/marketplace_theme.dart';
import '../widgets/ar_viewer.dart';

class ProductDetailModal extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;
  final VoidCallback onToggleWishlist;
  final VoidCallback? onViewAR;
  final bool isWishlisted;

  const ProductDetailModal({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onToggleWishlist,
    this.onViewAR,
    required this.isWishlisted,
  });

  @override
  State<ProductDetailModal> createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  int _currentImageIndex = 0;
  int _quantity = 1;
  double _userRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  // Mock reviews data - would come from API in real app
  final List<Map<String, dynamic>> _reviews = [
    {
      'id': 1,
      'userName': 'Sarah M.',
      'rating': 5.0,
      'comment': 'Absolutely stunning! The craftsmanship is incredible and arrived perfectly packaged. The cultural story behind it makes it even more special.',
      'date': '2024-01-15',
      'verified': true,
      'images': ['https://picsum.photos/100/100?random=401'],
    },
    {
      'id': 2,
      'userName': 'John D.',
      'rating': 4.5,
      'comment': 'Beautiful work. Fast delivery and excellent quality. Supporting local artisans feels great!',
      'date': '2024-01-10',
      'verified': true,
      'images': [],
    },
    {
      'id': 3,
      'userName': 'Priya P.',
      'rating': 5.0,
      'comment': 'This piece has become a conversation starter in our home. The Ubuntu spirit really shines through.',
      'date': '2024-01-08',
      'verified': false,
      'images': ['https://picsum.photos/100/100?random=402'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageGallery(),
                      _buildProductInfo(),
                      _buildTabSection(),
                      const SizedBox(height: 100), // Space for floating button
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: widget.onToggleWishlist,
            icon: Icon(
              widget.isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: widget.isWishlisted ? Colors.red : Colors.grey[600],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = _getProductImages();

    return Container(
      height: 350,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showFullScreenImage(images[index]),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 64),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Image indicators
          if (images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),

          // AR badge
          if (widget.product['hasAR'] == true)
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: widget.onViewAR,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: MarketplaceTheme.arColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.view_in_ar, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'View in AR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    final title = widget.product['title'] as String? ?? 'Product';
    final price = widget.product['price'] as num? ?? 0;
    final currency = widget.product['currency'] as String? ?? 'ZAR';
    final rating = widget.product['rating'] as double? ?? 0;
    final reviewCount = widget.product['reviewCount'] as int? ?? 0;
    final isInStock = widget.product['isInStock'] == true;
    final stockQuantity = widget.product['stockQuantity'] as int? ?? 0;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and rating
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              if (rating > 0) ...[
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < rating.floor() ? Icons.star : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      );
                    }),
                    const SizedBox(width: 6),
                    Text(
                      '$rating ($reviewCount reviews)',
                      style: const TextStyle(
                        fontSize: 14,
                        color: MarketplaceTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
              ],

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isInStock
                      ? MarketplaceTheme.inStockColor.withOpacity(0.1)
                      : MarketplaceTheme.outOfStockColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isInStock ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(
                    color: isInStock
                        ? MarketplaceTheme.inStockColor
                        : MarketplaceTheme.outOfStockColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Price and badges
          Row(
            children: [
              Text(
                '$currency ${price.toInt()}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: MarketplaceTheme.primaryBlue,
                ),
              ),
              const Spacer(),
              _buildFeatureBadges(),
            ],
          ),

          if (stockQuantity > 0 && stockQuantity <= 5) ...[
            const SizedBox(height: 8),
            Text(
              'Only $stockQuantity left in stock',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const SizedBox(height: 20),
          _buildQuantitySelector(),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildFeatureBadges() {
    return Wrap(
      spacing: 6,
      children: [
        if (widget.product['isUbuntu'] == true)
          MarketplaceTheme.createBadge(text: 'Ubuntu', type: 'ubuntu'),
        if (widget.product['isFairTrade'] == true)
          MarketplaceTheme.createBadge(text: 'Fair Trade', type: 'fair_trade'),
        if (widget.product['isHandmade'] == true)
          MarketplaceTheme.createBadge(text: 'Handmade', type: 'handmade'),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    final stockQuantity = widget.product['stockQuantity'] as int? ?? 10;

    return Row(
      children: [
        const Text(
          'Quantity:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            IconButton(
              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
              icon: const Icon(Icons.remove, size: 18),
              style: IconButton.styleFrom(
                backgroundColor: _quantity > 1
                    ? MarketplaceTheme.primaryBlue
                    : Colors.grey[300],
                foregroundColor: _quantity > 1 ? Colors.white : Colors.grey[600],
                minimumSize: const Size(36, 36),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$_quantity',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: _quantity < stockQuantity
                  ? () => setState(() => _quantity++)
                  : null,
              icon: const Icon(Icons.add, size: 18),
              style: IconButton.styleFrom(
                backgroundColor: _quantity < stockQuantity
                    ? MarketplaceTheme.primaryBlue
                    : Colors.grey[300],
                foregroundColor: _quantity < stockQuantity
                    ? Colors.white
                    : Colors.grey[600],
                minimumSize: const Size(36, 36),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final isInStock = widget.product['isInStock'] == true;

    return Row(
      children: [
        if (widget.onViewAR != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: widget.onViewAR,
              icon: const Icon(Icons.view_in_ar, size: 18),
              label: const Text('AR View'),
              style: OutlinedButton.styleFrom(
                foregroundColor: MarketplaceTheme.arColor,
                side: BorderSide(color: MarketplaceTheme.arColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        if (widget.onViewAR != null) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: isInStock ? widget.onAddToCart : null,
            icon: const Icon(Icons.shopping_cart, size: 18),
            label: Text(isInStock ? 'Add to Cart' : 'Out of Stock'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isInStock
                  ? MarketplaceTheme.primaryBlue
                  : Colors.grey[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              disabledBackgroundColor: Colors.grey[400],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabSection() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: MarketplaceTheme.primaryBlue,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: MarketplaceTheme.primaryBlue,
          tabs: const [
            Tab(text: 'Description'),
            Tab(text: 'Vendor'),
            Tab(text: 'Reviews'),
          ],
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDescriptionTab(),
              _buildVendorTab(),
              _buildReviewsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product['description'] ?? 'No description available.',
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          if (widget.product['culturalSignificance'] != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_stories, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      const Text(
                        'Cultural Significance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product['culturalSignificance'] as String,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          _buildSpecifications(),
        ],
      ),
    );
  }

  Widget _buildVendorTab() {
    final artisan = widget.product['artisan'] as String? ?? 'Unknown Artisan';
    final location = widget.product['location'] as String? ?? 'KZN';
    final vendor = widget.product['vendor'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: MarketplaceTheme.primaryBlue.withOpacity(0.1),
                  child: Text(
                    artisan[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: MarketplaceTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  artisan,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  vendor['bio'] as String? ??
                  'A skilled artisan dedicated to preserving traditional South African craftsmanship and cultural heritage.',
                  style: const TextStyle(fontSize: 14, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                if (vendor['rating'] != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${vendor['rating']} vendor rating',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _contactVendor(),
                      icon: const Icon(Icons.message, size: 16),
                      label: const Text('Message'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _viewMoreFromVendor(),
                      icon: const Icon(Icons.storefront, size: 16),
                      label: const Text('More Items'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    final averageRating = _reviews.fold<double>(
      0, (sum, review) => sum + (review['rating'] as double)
    ) / _reviews.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: MarketplaceTheme.primaryBlue,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < averageRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                    Text(
                      '${_reviews.length} reviews',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((star) {
                      final count = _reviews.where((r) =>
                        (r['rating'] as double).floor() == star
                      ).length;
                      return Row(
                        children: [
                          Text('$star', style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: count / _reviews.length,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation(Colors.amber),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text('$count', style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Individual reviews
          ..._reviews.map((review) => _buildReviewItem(review)),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _writeReview(),
              child: const Text('Write a Review'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: MarketplaceTheme.primaryBlue.withOpacity(0.1),
                child: Text(
                  (review['userName'] as String)[0],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: MarketplaceTheme.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review['userName'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (review['verified'] == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < (review['rating'] as double)
                                ? Icons.star
                                : Icons.star_border,
                            size: 12,
                            color: Colors.amber,
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          review['date'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review['comment'] as String,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          if ((review['images'] as List).isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (review['images'] as List).length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                      right: index < (review['images'] as List).length - 1 ? 8 : 0
                    ),
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: (review['images'] as List)[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecifications() {
    final dimensions = widget.product['dimensions'] as Map<String, dynamic>? ?? {};
    final materials = widget.product['materials'] as List<dynamic>? ?? [];
    final weight = widget.product['weight'] as num?;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (dimensions.isNotEmpty)
            _buildSpecRow('Dimensions',
              '${dimensions['length']} × ${dimensions['width']} × ${dimensions['height']} ${dimensions['unit']}'),
          if (weight != null)
            _buildSpecRow('Weight', '${weight}kg'),
          if (materials.isNotEmpty)
            _buildSpecRow('Materials', materials.join(', ')),
          _buildSpecRow('Origin', widget.product['location'] ?? 'KwaZulu-Natal, South Africa'),
          _buildSpecRow('Handmade', 'Yes'),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getProductImages() {
    final imageUrl = widget.product['imageUrl'] as String?;
    final images = widget.product['images'] as List<dynamic>?;

    final List<String> productImages = [];

    if (imageUrl != null && imageUrl.isNotEmpty) {
      productImages.add(imageUrl);
    }

    if (images != null && images.isNotEmpty) {
      for (final img in images) {
        if (img is String && img.isNotEmpty && !productImages.contains(img)) {
          productImages.add(img);
        }
      }
    }

    // Fallback to a placeholder if no images found
    if (productImages.isEmpty) {
      productImages.add('https://via.placeholder.com/400x400?text=No+Image');
    }

    return productImages;
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.broken_image, color: Colors.white, size: 64),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _contactVendor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.message, color: MarketplaceTheme.primaryBlue),
            const SizedBox(width: 8),
            const Text('Contact Vendor'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact ${widget.product['artisan'] ?? 'the vendor'} directly:',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.phone, color: MarketplaceTheme.primaryBlue),
              title: const Text('Call'),
              subtitle: const Text('+27 12 345 6789'),
              onTap: () {
                Navigator.pop(context);
                _launchPhone('+27123456789');
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: MarketplaceTheme.primaryBlue),
              title: const Text('Email'),
              subtitle: const Text('vendor@wandersmarketplace.co.za'),
              onTap: () {
                Navigator.pop(context);
                _launchEmail('vendor@wandersmarketplace.co.za');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: MarketplaceTheme.primaryBlue),
              title: const Text('In-App Message'),
              subtitle: const Text('Send a message through Wanders'),
              onTap: () {
                Navigator.pop(context);
                _openMessaging();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewMoreFromVendor() {
    Navigator.pop(context); // Close the modal first
    Navigator.pushNamed(
      context,
      '/vendor_profile',
      arguments: {
        'vendorId': widget.product['vendorId'] ?? 'unknown',
        'vendorName': widget.product['artisan'] ?? 'Unknown Artisan',
        'location': widget.product['location'] ?? 'KZN',
      },
    );
  }

  void _writeReview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildReviewBottomSheet(),
    );
  }

  Widget _buildReviewBottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Write a Review',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product summary
                  _buildReviewProductSummary(),
                  const SizedBox(height: 24),

                  // Rating section
                  _buildRatingSection(),
                  const SizedBox(height: 24),

                  // Review text
                  _buildReviewTextSection(),
                  const SizedBox(height: 24),

                  // Photo upload section
                  _buildPhotoUploadSection(),
                  const SizedBox(height: 32),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _userRating > 0 && _reviewController.text.isNotEmpty
                          ? () {
                              Navigator.pop(context);
                              _submitReview();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MarketplaceTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: const Text(
                        'Submit Review',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildReviewProductSummary() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: widget.product['imageUrl'] ?? '',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product['title'] ?? 'Product',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'by ${widget.product['artisan'] ?? 'Unknown'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Rating',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            return GestureDetector(
              onTap: () => setState(() => _userRating = starValue.toDouble()),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  _userRating >= starValue ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 40,
                ),
              ),
            );
          }),
        ),
        if (_userRating > 0)
          Center(
            child: Text(
              _getRatingText(_userRating),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Review',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _reviewController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Share your experience with this product...',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_reviewController.text.length}/500 characters',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Photos (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo, size: 32, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'Tap to add photos',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getRatingText(double rating) {
    switch (rating.toInt()) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  void _launchPhone(String phoneNumber) {
    // Implementation for launching phone dialer
    // In a real app, you'd use url_launcher package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Would call: $phoneNumber')),
    );
  }

  void _launchEmail(String email) {
    // Implementation for launching email app
    // In a real app, you'd use url_launcher package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Would email: $email')),
    );
  }

  void _openMessaging() {
    // Navigate to messaging screen or open in-app chat
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'recipientId': widget.product['vendorId'],
        'recipientName': widget.product['artisan'],
        'productId': widget.product['id'],
        'productTitle': widget.product['title'],
      },
    );
  }

  void _submitReview() {
    // Handle review submission
    final reviewData = {
      'productId': widget.product['id'],
      'rating': _userRating,
      'comment': _reviewController.text,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // In a real app, send this to your API
    print('Submitting review: $reviewData');

    // Reset form
    setState(() {
      _userRating = 0;
      _reviewController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your review!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
