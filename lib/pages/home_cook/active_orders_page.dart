import 'package:flutter/material.dart';
import 'dart:async';

class ActiveOrdersPage extends StatefulWidget {
  const ActiveOrdersPage({Key? key}) : super(key: key);

  @override
  State<ActiveOrdersPage> createState() => _ActiveOrdersPageState();
}

class _ActiveOrdersPageState extends State<ActiveOrdersPage> with TickerProviderStateMixin {
  List<OrderItem> orders = [];
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initializeOrders();
    _startAutoRefresh();
  }

  void _initializeOrders() {
    orders = [
      OrderItem(
        id: 'ORD001',
        customerName: 'Amit Kumar',
        customerPhone: '+91 98765 43210',
        items: [
          OrderMenuItem(name: 'Dal Chawal', quantity: 1, price: 80),
          OrderMenuItem(name: 'Thepla', quantity: 4, price: 60),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 5)),
        status: OrderStatus.pending,
        deliveryAddress: 'Flat 204, Sunrise Apartments, Andheri West',
        specialInstructions: 'Less spicy please',
      ),
      OrderItem(
        id: 'ORD002',
        customerName: 'Priya Sharma',
        customerPhone: '+91 87654 32109',
        items: [
          OrderMenuItem(name: 'Khichdi Bowl', quantity: 1, price: 85),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
        status: OrderStatus.preparing,
        deliveryAddress: 'Shop 12, Market Road, Bandra',
      ),
      OrderItem(
        id: 'ORD003',
        customerName: 'Rohit Patel',
        customerPhone: '+91 76543 21098',
        items: [
          OrderMenuItem(name: 'Dal Dhokli', quantity: 1, price: 70),
          OrderMenuItem(name: 'Thepla', quantity: 4, price: 60),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 25)),
        status: OrderStatus.ready,
        deliveryAddress: 'B-301, Green Valley, Powai',
      ),
    ];
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _updateOrderStatus(String orderId, OrderStatus newStatus) {
    setState(() {
      final index = orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        orders[index].status = newStatus;
        orders[index].statusUpdateTime = DateTime.now();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Order ${newStatus.name} successfully'),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showOrderDetails(OrderItem order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailsSheet(
        order: order,
        onStatusUpdate: (status) => _updateOrderStatus(order.id, status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingOrders = orders.where((o) => o.status == OrderStatus.pending).toList();
    final preparingOrders = orders.where((o) => o.status == OrderStatus.preparing).toList();
    final readyOrders = orders.where((o) => o.status == OrderStatus.ready).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Orders',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Manage your orders',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                '${orders.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Orders Content
              Expanded(
                child: orders.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {});
                        },
                        color: const Color(0xFF4CAF50),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          children: [
                            if (pendingOrders.isNotEmpty) ...[
                              _buildSectionHeader('New Orders', pendingOrders.length, const Color(0xFFFF8C42)),
                              const SizedBox(height: 12),
                              ...pendingOrders.map((order) => _buildOrderCard(order)),
                              const SizedBox(height: 24),
                            ],
                            if (preparingOrders.isNotEmpty) ...[
                              _buildSectionHeader('Preparing', preparingOrders.length, const Color(0xFFFFA726)),
                              const SizedBox(height: 12),
                              ...preparingOrders.map((order) => _buildOrderCard(order)),
                              const SizedBox(height: 24),
                            ],
                            if (readyOrders.isNotEmpty) ...[
                              _buildSectionHeader('Ready', readyOrders.length, const Color(0xFF4CAF50)),
                              const SizedBox(height: 12),
                              ...readyOrders.map((order) => _buildOrderCard(order)),
                            ],
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(OrderItem order) {
    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    switch (order.status) {
      case OrderStatus.pending:
        statusColor = const Color(0xFFFF8C42);
        statusIcon = Icons.access_time_rounded;
        statusLabel = 'New';
        break;
      case OrderStatus.preparing:
        statusColor = const Color(0xFFFFA726);
        statusIcon = Icons.restaurant_rounded;
        statusLabel = 'Preparing';
        break;
      case OrderStatus.ready:
        statusColor = const Color(0xFF4CAF50);
        statusIcon = Icons.check_circle_rounded;
        statusLabel = 'Ready';
        break;
      case OrderStatus.completed:
        statusColor = const Color(0xFF42A5F5);
        statusIcon = Icons.done_all_rounded;
        statusLabel = 'Completed';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(color: statusColor.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showOrderDetails(order),
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                            order.customerName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.receipt_rounded, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                order.id,
                                style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                _formatTime(order.orderTime),
                                style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 16, color: statusColor),
                          const SizedBox(width: 6),
                          Text(
                            statusLabel,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: order.items.asMap().entries.map((entry) {
                      final item = entry.value;
                      final isLast = entry.key == order.items.length - 1;
                      return Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${item.quantity}x',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                              ),
                            ),
                            Text(
                              '₹${item.price}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${order.totalAmount}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildActionButton(order, statusColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(OrderItem order, Color color) {
    String buttonText;
    OrderStatus nextStatus;

    switch (order.status) {
      case OrderStatus.pending:
        buttonText = 'Accept';
        nextStatus = OrderStatus.preparing;
        break;
      case OrderStatus.preparing:
        buttonText = 'Mark Ready';
        nextStatus = OrderStatus.ready;
        break;
      case OrderStatus.ready:
        buttonText = 'Complete';
        nextStatus = OrderStatus.completed;
        break;
      default:
        return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () => _updateOrderStatus(order.id, nextStatus),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(buttonText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_rounded, size: 18),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Color(0xFFF5F5F5), shape: BoxShape.circle),
            child: Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          const Text(
            'No active orders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders will appear here when customers place them',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    return '${difference.inHours}h ago';
  }
}

class OrderItem {
  final String id;
  final String customerName;
  final String customerPhone;
  final List<OrderMenuItem> items;
  final DateTime orderTime;
  OrderStatus status;
  DateTime? statusUpdateTime;
  final String deliveryAddress;
  final String? specialInstructions;

  OrderItem({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    required this.orderTime,
    required this.status,
    this.statusUpdateTime,
    required this.deliveryAddress,
    this.specialInstructions,
  });

  int get totalAmount => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

class OrderMenuItem {
  final String name;
  final int quantity;
  final int price;

  OrderMenuItem({required this.name, required this.quantity, required this.price});
}

enum OrderStatus { pending, preparing, ready, completed }

class OrderDetailsSheet extends StatelessWidget {
  final OrderItem order;
  final Function(OrderStatus) onStatusUpdate;

  const OrderDetailsSheet({Key? key, required this.order, required this.onStatusUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Details',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                      ),
                      const SizedBox(height: 4),
                      Text(order.id, style: TextStyle(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(backgroundColor: const Color(0xFFF5F5F5)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Customer Information',
                    Column(
                      children: [
                        _buildInfoRow(Icons.person_rounded, 'Name', order.customerName),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.phone_rounded, 'Phone', order.customerPhone),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.location_on_rounded, 'Address', order.deliveryAddress),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Order Items',
                    Column(
                      children: order.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '${item.quantity}x',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                                    const SizedBox(height: 2),
                                    Text('₹${item.price} each', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                              Text(
                                '₹${item.price * item.quantity}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (order.specialInstructions != null) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      'Special Instructions',
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, color: Color(0xFFFF8C42), size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                order.specialInstructions!,
                                style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A), height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF45A049)]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        Text(
                          '₹${order.totalAmount}',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: const Color(0xFF4CAF50)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
            ],
          ),
        ),
      ],
    );
  }
}