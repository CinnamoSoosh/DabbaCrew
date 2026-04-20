import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/validators.dart';

class MenuManagementPage extends StatefulWidget {
  const MenuManagementPage({Key? key}) : super(key: key);

  @override
  State<MenuManagementPage> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends State<MenuManagementPage> with SingleTickerProviderStateMixin {
  int selectedIndex = 1;
  String selectedFilter = 'All';
  late AnimationController _animationController;

  List<MenuItem> menuItems = [
    MenuItem(id: '1', name: 'Dal Chawal Combo', category: 'Combo', description: 'Yellow dal, steamed rice, pickle', price: 80, isAvailable: true, prepTime: 25, isVeg: true),
    MenuItem(id: '2', name: 'Rajma Chawal', category: 'Combo', description: 'Kidney bean curry with rice', price: 90, isAvailable: false, prepTime: 30, isVeg: true),
    MenuItem(id: '3', name: 'Thepla (4 pcs)', category: 'Bread', description: 'Gujarati flatbread', price: 60, isAvailable: true, prepTime: 15, isVeg: true),
    MenuItem(id: '4', name: 'Kadhi Pakoda', category: 'Curry', description: 'Yogurt curry with fritters', price: 70, isAvailable: false, prepTime: 35, isVeg: true),
    MenuItem(id: '5', name: 'Khichdi Bowl', category: 'Rice', description: 'Comfort rice and lentil mix', price: 85, isAvailable: true, prepTime: 20, isVeg: true),
  ];

  List<String> get categories => ['All', ...menuItems.map((e) => e.category).toSet().toList()];
  List<MenuItem> get filteredItems => selectedFilter == 'All' ? menuItems : menuItems.where((item) => item.category == selectedFilter).toList();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAvailability(String itemId) {
    setState(() {
      final index = menuItems.indexWhere((item) => item.id == itemId);
      if (index != -1) menuItems[index].isAvailable = !menuItems[index].isAvailable;
    });
  }

  void _showAddEditDialog({MenuItem? item}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditMenuItemSheet(
        item: item,
        onSave: (newItem) {
          setState(() {
            if (item == null) {
              menuItems.add(newItem);
            } else {
              final index = menuItems.indexWhere((i) => i.id == item.id);
              if (index != -1) menuItems[index] = newItem;
            }
          });
        },
      ),
    );
  }

  void _deleteItem(String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Item?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this item from your menu?', style: TextStyle(fontSize: 15)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => menuItems.removeWhere((item) => item.id == itemId));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 12), Text('Item deleted successfully')]),
                  backgroundColor: const Color(0xFFEF5350),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF5350), foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Menu Management',
                                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${menuItems.length} items',
                                    style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  onTap: () => _showAddEditDialog(),
                                  borderRadius: BorderRadius.circular(16),
                                  child: const Padding(
                                    padding: EdgeInsets.all(14),
                                    child: Icon(Icons.add_rounded, color: Colors.white, size: 26),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected = selectedFilter == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (selected) => setState(() => selectedFilter = category),
                                backgroundColor: Colors.white.withOpacity(0.2),
                                selectedColor: Colors.white.withOpacity(0.3),
                                checkmarkColor: Colors.white,
                                labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                                    width: 1.5,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: filteredItems.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) => _buildMenuItem(filteredItems[index]),
                      ),
              ),

              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: item.isAvailable ? const Color(0xFF4CAF50).withOpacity(0.2) : Colors.grey[300]!, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: item.isVeg ? const Color(0xFF4CAF50).withOpacity(0.1) : const Color(0xFFEF5350).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(Icons.circle, size: 12, color: item.isVeg ? const Color(0xFF4CAF50) : const Color(0xFFEF5350)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)),
                    child: Text(item.category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1976D2))),
                  ),
                  const SizedBox(height: 10),
                  Text(item.description, style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 6),
                      Text('${item.prepTime} mins', style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.isAvailable ? const Color(0xFFE8F5E9) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.isAvailable ? Icons.check_circle_rounded : Icons.cancel_rounded,
                              size: 14,
                              color: item.isAvailable ? const Color(0xFF4CAF50) : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.isAvailable ? 'Available' : 'Unavailable',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: item.isAvailable ? const Color(0xFF4CAF50) : Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Text('₹${item.price}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50), letterSpacing: -0.5)),
                const SizedBox(height: 8),
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.more_vert_rounded, size: 20),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit': _showAddEditDialog(item: item); break;
                      case 'toggle': _toggleAvailability(item.id); break;
                      case 'delete': _deleteItem(item.id); break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 20), SizedBox(width: 12), Text('Edit')])),
                    PopupMenuItem(
                      value: 'toggle',
                      child: Row(children: [
                        Icon(item.isAvailable ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                        const SizedBox(width: 12),
                        Text(item.isAvailable ? 'Mark Unavailable' : 'Mark Available'),
                      ]),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        Icon(Icons.delete_outline, size: 20, color: Color(0xFFEF5350)),
                        SizedBox(width: 12),
                        Text('Delete', style: TextStyle(color: Color(0xFFEF5350))),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
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
            child: Icon(Icons.restaurant_menu_rounded, size: 64, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          const Text('No menu items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 8),
          Text('Add items to your menu to start\nreceiving orders', style: TextStyle(fontSize: 15, color: Colors.grey[600]), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddEditDialog(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add First Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.restaurant_menu_rounded, 'Menu', 1),
              _buildNavItem(Icons.verified_rounded, 'Verify', 2),
              _buildNavItem(Icons.person_rounded, 'Profile', 3),
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
        setState(() => selectedIndex = index);
        switch (index) {
          case 0: Navigator.pushReplacementNamed(context, '/dashboard'); break;
          case 1: break;
          case 2: Navigator.pushReplacementNamed(context, '/verify'); break;
          case 3: Navigator.pushReplacementNamed(context, '/profile'); break;
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[400], size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final String id;
  String name;
  String category;
  String description;
  int price;
  bool isAvailable;
  int prepTime;
  bool isVeg;

  MenuItem({required this.id, required this.name, required this.category, required this.description, required this.price, required this.isAvailable, required this.prepTime, this.isVeg = true});
}

class AddEditMenuItemSheet extends StatefulWidget {
  final MenuItem? item;
  final Function(MenuItem) onSave;

  const AddEditMenuItemSheet({Key? key, this.item, required this.onSave}) : super(key: key);

  @override
  State<AddEditMenuItemSheet> createState() => _AddEditMenuItemSheetState();
}

class _AddEditMenuItemSheetState extends State<AddEditMenuItemSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _prepTimeController;
  String selectedCategory = 'Combo';
  bool isVeg = true;
  bool isLoading = false;

  final List<String> categories = ['Combo', 'Bread', 'Curry', 'Rice', 'Snacks', 'Desserts'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
    _priceController = TextEditingController(text: widget.item?.price.toString() ?? '');
    _prepTimeController = TextEditingController(text: widget.item?.prepTime.toString() ?? '');
    if (widget.item != null) {
      selectedCategory = widget.item!.category;
      isVeg = widget.item!.isVeg;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _prepTimeController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    final newItem = MenuItem(
      id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      category: selectedCategory,
      description: _descriptionController.text.trim(),
      price: int.parse(_priceController.text),
      isAvailable: widget.item?.isAvailable ?? true,
      prepTime: int.parse(_prepTimeController.text),
      isVeg: isVeg,
    );
    widget.onSave(newItem);
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 12),
          Text(widget.item == null ? 'Item added successfully' : 'Item updated successfully'),
        ]),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
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
                  child: Text(
                    widget.item == null ? 'Add New Item' : 'Edit Item',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Item Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      validator: Validators.validateMenuItemName,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(hintText: 'e.g., Dal Chawal Combo', prefixIcon: Icon(Icons.restaurant_rounded)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Category', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: selectedCategory,
                                decoration: const InputDecoration(prefixIcon: Icon(Icons.category_rounded)),
                                items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                                onChanged: (value) => setState(() => selectedCategory = value!),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Type', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => setState(() => isVeg = true),
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: isVeg ? Colors.white : Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: isVeg ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)] : null,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.circle, size: 12, color: isVeg ? const Color(0xFF4CAF50) : Colors.grey[400]),
                                              const SizedBox(width: 6),
                                              Text('Veg', style: TextStyle(fontSize: 14, fontWeight: isVeg ? FontWeight.bold : FontWeight.w500, color: isVeg ? const Color(0xFF4CAF50) : Colors.grey[600])),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => setState(() => isVeg = false),
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: !isVeg ? Colors.white : Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: !isVeg ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)] : null,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.circle, size: 12, color: !isVeg ? const Color(0xFFEF5350) : Colors.grey[400]),
                                              const SizedBox(width: 6),
                                              Text('Non-Veg', style: TextStyle(fontSize: 14, fontWeight: !isVeg ? FontWeight.bold : FontWeight.w500, color: !isVeg ? const Color(0xFFEF5350) : Colors.grey[600])),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      validator: Validators.validateDescription,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Brief description of the item',
                        prefixIcon: Padding(padding: EdgeInsets.only(bottom: 40), child: Icon(Icons.description_rounded)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Price (₹)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _priceController,
                                validator: Validators.validatePrice,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(hintText: '0', prefixIcon: Icon(Icons.currency_rupee_rounded)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Prep Time (mins)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _prepTimeController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Required';
                                  final time = int.tryParse(value);
                                  if (time == null || time <= 0) return 'Invalid';
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(hintText: '0', prefixIcon: Icon(Icons.access_time_rounded)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(widget.item == null ? Icons.add_rounded : Icons.check_rounded),
                          const SizedBox(width: 8),
                          Text(widget.item == null ? 'Add Item' : 'Save Changes', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}