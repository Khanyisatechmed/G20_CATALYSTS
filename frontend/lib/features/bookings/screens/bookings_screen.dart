import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/utils/responsive_helper.dart';
import 'package:frontend/shared/widgets/custom_bottom_nav.dart';
import '../widgets/booking_card.dart';
import '../../accommodation/screens/accommodation_booking_screen.dart';
import '../../marketplace/screens/product_detail_screen.dart';

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
      context.read<BookingsProvider>().loadBookings();
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
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
      bottomNavigationBar: ResponsiveHelper.isMobile(context)
          ? const CustomBottomNavigation(currentIndex: 2)
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
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
              right: BorderSide(color: Colors.grey.withOpacity(0.2)),
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
    return Consumer<BookingsProvider>(
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
                    provider.totalBookings.toString(),
                    Icons.calendar_today,
                    Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    'Upcoming',
                    provider.upcomingBookings.length.toString(),
                    Icons.schedule,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    'Completed',
                    provider.completedBookings.length.toString(),
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
                        // Export bookings
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
            color: Colors.grey.withOpacity(0.1),
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
              color: color.withOpacity(0.1),
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
    return Consumer<BookingsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
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
                title: booking['title'] ?? 'Local Cooking Workshop',
                location: booking['location'] ?? 'Qwaqwa',
                date: DateTime.parse(booking['date'] ?? '2024-11-15'),
                time: booking['time'] ?? '12:00 PM',
                participants: booking['participants'] ?? 1,
                price: booking['price']?.toDouble() ?? 200.0,
                currency: booking['currency'] ?? 'ZAR',
                status: booking['status'] ?? 'confirmed',
                imageUrl: booking['imageUrl'] ?? '',
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

  List<Map<String, dynamic>> _getFilteredBookings(BookingsProvider provider, String filter) {
    switch (filter) {
      case 'upcoming':
        return provider.upcomingBookings;
      case 'completed':
        return provider.completedBookings;
      case 'cancelled':
        return provider.cancelledBookings;
      default:
        return provider.allBookings;
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
          'Are you sure you want to cancel your booking for "${booking['title']}"? This action cannot be undone.',
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
      await context.read<BookingsProvider>().cancelBooking(booking['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking for "${booking['title']}" has been cancelled'),
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
}
