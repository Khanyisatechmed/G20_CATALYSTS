import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/ar_viewer.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      body: ResponsiveLayoutBuilder(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
      floatingActionButton: isMobile ? _buildFloatingActions() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductHeader(),
                const SizedBox(height: 24),
                _buildPriceSection(),
                const SizedBox(height: 24),
                _buildARSection(),
                const SizedBox(height: 24),
                _buildDescription(),
                const SizedBox(height: 24),
                _buildArtisanInfo(),
                const SizedBox(height: 24),
                _buildCulturalSignificance(),
                const SizedBox(height: 24),
                _buildSpecifications(),
                const SizedBox(height: 24),
                _buildReviewsSection(),
                const SizedBox(height: 100), // Space for floating action buttons
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildProductHeader(),
                          const SizedBox(height: 24),
                          _buildDescription(),
                          const SizedBox(height: 24),
                          _buildCulturalSignificance(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: Column(
                        children: [
                          _buildPriceSection(),
                          const SizedBox(height: 24),
                          _buildARSection(),
                          const SizedBox(height: 24),
                          _buildQuantitySelector(),
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildArtisanInfo(),
                const SizedBox(height: 32),
                _buildSpecifications(),
                const SizedBox(height: 32),
                _buildReviewsSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left side - Image gallery
        Expanded(
          flex: 3,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                // Back button
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                      style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            size: 14,
                            color: Colors.orange,
                          );
                        }),
                      ),
                    ],
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          review,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActions() {
    if (widget.product['isInStock'] != true) return const SizedBox.shrink();

    final totalPrice = (widget.product['price']?.toDouble() ?? 200.0) * _quantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Quantity selector
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  _quantity.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _quantity < 10 ? () => setState(() => _quantity++) : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Add to cart button
          Expanded(
            child: ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add to Cart • ${widget.product['currency'] ?? 'ZAR'} ${totalPrice.toInt()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchARViewer() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: ResponsiveHelper.isMobile(context) ?
              MediaQuery.of(context).size.width * 0.9 : 600,
          height: ResponsiveHelper.isMobile(context) ?
              MediaQuery.of(context).size.height * 0.8 : 500,
          child: ARViewer(
            product: widget.product,
            onClose: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  void _addToCart() {
    final cartItem = Map<String, dynamic>.from(widget.product);
    cartItem['quantity'] = _quantity;
    cartItem['totalPrice'] = (widget.product['price']?.toDouble() ?? 200.0) * _quantity;

    context.read<MarketplaceProvider>().addToCart(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product['title']} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  void _addToWishlist() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? 'Added to wishlist'
              : 'Removed from wishlist'
        ),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _shareProduct() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon!')),
    );
  }

  void _viewArtisanProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${widget.product['artisan']} Profile'),
        content: const Text('Artisan profile feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _viewMoreFromArtisan() {
    Navigator.pushNamed(
      context,
      '/marketplace',
      arguments: {'artisan': widget.product['artisan']},
    );
  }

  void _contactArtisan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Artisan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call'),
              subtitle: const Text('+27 58 713 0126'),
              onTap: () {
                Navigator.pop(context);
                // Implement phone call
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: const Text('artisan@example.com'),
              onTap: () {
                Navigator.pop(context);
                // Implement email
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Message'),
              subtitle: const Text('Send a direct message'),
              onTap: () {
                Navigator.pop(context);
                // Implement messaging
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewAllReviews() {
    Navigator.pushNamed(
      context,
      '/product-reviews',
      arguments: widget.product,
    );
  }

  void _writeReview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Write Review'),
        content: const Text('Review feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Main image
                Expanded(child: _buildImageGallery()),
              ],
            ),
          ),
        ),
        // Right side - Content
        Expanded(
          flex: 2,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(48),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHeader(),
                  const SizedBox(height: 24),
                  _buildPriceSection(),
                  const SizedBox(height: 24),
                  _buildARSection(),
                  const SizedBox(height: 24),
                  _buildQuantitySelector(),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                  const SizedBox(height: 32),
                  _buildDescription(),
                  const SizedBox(height: 32),
                  _buildArtisanInfo(),
                  const SizedBox(height: 32),
                  _buildCulturalSignificance(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    final images = List<String>.from(widget.product['images'] ?? ['']);
    final hasImages = images.isNotEmpty && images.first.isNotEmpty;

    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        style: IconButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.5),
        ),
      ),
      actions: [
        IconButton(
          onPressed: _toggleFavorite,
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.white,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0.5),
          ),
        ),
        IconButton(
          onPressed: _shareProduct,
          icon: const Icon(Icons.share, color: Colors.white),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: hasImages
            ? PageView.builder(
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 80),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = List<String>.from(widget.product['images'] ?? ['']);
    final hasImages = images.isNotEmpty && images.first.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: hasImages
            ? Stack(
                children: [
                  PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: images[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, size: 80),
                        ),
                      );
                    },
                  ),
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
                            margin: const EdgeInsets.symmetric(horizontal: 4),
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
                  if (widget.product['hasAR'] == true)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'AR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product['title'] ?? 'Rustic Terracotta Vase',
          style: TextStyle(
            fontSize: ResponsiveHelper.isMobile(context) ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'by ${widget.product['artisan'] ?? 'Local Artisan'}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (widget.product['rating'] != null) ...[
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.product['rating']}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${widget.product['reviewCount'] ?? 0} reviews)',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: widget.product['isInStock'] == true
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.product['isInStock'] == true ? 'In Stock' : 'Out of Stock',
                style: TextStyle(
                  color: widget.product['isInStock'] == true
                      ? Colors.green
                      : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.product['currency'] ?? 'ZAR'} ${widget.product['price']?.toInt() ?? 200}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Text(
                'Handcrafted with traditional techniques',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if (widget.product['hasAR'] == true)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.view_in_ar,
                color: Colors.white,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildARSection() {
    if (widget.product['hasAR'] != true) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.view_in_ar,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'View in Augmented Reality',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'See how this item looks in your space before buying',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _launchARViewer,
              icon: const Icon(Icons.view_in_ar),
              label: const Text('View in AR'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Description',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.product['description'] ??
          'This beautiful terracotta vase showcases the rich pottery traditions of South African artisans. Each piece is hand-thrown and fired using traditional methods passed down through generations. The rustic finish and earthy tones make it perfect for both traditional and contemporary spaces.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Materials: ${widget.product['materials']?.join(', ') ?? 'Clay, Natural glazes'}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildArtisanInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product['artisan'] ?? 'Local Artisan',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Master Potter • ${widget.product['location'] ?? 'Mpumalanga'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.product['artisanBio'] ??
            'A skilled artisan with over 20 years of experience in traditional pottery making. Learned the craft from community elders and now teaches young people to preserve these ancient techniques.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _viewArtisanProfile,
                icon: const Icon(Icons.person, size: 18),
                label: const Text('View Profile'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _viewMoreFromArtisan,
                icon: const Icon(Icons.storefront, size: 18),
                label: const Text('More Items'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCulturalSignificance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories,
                color: Colors.orange[700],
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Cultural Significance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.product['culturalSignificance'] ??
            'In South African tradition, pottery serves both practical and spiritual purposes. Each piece is believed to hold the energy of the earth and the skill of the maker. The terracotta clay connects us to our ancestors, while the geometric patterns often tell stories of community, harvest, and celebration.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications() {
    final dimensions = widget.product['dimensions'] as Map<String, dynamic>? ?? {};

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (dimensions.isNotEmpty) ...[
            _buildSpecRow('Dimensions',
                '${dimensions['length'] ?? 'N/A'} × ${dimensions['width'] ?? 'N/A'} × ${dimensions['height'] ?? 'N/A'} ${dimensions['unit'] ?? 'cm'}'),
          ],
          _buildSpecRow('Weight', '${widget.product['weight'] ?? 0.5} kg'),
          _buildSpecRow('Category', widget.product['category'] ?? 'Pottery'),
          _buildSpecRow('Origin', widget.product['location'] ?? 'Mpumalanga, South Africa'),
          _buildSpecRow('Handmade', 'Yes'),
          _buildSpecRow('Care Instructions', 'Hand wash with mild soap, air dry'),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
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
            'Quantity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _quantity > 1 ? Colors.black87 : Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                _quantity.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _quantity < 10 ? () => setState(() => _quantity++) : null,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _quantity < 10 ? Colors.black87 : Colors.grey,
                ),
              ),
              const Spacer(),
              Text(
                'Stock: ${widget.product['stockQuantity'] ?? 1}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final totalPrice = (widget.product['price']?.toDouble() ?? 200.0) * _quantity;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.product['isInStock'] == true ? _addToCart : null,
            icon: const Icon(Icons.shopping_cart),
            label: Text('Add to Cart • ${widget.product['currency'] ?? 'ZAR'} ${totalPrice.toInt()}'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
              disabledBackgroundColor: Colors.grey[300],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _addToWishlist,
                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                label: const Text('Wishlist'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _contactArtisan,
                icon: const Icon(Icons.message),
                label: const Text('Contact'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _viewAllReviews,
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildReviewItem(
            'Sarah M.',
            4.5,
            'Beautiful craftsmanship! The vase arrived perfectly packaged and looks even better in person.',
            '2 days ago',
          ),
          const Divider(height: 24),
          _buildReviewItem(
            'John D.',
            5.0,
            'Absolutely stunning piece. The detail and quality exceeded my expectations.',
            '1 week ago',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _writeReview,
              child: const Text('Write a Review'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, double rating, String review, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[200],
              child: Text(
                name[0],
                style:
