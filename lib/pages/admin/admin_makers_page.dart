import 'package:flutter/material.dart';

class AdminMakersPage extends StatefulWidget {
  const AdminMakersPage({Key? key}) : super(key: key);

  @override
  State<AdminMakersPage> createState() => _AdminMakersPageState();
}

class _AdminMakersPageState extends State<AdminMakersPage> {
  int selectedIndex = 2;
  String searchQuery = '';
  
  final List<MakerData> makers = [
    MakerData(
      id: 'COOK001',
      name: 'Meera Patel',
      email: 'meera.patel@email.com',
      phone: '+91 98765 43210',
      location: 'Andheri West, Mumbai',
      joinedDate: DateTime(2024, 10, 15),
      totalOrders: 156,
      rating: 4.8,
      menuItems: 12,
      totalEarnings: 23400,
      isVerified: true,
      status: MakerStatus.active,
    ),
    MakerData(
      id: 'COOK002',
      name: 'Lakshmi Iyer',
      email: 'lakshmi.iyer@email.com',
      phone: '+91 87654 32109',
      location: 'Lokhandwala, Mumbai',
      joinedDate: DateTime(2024, 9, 20),
      totalOrders: 234,
      rating: 4.9,
      menuItems: 15,
      totalEarnings: 34560,
      isVerified: true,
      status: MakerStatus.active,
    ),
    MakerData(
      id: 'COOK003',
      name: 'Priya Sharma',
      email: 'priya.sharma@email.com',
      phone: '+91 76543 21098',
      location: 'Bandra East, Mumbai',
      joinedDate: DateTime(2024, 11, 5),
      totalOrders: 89,
      rating: 4.7,
      menuItems: 8,
      totalEarnings: 12340,
      isVerified: true,
      status: MakerStatus.active,
    ),
    MakerData(
      id: 'COOK004',
      name: 'Anjali Desai',
      email: 'anjali.desai@email.com',
      phone: '+91 65432 10987',
      location: 'Powai, Mumbai',
      joinedDate: DateTime(2024, 12, 1),
      totalOrders: 23,
      rating: 4.5,
      menuItems: 6,
      totalEarnings: 3450,
      isVerified: false,
      status: MakerStatus.pending,
    ),
  ];

  List<MakerData> get filteredMakers {
    if (searchQuery.isEmpty) return makers;
    return makers.where((maker) {
      return maker.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
             maker.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
             maker.location.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                    colors: [
                      Color(0xFF10B981),
                      Color(0xFF059669),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pushReplacementNamed(context, '/admin-dashboard'),
                              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Home Cooks',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Manage all makers',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${makers.length} total',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: TextField(
                          onChanged: (value) => setState(() => searchQuery = value),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search cooks...',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.7)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Makers List
              Expanded(
                child: filteredMakers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No cooks found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        itemCount: filteredMakers.length,
                        itemBuilder: (context, index) {
                          return _buildMakerCard(filteredMakers[index]);
                        },
                      ),
              ),

              // Bottom Navigation
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMakerCard(MakerData maker) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: maker.isVerified 
              ? const Color(0xFF10B981).withOpacity(0.3) 
              : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showMakerDetails(maker),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF059669)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              maker.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (maker.isVerified)
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            maker.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  maker.location,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(maker.status).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getStatusText(maker.status),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(maker.status),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 14),
                
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMakerStat(
                          Icons.shopping_bag_outlined,
                          maker.totalOrders.toString(),
                          'Orders',
                        ),
                      ),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      Expanded(
                        child: _buildMakerStat(
                          Icons.star_rounded,
                          maker.rating.toString(),
                          'Rating',
                        ),
                      ),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      Expanded(
                        child: _buildMakerStat(
                          Icons.currency_rupee_rounded,
                          '₹${(maker.totalEarnings / 1000).toStringAsFixed(1)}k',
                          'Earned',
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Icon(Icons.restaurant_menu_rounded, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      '${maker.menuItems} menu items',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Joined ${_formatDate(maker.joinedDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMakerStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF10B981)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(MakerStatus status) {
    switch (status) {
      case MakerStatus.active:
        return const Color(0xFF10B981);
      case MakerStatus.pending:
        return const Color(0xFFF59E0B);
      case MakerStatus.inactive:
        return Colors.grey[600]!;
    }
  }

  String _getStatusText(MakerStatus status) {
    switch (status) {
      case MakerStatus.active:
        return 'Active';
      case MakerStatus.pending:
        return 'Pending';
      case MakerStatus.inactive:
        return 'Inactive';
    }
  }

  void _showMakerDetails(MakerData maker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: const BoxConstraints(maxWidth: 480),
        height: MediaQuery.of(context).size.height * 0.8,
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
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF059669)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(
                            maker.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (maker.isVerified)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maker.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          maker.id,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F5F5),
                    ),
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
                    _buildDetailSection('Contact Information', [
                      _buildDetailRow(Icons.email_rounded, 'Email', maker.email),
                      _buildDetailRow(Icons.phone_rounded, 'Phone', maker.phone),
                      _buildDetailRow(Icons.location_on_rounded, 'Location', maker.location),
                    ]),
                    
                    const SizedBox(height: 20),
                    
                    _buildDetailSection('Business Statistics', [
                      _buildDetailRow(Icons.shopping_bag_rounded, 'Total Orders', maker.totalOrders.toString()),
                      _buildDetailRow(Icons.star_rounded, 'Rating', '${maker.rating} ⭐'),
                      _buildDetailRow(Icons.restaurant_menu_rounded, 'Menu Items', maker.menuItems.toString()),
                      _buildDetailRow(Icons.currency_rupee_rounded, 'Total Earnings', '₹${maker.totalEarnings}'),
                    ]),
                    
                    const SizedBox(height: 20),
                    
                    _buildDetailSection('Account Information', [
                      _buildDetailRow(Icons.calendar_today_rounded, 'Joined Date', _formatDate(maker.joinedDate)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Verification Status',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF757575),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: maker.isVerified 
                                  ? const Color(0xFFE8F5E9) 
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  maker.isVerified ? Icons.verified_rounded : Icons.pending_rounded,
                                  size: 16,
                                  color: maker.isVerified 
                                      ? const Color(0xFF10B981) 
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  maker.isVerified ? 'Verified' : 'Not Verified',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: maker.isVerified 
                                        ? const Color(0xFF10B981) 
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF10B981)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF757575),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 0),
              _buildNavItem(Icons.people_rounded, 'Users', 1),
              _buildNavItem(Icons.restaurant_rounded, 'Cooks', 2),
              _buildNavItem(Icons.receipt_long_rounded, 'Orders', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        if (index == selectedIndex) return;
        
        setState(() => selectedIndex = index);
        
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/admin-dashboard');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/admin-users');
            break;
          case 2:
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/admin-orders');
            break;
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF6366F1).withOpacity(0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? const Color(0xFF6366F1) 
                  : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected 
                    ? const Color(0xFF6366F1) 
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Maker Data Model
class MakerData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final DateTime joinedDate;
  final int totalOrders;
  final double rating;
  final int menuItems;
  final double totalEarnings;
  final bool isVerified;
  final MakerStatus status;

  MakerData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.joinedDate,
    required this.totalOrders,
    required this.rating,
    required this.menuItems,
    required this.totalEarnings,
    required this.isVerified,
    required this.status,
  });
}

enum MakerStatus {
  active,
  pending,
  inactive,
}