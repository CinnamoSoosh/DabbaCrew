import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkout_page.dart';
import '../../main.dart';
import '../../models/language_provider.dart';

class KitchenDetails extends StatefulWidget {
  final String name;
  const KitchenDetails({super.key, required this.name});

  @override
  State<KitchenDetails> createState() => _KitchenDetailsState();
}

class _KitchenDetailsState extends State<KitchenDetails> {
  final Map<String, int> _itemCounts = {
    "Dal Chawal Combo": 0,
    "Rajma Chawal": 0,
    "Thepla (4 pcs)": 0,
    "Paneer Masala Box": 0,
    "Veg Pulao": 0,
  };

  final Map<String, double> _itemPrices = {
    "Dal Chawal Combo": 90.0,
    "Rajma Chawal": 90.0,
    "Thepla (4 pcs)": 60.0,
    "Paneer Masala Box": 120.0,
    "Veg Pulao": 100.0,
  };

  final Map<String, String> _itemDescriptions = {
    "Dal Chawal Combo": "Yellow dal, steamed rice, pickle, papad",
    "Rajma Chawal": "Kidney bean curry with steamed rice",
    "Thepla (4 pcs)": "Gujarati flatbread with pickle",
    "Paneer Masala Box": "Paneer curry with rice and roti",
    "Veg Pulao": "Mixed vegetable pulao with raita",
  };

  double _calculateTotal() {
    double total = 0;
    _itemCounts.forEach(
        (title, count) => total += count * (_itemPrices[title] ?? 0));
    return total;
  }

  int _totalItemCount() =>
      _itemCounts.values.fold(0, (sum, count) => sum + count);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    double currentTotal = _calculateTotal();
    int totalItems = _totalItemCount();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: totalItems > 0
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$totalItems ${totalItems == 1 ? l10n.item : l10n.items}',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹$currentTotal',
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                  letterSpacing: -0.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => CheckoutPage(
                                  totalAmount: currentTotal,
                                  totalItems: totalItems,
                                  items: _itemCounts.entries
                                      .where((e) => e.value > 0)
                                      .map((e) => {
                                            'name': e.key,
                                            'quantity': e.value,
                                            'price': _itemPrices[e.key]!,
                                          })
                                      .toList(),
                                  cookName: widget.name,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8C42),
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(l10n.checkout,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded,
                                  size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              _buildHeroImage(context),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildKitchenHeader(),
                    _buildSubscriptionBanner(l10n),
                    _buildMenuSection(l10n),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Container(
          height: 240,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 22),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 16,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded,
                    color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(l10n.verifiedKitchen,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKitchenHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5)),
          const SizedBox(height: 6),
          Text("Gujarati • Home Cook",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  children: [
                    Icon(Icons.star_rounded,
                        color: Color(0xFFFFA726), size: 18),
                    SizedBox(width: 6),
                    Text("4.8",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(" (234)",
                        style: TextStyle(
                            color: Color(0xFF757575), fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  children: [
                    Icon(Icons.health_and_safety_outlined,
                        color: Color(0xFF10B981), size: 18),
                    SizedBox(width: 6),
                    Text("Hygiene 5/5",
                        style: TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionBanner(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFFF8C42), Color(0xFFFF7A29)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFFF8C42).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.calendar_today_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.subscribeAndSave,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: -0.3)),
                const SizedBox(height: 4),
                Text(l10n.getDailyMealPlans,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_rounded,
              color: Colors.white, size: 24),
        ],
      ),
    );
  }

  Widget _buildMenuSection(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.todaysMenu,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.3)),
          const SizedBox(height: 4),
          Text('${_itemPrices.length} ${l10n.itemsAvailable}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 20),
          ..._itemPrices.keys.map((item) => _buildMenuItem(
              item,
              _itemDescriptions[item]!,
              _itemPrices[item]!.toInt().toString(),
              l10n)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      String title, String desc, String price, AppLocalizations l10n) {
    int count = _itemCounts[title] ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: count > 0
                ? const Color(0xFFFF8C42)
                : Colors.grey[200]!,
            width: 2),
        boxShadow: [
          BoxShadow(
              color: count > 0
                  ? const Color(0xFFFF8C42).withOpacity(0.1)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF10B981), width: 2),
                          ),
                          child: Center(
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Color(0xFF1A1A1A))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(desc,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text("₹$price",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFFFF8C42),
                      letterSpacing: -0.5)),
            ],
          ),
          const SizedBox(height: 16),
          count == 0
              ? SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () =>
                        setState(() => _itemCounts[title] = 1),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF8C42),
                      side: const BorderSide(
                          color: Color(0xFFFF8C42), width: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_rounded, size: 20),
                        const SizedBox(width: 6),
                        Text(l10n.add,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFF8C42),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_rounded,
                            color: Colors.white),
                        onPressed: () => setState(() {
                          if (_itemCounts[title]! > 0) {
                            _itemCounts[title] =
                                _itemCounts[title]! - 1;
                          }
                        }),
                      ),
                      Text("$count",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.add_rounded,
                            color: Colors.white),
                        onPressed: () => setState(
                            () => _itemCounts[title] = count + 1),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}