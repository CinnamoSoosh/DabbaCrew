import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../models/language_provider.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId;
  final String cookName;

  const OrderTrackingPage({
    Key? key,
    required this.orderId,
    required this.cookName,
  }) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                    colors: [Color(0xFFFF8C42), Color(0xFFFF7A29)],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFFF8C42).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10))
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white),
                          style: IconButton.styleFrom(
                              backgroundColor:
                                  Colors.white.withOpacity(0.2)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.trackOrder,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.5)),
                              const SizedBox(height: 2),
                              Text('${l10n.order} #${widget.orderId}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Map Placeholder
              Expanded(
                flex: 3,
                child: Container(
                  color: const Color(0xFFE3F2FD),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10))
                                ],
                              ),
                              child: const Icon(Icons.map_rounded,
                                  size: 64, color: Color(0xFF4285F4)),
                            ),
                            const SizedBox(height: 20),
                            Text(l10n.liveTracking,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A1A))),
                            const SizedBox(height: 8),
                            Text(l10n.mapsComingSoon,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5))
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle)),
                                const SizedBox(width: 10),
                                Text(l10n.arrivingIn8Mins,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Order Details
              Expanded(
                flex: 2,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadius.circular(2))),
                        ),
                        const SizedBox(height: 24),

                        // Delivery Partner Info
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color(0xFF3B82F6),
                                    Color(0xFF2563EB)
                                  ]),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Center(
                                    child: Text('V',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight:
                                                FontWeight.bold))),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text('Vikram Singh',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1A1A1A))),
                                    const SizedBox(height: 3),
                                    Text(l10n.deliveryPartner,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF757575))),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Row(children: [
                                      const Icon(Icons.phone,
                                          color: Colors.white),
                                      const SizedBox(width: 12),
                                      Text(l10n.callingPartner),
                                    ]),
                                    backgroundColor:
                                        const Color(0xFF3B82F6),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ));
                                },
                                icon: const Icon(Icons.phone_rounded),
                                style: IconButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF3B82F6),
                                    foregroundColor: Colors.white),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(l10n.orderStatus,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 16),

                        _buildTimelineItem(l10n.orderPlacedStatus,
                            'Today, 12:00 PM', true, true,
                            const Color(0xFF10B981)),
                        _buildTimelineItem(l10n.orderConfirmed,
                            'Today, 12:05 PM', true, true,
                            const Color(0xFF10B981)),
                        _buildTimelineItem(l10n.preparingFood,
                            'Today, 12:10 PM', true, true,
                            const Color(0xFF10B981)),
                        _buildTimelineItem(l10n.outForDelivery,
                            'Today, 12:30 PM', true, true,
                            const Color(0xFFFF8C42)),
                        _buildTimelineItem(l10n.delivered,
                            'Estimated: 12:40 PM', false, false,
                            Colors.grey[400]!),

                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            children: [
                              const Icon(Icons.restaurant_rounded,
                                  color: Color(0xFFFF8C42), size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(l10n.orderedFrom,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF757575))),
                                    const SizedBox(height: 2),
                                    Text(widget.cookName,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1A1A1A))),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String time, bool isCompleted,
      bool isActive, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? color : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: isCompleted
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 16)
                  : null,
            ),
            if (title != AppLocalizations.of(context)!.delivered)
              Container(
                  width: 2,
                  height: 40,
                  color: isActive ? color : Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: isActive
                            ? const Color(0xFF1A1A1A)
                            : Colors.grey[600])),
                const SizedBox(height: 3),
                Text(time,
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
        ),
      ],
    );
  }
}