// features/bookings/screens/bookings_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/features/bookings/providers/bookings_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../widgets/booking_card.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ResponsiveLayoutBuilder(
        mobile: (context, constraints) => _buildMobileLayout(),
        tablet: (context, constraints) => _buildTabletLayout(),
        desktop: (context, constraints) => _buildDesktopLayout(),
      ),
      bottomNavigationBar: ResponsiveHelper.isMobile(context)
          ? const CustomBottomNav(currentRoute: '/bookings')
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      title: Text(
        'My Bookings',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: ResponsiveHelper.isMobile(context) ? 24 : 28,
        ),
      ),
      actions: ResponsiveHelper.isDesktop(context) ? [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.calendar_today_outlined, color: Colors.black87),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person_outline, color: Colors.black87),
        ),
        const SizedBox(width: 16),
      ] : null,
      bottom: ResponsiveHelper.isMobile(context) ? _buildTabBar() : null,
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.grey[600],
      indicatorColor: Theme.of(context).primaryColor,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      isScrollable: ResponsiveHelper.isMobile(context),
      tabs: const [
        Tab(text: 'All'),
        Tab(text: 'Upcoming'),
        Tab(text: 'Completed'),
        Tab(text: 'Cancelled'),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildBookingsList('all'),
        _buildBookingsList('upcoming'),
        _buildBookingsList('completed'),
        _buildBookingsList('cancelled'),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Expanded(child: _buildTabBar()),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBookingsList('all'),
              _buildBookingsList('upcoming'),
              _buildBookingsList('completed'),
              _buildBookingsList('cancelled'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left sidebar with filters
        Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              right: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
          ),
          child: _buildSidebar(),
        ),
        // Main content area
        Expanded(
          child: Column(
            children: [
              // Desktop tab bar
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey[600],
                        indicatorColor: Theme.of(context).primaryColor,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                        tabs: const [
                          Tab(text: 'All Bookings'),
                          Tab(text: 'Upcoming'),
                          Tab(text: 'Completed'),
                          Tab(text: 'Cancelled'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBookingsList('all'),
                    _buildBookingsList('upcoming'),
                    _buildBookingsList('completed'),
                    _buildBookingsList('cancelled'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Booking Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildSummaryCard(
                    'Total Bookings',
                    provider.bookings.length.toString(),
                    Icons.calendar_today,
                    Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    'Upcoming',
                    provider.getUpcomingBookings().length.toString(),
                    Icons.schedule,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    'Completed',
                    provider.getPastBookings().length.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/explore');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Book New Experience'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Export bookings functionality
                        _exportBookings();
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Export History'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(String filter) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading bookings',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.error!,
                  style: TextStyle(color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchBookings(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        List<Map<String, dynamic>> bookings = _getFilteredBookings(provider, filter);

        if (bookings.isEmpty) {
          return _buildEmptyState(filter);
        }

        return ListView.builder(
          padding: ResponsiveHelper.getResponsivePadding(context),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: BookingCard(
                title: booking['accommodation_name'] as String? ??
                       booking['experience_name'] as String? ??
                       booking['title'] as String? ??
                       'WandersExperience',
                location: booking['location'] as String? ?? 'South Africa',
                date: booking['check_in_date'] != null
                    ? DateTime.parse(booking['check_in_date'])
                    : booking['date'] != null
                        ? DateTime.parse(booking['date'])
                        : DateTime.now(),
                time: booking['time'] as String? ?? '12:00 PM',
                participants: booking['participants'] as int? ??
                             booking['adults'] as int? ??
                             booking['guests'] as int? ?? 1,
                price: (booking['total_amount'] as num?)?.toDouble() ??
                       (booking['price'] as num?)?.toDouble() ?? 0.0,
                currency: booking['currency'] as String? ?? 'ZAR',
                status: booking['status'] as String? ?? 'confirmed',
                imageUrl: booking['imageUrl'] as String? ??
                         booking['image'] as String? ?? '',
                isPast: _isBookingInPast(booking),
                onTap: () => _navigateToBookingDetail(booking),
                onCancel: booking['status'] == 'confirmed' || booking['status'] == 'pending'
                    ? () => _showCancelDialog(booking)
                    : null,
                onModify: booking['status'] == 'confirmed'
                    ? () => _navigateToModifyBooking(booking)
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredBookings(BookingProvider provider, String filter) {
    switch (filter) {
      case 'upcoming':
        return provider.getUpcomingBookings();
      case 'completed':
        return provider.getPastBookings();
      case 'cancelled':
        return provider.getBookingsByStatus('cancelled');
      default:
        return provider.bookings;
    }
  }

  Widget _buildEmptyState(String filter) {
    String title;
    String description;
    IconData icon;

    switch (filter) {
      case 'upcoming':
        title = 'No upcoming bookings';
        description = 'Your future adventures will appear here';
        icon = Icons.schedule;
        break;
      case 'completed':
        title = 'No completed bookings';
        description = 'Your past experiences will appear here';
        icon = Icons.check_circle_outline;
        break;
      case 'cancelled':
        title = 'No cancelled bookings';
        description = 'Cancelled bookings will appear here';
        icon = Icons.cancel_outlined;
        break;
      default:
        title = 'No bookings yet';
        description = 'Start your cultural journey by booking an experience';
        icon = Icons.calendar_today_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (filter == 'all' || filter == 'upcoming')
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/explore');
              },
              icon: const Icon(Icons.explore),
              label: const Text('Explore Experiences'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToBookingDetail(Map<String, dynamic> booking) {
    Navigator.pushNamed(
      context,
      '/booking-detail',
      arguments: booking,
    );
  }

  void _navigateToModifyBooking(Map<String, dynamic> booking) {
    Navigator.pushNamed(
      context,
      '/modify-booking',
      arguments: booking,
    );
  }

  void _showCancelDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text(
          'Are you sure you want to cancel your booking for "${booking['accommodation_name'] ?? booking['experience_name'] ?? 'this booking'}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelBooking(booking);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelBooking(Map<String, dynamic> booking) async {
    try {
      await context.read<BookingProvider>().cancelBooking(booking['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking for "${booking['accommodation_name'] ?? booking['experience_name'] ?? 'experience'}" has been cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel booking: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _exportBookings() {
    // Mock export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality will be implemented'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  bool _isBookingInPast(Map<String, dynamic> booking) {
    final now = DateTime.now();

    if (booking['type'] == 'accommodation') {
      final checkOutDate = booking['check_out_date'] as String?;
      if (checkOutDate != null) {
        return DateTime.parse(checkOutDate).isBefore(now);
      }
    } else {
      final bookingDate = booking['date'] as String?;
      if (bookingDate != null) {
        return DateTime.parse(bookingDate).isBefore(now);
      }
    }

    return false;
  }
}
