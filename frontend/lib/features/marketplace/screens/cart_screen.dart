// features/marketplace/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../../../core/theme/marketplace_theme.dart';
import '../providers/marketplace_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _promoController = TextEditingController();
  double _promoDiscount = 0.0;
  bool _isApplyingPromo = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MarketplaceTheme.lightTheme,
      child: Scaffold(
        backgroundColor: MarketplaceTheme.lightBackground,
        appBar: _buildAppBar(),
        body: ResponsiveLayoutBuilder(
          mobile: (context, constraints) => _buildMobileLayout(),
          tablet: (context, constraints) => _buildTabletLayout(),
          desktop: (context, constraints) => _buildDesktopLayout(),
        ),
        bottomNavigationBar: ResponsiveHelper.isMobile(context)
            ? const CustomBottomNav(currentRoute: '/cart')
            : null,
        floatingActionButton: _buildCheckoutButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Consumer<MarketplaceProvider>(
        builder: (context, provider, child) {
          return Row(
            children: [
              const Text('Shopping Cart'),
              if (provider.cartItemCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${provider.cartItemCount} items',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
      backgroundColor: MarketplaceTheme.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 2,
      actions: [
        Consumer<MarketplaceProvider>(
          builder: (context, provider, child) {
            if (provider.cart.isEmpty) return const SizedBox.shrink();

            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'clear':
                    _showClearCartDialog();
                    break;
                  case 'save':
                    _saveCartForLater();
                    break;
                  case 'share':
                    _shareCart();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all, size: 20),
                      SizedBox(width: 8),
                      Text('Clear Cart'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'save',
                  child: Row(
                    children: [
                      Icon(Icons.bookmark, size: 20),
                      SizedBox(width: 8),
                      Text('Save for Later'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, size: 20),
                      SizedBox(width: 8),
                      Text('Share Cart'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.cart.isEmpty) {
          return _buildEmptyCart();
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() {});
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.cart.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildCartItem(provider.cart[index], provider);
                  },
                ),
              ),
            ),
            _buildCartSummaryBottomSheet(provider),
          ],
        );
      },
    );
  }

  Widget _buildTabletLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.cart.isEmpty) {
          return _buildEmptyCart();
        }

        return Row(
          children: [
            Expanded(
              flex: 2,
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() {});
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: provider.cart.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildCartItem(provider.cart[index], provider);
                  },
                ),
              ),
            ),
            Container(
              width: 350,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(-2, 0),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildCartSummary(provider),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.cart.isEmpty) {
          return _buildEmptyCart();
        }

        return Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500));
                    setState(() {});
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(32),
                    itemCount: provider.cart.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      return _buildCartItem(provider.cart[index], provider);
                    },
                  ),
                ),
              ),
              Container(
                width: 400,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: _buildCartSummary(provider),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: MarketplaceTheme.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: MarketplaceTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MarketplaceTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Discover amazing handcrafted products\nfrom South African artisans',
              style: TextStyle(
                fontSize: 16,
                color: MarketplaceTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/marketplace'),
              icon: const Icon(Icons.explore),
              label: const Text('Explore Products'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: MarketplaceTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, MarketplaceProvider provider) {
    final imageUrl = item['imageUrl'] as String?;
    final title = item['title'] as String? ?? 'Unknown Product';
    final artisan = item['artisan'] as String?;
    final price = item['price'] as num? ?? 0;
    final quantity = item['quantity'] as int? ?? 1;
    final currency = item['currency'] as String? ?? 'ZAR';
    final isInStock = item['isInStock'] == true;
    final stockQuantity = item['stockQuantity'] as int? ?? 0;
    final hasAR = item['hasAR'] == true;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isInStock
              ? Colors.transparent
              : MarketplaceTheme.outOfStockColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    children: [
                      imageUrl != null && imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[100],
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[100],
                                child: const Icon(Icons.broken_image_outlined, size: 32),
                              ),
                            )
                          : Container(
                              color: Colors.grey[100],
                              child: const Icon(Icons.image_outlined, size: 32),
                            ),
                      // Status overlay
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: isInStock
                                ? MarketplaceTheme.inStockColor
                                : MarketplaceTheme.outOfStockColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            isInStock ? Icons.check : Icons.close,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // AR badge
                      if (hasAR)
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: MarketplaceTheme.arColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'AR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MarketplaceTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (artisan != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'by $artisan',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Price and stock info
                    Row(
                      children: [
                        Text(
                          '$currency ${price.toInt()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MarketplaceTheme.primaryBlue,
                          ),
                        ),
                        const Spacer(),
                        if (stockQuantity > 0 && stockQuantity <= 5)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Only $stockQuantity left',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Remove button
              IconButton(
                onPressed: () => _removeItem(item['id'], provider),
                icon: const Icon(Icons.delete_outline),
                iconSize: 20,
                color: Colors.red[400],
                tooltip: 'Remove from cart',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quantity controls and total
          Row(
            children: [
              // Quantity controls
              Container(
                decoration: BoxDecoration(
                  color: MarketplaceTheme.lightBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: quantity > 1
                          ? () => provider.updateCartQuantity(item['id'], quantity - 1)
                          : null,
                      icon: const Icon(Icons.remove, size: 18),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      style: IconButton.styleFrom(
                        backgroundColor: quantity > 1
                            ? MarketplaceTheme.primaryBlue
                            : Colors.grey[300],
                        foregroundColor: quantity > 1
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MarketplaceTheme.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: isInStock && quantity < (stockQuantity > 0 ? stockQuantity : 10)
                          ? () => provider.updateCartQuantity(item['id'], quantity + 1)
                          : null,
                      icon: const Icon(Icons.add, size: 18),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      style: IconButton.styleFrom(
                        backgroundColor: isInStock && quantity < (stockQuantity > 0 ? stockQuantity : 10)
                            ? MarketplaceTheme.primaryBlue
                            : Colors.grey[300],
                        foregroundColor: isInStock && quantity < (stockQuantity > 0 ? stockQuantity : 10)
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Item total
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Item Total',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '$currency ${(price * quantity).toInt()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MarketplaceTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummaryBottomSheet(MarketplaceProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            _buildCompactSummary(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSummary(MarketplaceProvider provider) {
    final subtotal = provider.cartTotal;
    final shipping = subtotal > 500 ? 0.0 : 50.0;
    final tax = subtotal * 0.15;
    final discount = _promoDiscount;
    final total = subtotal + shipping + tax - discount;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${provider.cartItemCount} items',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: MarketplaceTheme.textPrimary,
              ),
            ),
            Text(
              'ZAR ${total.toInt()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MarketplaceTheme.primaryBlue,
              ),
            ),
          ],
        ),
        if (shipping == 0) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.local_shipping,
                size: 16,
                color: Colors.green[600],
              ),
              const SizedBox(width: 4),
              const Text(
                'Free shipping included!',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCartSummary(MarketplaceProvider provider) {
    final subtotal = provider.cartTotal;
    final shipping = subtotal > 500 ? 0.0 : 50.0;
    final tax = subtotal * 0.15;
    final discount = _promoDiscount;
    final total = subtotal + shipping + tax - discount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MarketplaceTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 20),
        _buildSummaryRow('Subtotal', subtotal),
        _buildSummaryRow('Shipping', shipping, isSpecial: shipping == 0),
        _buildSummaryRow('VAT (15%)', tax),
        if (discount > 0)
          _buildSummaryRow('Discount', -discount, isDiscount: true),
        const Divider(height: 32),
        _buildSummaryRow('Total', total, isTotal: true),
        const SizedBox(height: 24),
        _buildPromoCodeSection(),
        const SizedBox(height: 20),
        if (shipping == 0)
          _buildShippingInfo()
        else
          _buildShippingUpgrade(500 - subtotal),
        const SizedBox(height: 20),
        _buildTrustSignals(),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double amount, {
    bool isTotal = false,
    bool isSpecial = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          Text(
            isSpecial && amount == 0
                ? 'FREE'
                : isDiscount
                    ? '-ZAR ${amount.abs().toInt()}'
                    : 'ZAR ${amount.toInt()}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isSpecial && amount == 0
                  ? Colors.green
                  : isDiscount
                      ? Colors.green
                      : isTotal
                          ? MarketplaceTheme.primaryBlue
                          : MarketplaceTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MarketplaceTheme.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Promo Code',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoController,
                  decoration: const InputDecoration(
                    hintText: 'Enter code',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: _isApplyingPromo ? null : _applyPromoCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarketplaceTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: _isApplyingPromo
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Apply'),
                ),
              ),
            ],
          ),
          if (_promoDiscount > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.green[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Promo applied! You saved ZAR ${_promoDiscount.toInt()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_shipping,
            color: Colors.green[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Free shipping on orders over R500!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingUpgrade(double amountNeeded) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_shipping,
            color: Colors.orange[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Add ZAR ${amountNeeded.toInt()} more for free shipping!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustSignals() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Your purchase is protected',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTrustItem(Icons.security, 'Secure\nPayment'),
              _buildTrustItem(Icons.verified, 'Authentic\nProducts'),
              _buildTrustItem(Icons.support_agent, 'Customer\nSupport'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: MarketplaceTheme.primaryBlue,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color: MarketplaceTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget? _buildCheckoutButton() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.cart.isEmpty) return const SizedBox.shrink();

        final subtotal = provider.cartTotal;
        final shipping = subtotal > 500 ? 0.0 : 50.0;
        final tax = subtotal * 0.15;
        final discount = _promoDiscount;
        final total = subtotal + shipping + tax - discount;

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.isMobile(context) ? 16 : 32,
          ),
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _proceedToCheckout,
            icon: const Icon(Icons.payment),
            label: Text(
              ResponsiveHelper.isMobile(context)
                  ? 'Checkout • ZAR ${total.toInt()}'
                  : 'Proceed to Checkout • ZAR ${total.toInt()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: MarketplaceTheme.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: MarketplaceTheme.primaryBlue.withOpacity(0.3),
            ),
          ),
        );
      },
    );
  }

  void _removeItem(int productId, MarketplaceProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: const Text('Are you sure you want to remove this item from your cart?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.removeFromCart(productId);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Item removed from cart'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.white,
                    onPressed: () {
                      // Add undo functionality if needed
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MarketplaceProvider>().clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cart cleared'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _applyPromoCode() async {
    final promoCode = _promoController.text.trim();

    if (promoCode.isEmpty) {
      _showSnackBar('Please enter a promo code', Colors.red);
      return;
    }

    setState(() => _isApplyingPromo = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isApplyingPromo = false);

    // Mock promo code validation
    switch (promoCode.toUpperCase()) {
      case 'UBUNTU10':
        setState(() => _promoDiscount = context.read<MarketplaceProvider>().cartTotal * 0.1);
        _showSnackBar('Promo code applied! 10% discount', Colors.green);
        break;
      case 'WELCOME20':
        setState(() => _promoDiscount = context.read<MarketplaceProvider>().cartTotal * 0.2);
        _showSnackBar('Promo code applied! 20% discount', Colors.green);
        break;
      case 'FREESHIP':
        setState(() => _promoDiscount = 50.0); // Free shipping value
        _showSnackBar('Promo code applied! Free shipping', Colors.green);
        break;
      default:
        _showSnackBar('Invalid promo code', Colors.red);
        break;
    }
  }

  void _saveCartForLater() {
    _showSnackBar('Cart saved for later', Colors.green);
  }

  void _shareCart() {
    _showSnackBar('Share functionality coming soon!', Colors.blue);
  }

  void _proceedToCheckout() {
    final provider = context.read<MarketplaceProvider>();

    // Check if all items are in stock
    final outOfStockItems = provider.cart.where((item) => item['isInStock'] != true).toList();

    if (outOfStockItems.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Items Out of Stock'),
          content: Text(
            'Some items in your cart are no longer available:\n\n'
            '${outOfStockItems.map((item) => '• ${item['title']}').join('\n')}\n\n'
            'Would you like to remove them and continue?'
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Remove out of stock items
                for (final item in outOfStockItems) {
                  provider.removeFromCart(item['id']);
                }
                Navigator.pop(context);
                Navigator.pushNamed(context, '/checkout');
              },
              child: const Text('Remove & Continue'),
            ),
          ],
        ),
      );
      return;
    }

    Navigator.pushNamed(context, '/checkout', arguments: {
      'cart': provider.cart,
      'total': provider.cartTotal,
      'promoDiscount': _promoDiscount,
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
