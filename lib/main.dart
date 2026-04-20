import 'package:provider/provider.dart';
import 'models/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/common/registration_page.dart';
// Home Cook Pages
import 'pages/home_cook/dashboard_page.dart';
import 'pages/home_cook/active_orders_page.dart';
import 'pages/home_cook/menu_management_page.dart';
import 'pages/home_cook/kitchen_verification_page.dart';
import 'pages/home_cook/profile_page.dart';

// Delivery Partner Pages
import 'pages/delivery_partner/delivery_dashboard_page.dart';
import 'pages/delivery_partner/delivery_navigation_page.dart';
import 'pages/delivery_partner/delivery_profile_page.dart';

// Admin Pages
import 'pages/admin/admin_dashboard_page.dart';
import 'pages/admin/admin_users_page.dart';
import 'pages/admin/admin_makers_page.dart';
import 'pages/admin/admin_orders_page.dart';

// Customer Pages
import 'pages/customer/customer_dashboard.dart';
import 'pages/customer/kitchen_details.dart';
import 'pages/customer/checkout_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const DabbaCrewApp(),
    ),
  );
}

class DabbaCrewApp extends StatelessWidget {
  const DabbaCrewApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Dabba Crew',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEF5350), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const UnifiedLoginPage(),
        '/customer-dashboard': (context) =>
            const CustomerDashboard(phoneNumber: ''),
        '/dashboard': (context) => const DashboardPage(),
        '/orders': (context) => const ActiveOrdersPage(),
        '/menu': (context) => const MenuManagementPage(),
        '/verify': (context) => const KitchenVerificationPage(),
        '/profile': (context) => const ProfilePage(),
        '/delivery-dashboard': (context) => const DeliveryDashboardPage(),
        '/delivery-navigation': (context) => const DeliveryNavigationPage(),
        '/delivery-profile': (context) => const DeliveryProfilePage(),
        '/admin-dashboard': (context) => const AdminDashboardPage(),
        '/admin-users': (context) => const AdminUsersPage(),
        '/admin-makers': (context) => const AdminMakersPage(),
        '/admin-orders': (context) => const AdminOrdersPage(),
      },
    );
  }
}

// ── DualText widget ──────────────────────────────────────────────────────────
// Shows the translated text on top and English below (only when language != en)
class DualText extends StatelessWidget {
  final String primaryText;
  final String englishText;
  final TextStyle? primaryStyle;
  final TextAlign textAlign;

  const DualText({
    Key? key,
    required this.primaryText,
    required this.englishText,
    this.primaryStyle,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context).languageCode;
    final showEnglish = lang != 'en' && primaryText != englishText;

    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(primaryText, style: primaryStyle, textAlign: textAlign),
        if (showEnglish)
          Text(
            englishText,
            textAlign: textAlign,
            style: primaryStyle != null
                ? primaryStyle!.copyWith(
                    fontSize: (primaryStyle!.fontSize ?? 14) - 3,
                    color: (primaryStyle!.color ?? Colors.black)
                        .withOpacity(0.55),
                    fontWeight: FontWeight.w400,
                  )
                : TextStyle(
                    fontSize: 11,
                    color: Colors.black.withOpacity(0.45),
                  ),
          ),
      ],
    );
  }
}

// UNIFIED LOGIN PAGE
class UnifiedLoginPage extends StatefulWidget {
  const UnifiedLoginPage({super.key});

  @override
  State<UnifiedLoginPage> createState() => _UnifiedLoginPageState();
}

class _UnifiedLoginPageState extends State<UnifiedLoginPage> {
  String selectedRole = 'Customer';
  int _secretTapCount = 0;

  final List<String> _adminEmails = [
    '2025.sushrut.phansalkar@ves.ac.in',
    '2025.anushka.tatar@ves.ac.in',
    '2025.krutika.wagh@ves.ac.in',
  ];
  final String _adminPassword = 'thedabbacrew';

  void _handleContinue() {
    Color themeColor;
    String nextRoute;

    switch (selectedRole) {
      case 'Customer':
        themeColor = Colors.orange;
        nextRoute = '/customer-dashboard';
        break;
      case 'Home Cook':
        themeColor = const Color(0xFF4CAF50);
        nextRoute = '/dashboard';
        break;
      case 'Delivery Partner':
        themeColor = const Color(0xFF3B82F6);
        nextRoute = '/delivery-dashboard';
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage(
          role: selectedRole,
          themeColor: themeColor,
          nextRoute: nextRoute,
        ),
      ),
    );
  }

  void _showAdminLoginDialog() {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                color: Color(0xFF8B5CF6),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Admin Access',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your admin credentials to continue',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter admin email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _secretTapCount = 0);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              _validateAdminCredentials(
                emailController.text.trim(),
                passwordController.text,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Login',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _validateAdminCredentials(String email, String password) {
    String normalizedEmail = email.toLowerCase().trim();
    bool isValidEmail = _adminEmails.any(
      (adminEmail) => adminEmail.toLowerCase() == normalizedEmail,
    );

    if (isValidEmail && password == _adminPassword) {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/admin-dashboard');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('Welcome, ${email.split('@')[0].split('.').last}!'),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() => _secretTapCount = 0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isValidEmail
                      ? 'Incorrect password'
                      : 'Email not authorized for admin access',
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF5350),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          color: Colors.white,
          child: Column(
            children: [
              // Header Section (WITH SECRET TAP GESTURE)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _secretTapCount++;
                    if (_secretTapCount >= 5) {
                      _secretTapCount = 0;
                      _showAdminLoginDialog();
                    }
                    if (_secretTapCount > 0 && _secretTapCount < 5) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$_secretTapCount/5 taps'),
                          duration: const Duration(milliseconds: 500),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.only(
                              bottom: 20, left: 20, right: 20),
                        ),
                      );
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.orange[900]!, Colors.orange[700]!],
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.restaurant_menu,
                          color: Colors.white, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DualText(
                              primaryText: l10n.appTitle,
                              englishText: 'Dabba Crew',
                              primaryStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Fresh homemade meals, delivered",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Scrollable Body
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(25),
                  children: [
                    const Text(
                      "Welcome!",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Choose how you'd like to continue",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 25),

                    _buildRoleCard(
                      "Customer",
                      l10n.customer,
                      "Customer",
                      "Order homemade meals",
                      Icons.person,
                      Colors.orange,
                    ),
                    _buildRoleCard(
                      "Home Cook",
                      l10n.homeCook,
                      "Home Cook",
                      "Sell your tiffin services",
                      Icons.soup_kitchen,
                      const Color(0xFF4CAF50),
                    ),
                    _buildRoleCard(
                      "Delivery Partner",
                      l10n.deliveryPartner,
                      "Delivery Partner",
                      "Deliver orders & earn",
                      Icons.directions_bike,
                      const Color(0xFF3B82F6),
                    ),

                    const SizedBox(height: 25),

                    // ── Single Language Switcher ──────────────────────────
                    const Divider(),
                    const SizedBox(height: 12),
                    DualText(
                      primaryText: l10n.language,
                      englishText: 'Language',
                      primaryStyle: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'UI will show in your chosen language with English below',
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButton<String>(
                        value: languageProvider.languageCode,
                        isExpanded: true,
                        underline: const SizedBox(),
                        onChanged: (value) =>
                            languageProvider.setLanguage(value!),
                        items: const [
                          DropdownMenuItem(
                              value: 'en', child: Text('English')),
                          DropdownMenuItem(
                              value: 'hi', child: Text('हिंदी (Hindi)')),
                          DropdownMenuItem(
                              value: 'mr',
                              child: Text('मराठी (Marathi)')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Button Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[800],
                          padding:
                              const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: DualText(
                          primaryText: l10n.continueBtn,
                          englishText: 'Continue',
                          primaryStyle: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DualText(
                      primaryText: l10n.termsText,
                      englishText:
                          'By continuing, you agree to our Terms of Service and Privacy Policy',
                      primaryStyle: const TextStyle(
                          color: Colors.grey, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated _buildRoleCard now accepts englishTitle for DualText
  Widget _buildRoleCard(String roleKey, String title, String englishTitle,
      String sub, IconData icon, Color color) {
    bool isSelected = selectedRole == roleKey;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = roleKey),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DualText(
                    primaryText: title,
                    englishText: englishTitle,
                    primaryStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(sub,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    return AppLocalizations._(provider.primaryLocale.languageCode);
  }

  final String _lang;
  AppLocalizations._(this._lang);

  static final Map<String, Map<String, String>> _strings = {
    'appTitle': {'en': 'Dabba Crew', 'hi': 'डब्बा क्रू', 'mr': 'डब्बा क्रू'},
    'continueBtn': {'en': 'Continue', 'hi': 'जारी रखें', 'mr': 'पुढे जा'},
    'customer': {'en': 'Customer', 'hi': 'ग्राहक', 'mr': 'ग्राहक'},
    'homeCook': {'en': 'Home Cook', 'hi': 'होम कुक', 'mr': 'होम कुक'},
    'deliveryPartner': {
      'en': 'Delivery Partner',
      'hi': 'डिलीवरी पार्टनर',
      'mr': 'डिलिव्हरी पार्टनर'
    },
    'language': {'en': 'Language', 'hi': 'भाषा', 'mr': 'भाषा'},
    'primaryLanguage': {
      'en': 'Primary Language',
      'hi': 'प्राथमिक भाषा',
      'mr': 'प्राथमिक भाषा'
    },
    'secondaryLanguage': {
      'en': 'Secondary Language',
      'hi': 'द्वितीयक भाषा',
      'mr': 'दुय्यम भाषा'
    },
    'termsText': {
      'en': 'By continuing, you agree to our Terms of Service and Privacy Policy',
      'hi': 'जारी रखकर, आप हमारी सेवा शर्तों से सहमत हैं',
      'mr': 'पुढे जाऊन, तुम्ही आमच्या सेवा अटींना सहमती देता'
    },
    'login': {'en': 'Login', 'hi': 'लॉगिन', 'mr': 'लॉगिन'},
    'signUp': {'en': 'Sign Up', 'hi': 'साइन अप', 'mr': 'नोंदणी करा'},
    'fullName': {'en': 'Full Name', 'hi': 'पूरा नाम', 'mr': 'पूर्ण नाव'},
    'emailAddress': {
      'en': 'Email Address',
      'hi': 'ईमेल पता',
      'mr': 'ईमेल पत्ता'
    },
    'phoneNumber': {
      'en': 'Phone Number',
      'hi': 'फोन नंबर',
      'mr': 'फोन नंबर'
    },
    'profile': {'en': 'Profile', 'hi': 'प्रोफाइल', 'mr': 'प्रोफाइल'},
    'logout': {'en': 'Logout', 'hi': 'लॉगआउट', 'mr': 'लॉगआउट'},
    'home': {'en': 'Home', 'hi': 'होम', 'mr': 'होम'},
    'orders': {'en': 'Orders', 'hi': 'ऑर्डर', 'mr': 'ऑर्डर'},
    'menu': {'en': 'Menu', 'hi': 'मेनू', 'mr': 'मेनू'},
    'wallet': {'en': 'Wallet', 'hi': 'वॉलेट', 'mr': 'वॉलेट'},
    'verify': {'en': 'Verify', 'hi': 'सत्यापन', 'mr': 'सत्यापन'},
    'navigate': {'en': 'Navigate', 'hi': 'नेविगेट', 'mr': 'नेव्हिगेट'},
    'dashboard': {'en': 'Dashboard', 'hi': 'डैशबोर्ड', 'mr': 'डॅशबोर्ड'},
    'discover': {'en': 'Discover', 'hi': 'खोजें', 'mr': 'शोधा'},
    'activeOrders': {
      'en': 'Active Orders',
      'hi': 'सक्रिय ऑर्डर',
      'mr': 'सक्रिय ऑर्डर'
    },
    'menuManagement': {
      'en': 'Menu Management',
      'hi': 'मेनू प्रबंधन',
      'mr': 'मेनू व्यवस्थापन'
    },
    'kitchenVerification': {
      'en': 'Kitchen Verification',
      'hi': 'किचन सत्यापन',
      'mr': 'किचन सत्यापन'
    },
    'enterDishName': {
      'en': 'Enter dish name',
      'hi': 'डिश का नाम दर्ज करें',
      'mr': 'पदार्थाचे नाव टाका'
    },
    'dishName': {
      'en': 'Dish Name',
      'hi': 'डिश का नाम',
      'mr': 'पदार्थाचे नाव'
    },
    'addDish': {'en': 'Add Dish', 'hi': 'डिश जोड़ें', 'mr': 'पदार्थ जोडा'},
    'description': {'en': 'Description', 'hi': 'विवरण', 'mr': 'वर्णन'},
    'price': {'en': 'Price', 'hi': 'कीमत', 'mr': 'किंमत'},
    'prepTime': {
      'en': 'Prep Time (mins)',
      'hi': 'तैयारी का समय (मिनट)',
      'mr': 'तयारीचा वेळ (मिनिटे)'
    },
    'category': {'en': 'Category', 'hi': 'श्रेणी', 'mr': 'श्रेणी'},
    'available': {'en': 'Available', 'hi': 'उपलब्ध', 'mr': 'उपलब्ध'},
    'unavailable': {
      'en': 'Unavailable',
      'hi': 'अनुपलब्ध',
      'mr': 'अनुपलब्ध'
    },
    'save': {'en': 'Save', 'hi': 'सहेजें', 'mr': 'जतन करा'},
    'cancel': {'en': 'Cancel', 'hi': 'रद्द करें', 'mr': 'रद्द करा'},
    'delete': {'en': 'Delete', 'hi': 'हटाएं', 'mr': 'हटवा'},
    'edit': {'en': 'Edit', 'hi': 'संपादित करें', 'mr': 'संपादित करा'},
    'search': {'en': 'Search', 'hi': 'खोजें', 'mr': 'शोधा'},
    'totalOrders': {
      'en': 'Total Orders',
      'hi': 'कुल ऑर्डर',
      'mr': 'एकूण ऑर्डर'
    },
    'earnings': {'en': 'Earnings', 'hi': 'कमाई', 'mr': 'कमाई'},
    'rating': {'en': 'Rating', 'hi': 'रेटिंग', 'mr': 'रेटिंग'},
    'deliveries': {
      'en': 'Deliveries',
      'hi': 'डिलीवरी',
      'mr': 'डिलिव्हरी'
    },
    'orderPlaced': {
      'en': 'Order Placed!',
      'hi': 'ऑर्डर दिया गया!',
      'mr': 'ऑर्डर दिला गेला!'
    },
    'viewOrders': {
      'en': 'View Orders',
      'hi': 'ऑर्डर देखें',
      'mr': 'ऑर्डर पहा'
    },
    'checkout': {'en': 'Checkout', 'hi': 'चेकआउट', 'mr': 'चेकआउट'},
    'totalToPay': {
      'en': 'Total to Pay',
      'hi': 'कुल भुगतान',
      'mr': 'एकूण देय'
    },
    'paymentMethod': {
      'en': 'Payment Method',
      'hi': 'भुगतान विधि',
      'mr': 'पेमेंट पद्धत'
    },
    'deliveryFee': {
      'en': 'Delivery Fee',
      'hi': 'डिलीवरी शुल्क',
      'mr': 'डिलिव्हरी शुल्क'
    },
    'platformFee': {
      'en': 'Platform Fee',
      'hi': 'प्लेटफॉर्म शुल्क',
      'mr': 'प्लॅटफॉर्म शुल्क'
    },
    'itemTotal': {
      'en': 'Item Total',
      'hi': 'वस्तु कुल',
      'mr': 'वस्तू एकूण'
    },
    'trackOrder': {
      'en': 'Track Order',
      'hi': 'ऑर्डर ट्रैक करें',
      'mr': 'ऑर्डर ट्रॅक करा'
    },
    'invalidLanguageWarning': {
      'en': 'Please enter dish name in English, Hindi or Marathi',
      'hi': 'कृपया डिश का नाम हिंदी, मराठी या अंग्रेज़ी में दर्ज करें',
      'mr': 'कृपया पदार्थाचे नाव हिंदी, मराठी किंवा इंग्रजीत टाका'
    },
    'welcomeBack': {
      'en': 'Welcome back!',
      'hi': 'वापस स्वागत है!',
      'mr': 'पुन्हा स्वागत आहे!'
    },
    'createAccount': {
      'en': 'Create your account to get started',
      'hi': 'शुरू करने के लिए अपना खाता बनाएं',
      'mr': 'सुरू करण्यासाठी तुमचे खाते तयार करा'
    },
    'noActiveOrders': {
      'en': 'No active orders',
      'hi': 'कोई सक्रिय ऑर्डर नहीं',
      'mr': 'कोणतेही सक्रिय ऑर्डर नाहीत'
    },
    'editProfile': {
      'en': 'Edit Profile',
      'hi': 'प्रोफाइल संपादित करें',
      'mr': 'प्रोफाइल संपादित करा'
    },
    'notifications': {
      'en': 'Notifications',
      'hi': 'सूचनाएं',
      'mr': 'सूचना'
    },
    'helpSupport': {'en': 'Help & Support', 'hi': 'सहायता', 'mr': 'मदत'},
    'myOrders': {
      'en': 'My Orders',
      'hi': 'मेरे ऑर्डर',
      'mr': 'माझे ऑर्डर'
    },
    'myWallet': {
      'en': 'My Wallet',
      'hi': 'मेरा वॉलेट',
      'mr': 'माझे वॉलेट'
    },
    'currentBalance': {
      'en': 'Current Balance',
      'hi': 'वर्तमान शेष',
      'mr': 'सध्याची शिल्लक'
    },
    'addMoney': {'en': 'Add Money', 'hi': 'पैसे जोड़ें', 'mr': 'पैसे जोडा'},
    'recentTransactions': {
      'en': 'Recent Transactions',
      'hi': 'हाल के लेनदेन',
      'mr': 'अलीकडील व्यवहार'
    },
    'verifiedHomeCooks': {
      'en': 'Verified Home Cooks Near You',
      'hi': 'आपके पास सत्यापित होम कुक',
      'mr': 'तुमच्या जवळचे सत्यापित होम कुक'
    },
    'startNavigation': {
      'en': 'Start Navigation',
      'hi': 'नेविगेशन शुरू करें',
      'mr': 'नेव्हिगेशन सुरू करा'
    },
    'markDelivered': {
      'en': 'Mark Delivered',
      'hi': 'डिलीवर किया गया',
      'mr': 'डिलिव्हर केले'
    },
    'deliveryComplete': {
      'en': 'Delivery Complete!',
      'hi': 'डिलीवरी पूर्ण!',
      'mr': 'डिलिव्हरी पूर्ण!'
    },
    'onlineStatus': {
      'en': "You're Online",
      'hi': 'आप ऑनलाइन हैं',
      'mr': 'तुम्ही ऑनलाइन आहात'
    },
    'offlineStatus': {
      'en': "You're Offline",
      'hi': 'आप ऑफलाइन हैं',
      'mr': 'तुम्ही ऑफलाइन आहात'
    },
    'availableForOrders': {
      'en': 'Available for Orders',
      'hi': 'ऑर्डर के लिए उपलब्ध',
      'mr': 'ऑर्डरसाठी उपलब्ध'
    },
    'unavailableForOrders': {
      'en': 'Unavailable',
      'hi': 'अनुपलब्ध',
      'mr': 'अनुपलब्ध'
    },
    'acceptingOrders': {
      'en': 'Accepting new orders',
      'hi': 'नए ऑर्डर स्वीकार कर रहे हैं',
      'mr': 'नवीन ऑर्डर स्वीकारत आहे'
    },
    'notAcceptingOrders': {
      'en': 'Not accepting orders',
      'hi': 'ऑर्डर स्वीकार नहीं कर रहे',
      'mr': 'ऑर्डर स्वीकारत नाही'
    },
    'todayOverview': {
      'en': "Today's Overview",
      'hi': 'आज का सारांश',
      'mr': 'आजचा आढावा'
    },
    'quickActions': {
      'en': 'Quick Actions',
      'hi': 'त्वरित क्रियाएं',
      'mr': 'जलद क्रिया'
    },
    'pending': {'en': 'Pending', 'hi': 'लंबित', 'mr': 'प्रलंबित'},
    'completed': {'en': 'Completed', 'hi': 'पूर्ण', 'mr': 'पूर्ण'},
    'accept': {'en': 'Accept', 'hi': 'स्वीकार करें', 'mr': 'स्वीकारा'},
    'markReady': {
      'en': 'Mark Ready',
      'hi': 'तैयार करें',
      'mr': 'तयार करा'
    },
    'newOrders': {
      'en': 'New Orders',
      'hi': 'नए ऑर्डर',
      'mr': 'नवीन ऑर्डर'
    },
    'preparing': {
      'en': 'Preparing',
      'hi': 'तैयारी हो रही है',
      'mr': 'तयारी सुरू आहे'
    },
    'ready': {'en': 'Ready', 'hi': 'तैयार', 'mr': 'तयार'},
    'savedAddresses': {
      'en': 'Saved Addresses',
      'hi': 'सहेजे गए पते',
      'mr': 'जतन केलेले पत्ते'
    },
    'favoriteCooks': {
      'en': 'Favorite Cooks',
      'hi': 'पसंदीदा कुक',
      'mr': 'आवडते कुक'
    },
    'paymentMethods': {
      'en': 'Payment Methods',
      'hi': 'भुगतान विधियां',
      'mr': 'पेमेंट पद्धती'
    },
    'joinAs': {'en': 'Join as', 'hi': 'जॉइन करें', 'mr': 'सामील व्हा'},
    'enterFullName': {
      'en': 'Enter your full name',
      'hi': 'अपना पूरा नाम दर्ज करें',
      'mr': 'तुमचे पूर्ण नाव टाका'
    },
    'enterEmail': {
      'en': 'Enter your email',
      'hi': 'अपना ईमेल दर्ज करें',
      'mr': 'तुमचा ईमेल टाका'
    },
    'enterPhone': {
      'en': 'Enter 10 digit number',
      'hi': '10 अंकों का नंबर दर्ज करें',
      'mr': '10 अंकांचा नंबर टाका'
    },
    'nameRequired': {
      'en': 'Please enter your name',
      'hi': 'कृपया अपना नाम दर्ज करें',
      'mr': 'कृपया तुमचे नाव टाका'
    },
    'nameTooShort': {
      'en': 'Name must be at least 2 characters',
      'hi': 'नाम कम से कम 2 अक्षर का होना चाहिए',
      'mr': 'नाव किमान 2 अक्षरांचे असावे'
    },
    'emailRequired': {
      'en': 'Please enter your email',
      'hi': 'कृपया अपना ईमेल दर्ज करें',
      'mr': 'कृपया तुमचा ईमेल टाका'
    },
    'emailInvalid': {
      'en': 'Please enter a valid email',
      'hi': 'कृपया वैध ईमेल दर्ज करें',
      'mr': 'कृपया वैध ईमेल टाका'
    },
    'phoneRequired': {
      'en': 'Please enter your phone number',
      'hi': 'कृपया फोन नंबर दर्ज करें',
      'mr': 'कृपया फोन नंबर टाका'
    },
    'phoneTooShort': {
      'en': 'Phone number must be 10 digits',
      'hi': 'फोन नंबर 10 अंकों का होना चाहिए',
      'mr': 'फोन नंबर 10 अंकांचा असावा'
    },
    'connectionError': {
      'en': 'Could not connect to server. Check your connection.',
      'hi': 'सर्वर से कनेक्ट नहीं हो सका। कनेक्शन जांचें।',
      'mr': 'सर्व्हरशी कनेक्ट होता आले नाही। कनेक्शन तपासा।'
    },
    'searchCooks': {
      'en': 'Search for cuisines, cooks...',
      'hi': 'व्यंजन, कुक खोजें...',
      'mr': 'पदार्थ, कुक शोधा...'
    },
    'cooksAvailable': {
      'en': '4 cooks available',
      'hi': '4 कुक उपलब्ध हैं',
      'mr': '4 कुक उपलब्ध आहेत'
    },
    'trackManageOrders': {
      'en': 'Track and manage your orders',
      'hi': 'अपने ऑर्डर ट्रैक करें',
      'mr': 'तुमचे ऑर्डर ट्रॅक करा'
    },
    'inTransit': {
      'en': 'In Transit',
      'hi': 'रास्ते में',
      'mr': 'रस्त्यावर आहे'
    },
    'delivered': {
      'en': 'Delivered',
      'hi': 'डिलीवर हो गया',
      'mr': 'डिलिव्हर झाले'
    },
    'order': {'en': 'Order', 'hi': 'ऑर्डर', 'mr': 'ऑर्डर'},
    'totalAmount': {
      'en': 'Total Amount',
      'hi': 'कुल राशि',
      'mr': 'एकूण रक्कम'
    },
    'pastOrders': {
      'en': 'Past Orders',
      'hi': 'पिछले ऑर्डर',
      'mr': 'मागील ऑर्डर'
    },
    'walletTopUp': {
      'en': 'Wallet Top-up',
      'hi': 'वॉलेट टॉप-अप',
      'mr': 'वॉलेट टॉप-अप'
    },
    'refund': {'en': 'Refund', 'hi': 'रिफंड', 'mr': 'परतावा'},
    'favorites': {'en': 'Favorites', 'hi': 'पसंदीदा', 'mr': 'आवडते'},
    'comingSoon': {
      'en': 'Coming soon',
      'hi': 'जल्द आ रहा है',
      'mr': 'लवकरच येत आहे'
    },
    'profileUpdated': {
      'en': 'Profile updated successfully',
      'hi': 'प्रोफाइल सफलतापूर्वक अपडेट हुई',
      'mr': 'प्रोफाइल यशस्वीरित्या अपडेट झाली'
    },
    'saveChanges': {
      'en': 'Save Changes',
      'hi': 'बदलाव सहेजें',
      'mr': 'बदल जतन करा'
    },
    'orderUpdates': {
      'en': 'Order Updates',
      'hi': 'ऑर्डर अपडेट',
      'mr': 'ऑर्डर अपडेट'
    },
    'promotions': {'en': 'Promotions', 'hi': 'प्रमोशन', 'mr': 'जाहिराती'},
    'emailNotifications': {
      'en': 'Email Notifications',
      'hi': 'ईमेल सूचनाएं',
      'mr': 'ईमेल सूचना'
    },
    'callSupport': {
      'en': 'Call Support',
      'hi': 'सहायता को कॉल करें',
      'mr': 'सपोर्टला कॉल करा'
    },
    'emailUs': {'en': 'Email Us', 'hi': 'ईमेल करें', 'mr': 'ईमेल करा'},
    'liveChat': {'en': 'Live Chat', 'hi': 'लाइव चैट', 'mr': 'लाइव चॅट'},
    'chatWithTeam': {
      'en': 'Chat with our team',
      'hi': 'हमारी टीम से चैट करें',
      'mr': 'आमच्या टीमशी चॅट करा'
    },
    'logoutConfirm': {
      'en': 'Are you sure you want to logout?',
      'hi': 'क्या आप लॉगआउट करना चाहते हैं?',
      'mr': 'तुम्हाला लॉगआउट करायचे आहे का?'
    },
    'verifiedKitchen': {
      'en': 'Verified Kitchen',
      'hi': 'सत्यापित रसोई',
      'mr': 'सत्यापित स्वयंपाकघर'
    },
    'subscribeAndSave': {
      'en': 'Subscribe & Save',
      'hi': 'सब्सक्राइब करें',
      'mr': 'सबस्क्राइब करा'
    },
    'getDailyMealPlans': {
      'en': 'Get daily/weekly meal plans',
      'hi': 'दैनिक/साप्ताहिक भोजन योजना पाएं',
      'mr': 'दैनिक/साप्ताहिक जेवण योजना मिळवा'
    },
    'todaysMenu': {
      'en': "Today's Menu",
      'hi': 'आज का मेनू',
      'mr': 'आजचा मेनू'
    },
    'itemsAvailable': {
      'en': 'items available',
      'hi': 'वस्तुएं उपलब्ध',
      'mr': 'वस्तू उपलब्ध'
    },
    'add': {'en': 'Add', 'hi': 'जोड़ें', 'mr': 'जोडा'},
    'item': {'en': 'item', 'hi': 'वस्तु', 'mr': 'वस्तू'},
    'items': {'en': 'items', 'hi': 'वस्तुएं', 'mr': 'वस्तू'},
    'reviewYourOrder': {
      'en': 'Review your order',
      'hi': 'अपना ऑर्डर जांचें',
      'mr': 'तुमचा ऑर्डर तपासा'
    },
    'orderSummary': {
      'en': 'Order Summary',
      'hi': 'ऑर्डर सारांश',
      'mr': 'ऑर्डर सारांश'
    },
    'billDetails': {
      'en': 'Bill Details',
      'hi': 'बिल विवरण',
      'mr': 'बिल तपशील'
    },
    'walletBalance': {
      'en': 'Wallet Balance',
      'hi': 'वॉलेट बैलेंस',
      'mr': 'वॉलेट शिल्लक'
    },
    'creditDebitCard': {
      'en': 'Credit/Debit Card',
      'hi': 'क्रेडिट/डेबिट कार्ड',
      'mr': 'क्रेडिट/डेबिट कार्ड'
    },
    'orderPlacedSuccess': {
      'en': 'Your order has been placed successfully',
      'hi': 'आपका ऑर्डर सफलतापूर्वक दिया गया',
      'mr': 'तुमचा ऑर्डर यशस्वीरित्या दिला गेला'
    },
    'pay': {'en': 'Pay', 'hi': 'भुगतान करें', 'mr': 'पेमेंट करा'},
    'liveTracking': {
      'en': 'Live Tracking',
      'hi': 'लाइव ट्रैकिंग',
      'mr': 'लाइव ट्रॅकिंग'
    },
    'mapsComingSoon': {
      'en': 'Google Maps integration coming soon',
      'hi': 'गूगल मैप्स जल्द आ रहा है',
      'mr': 'गूगल मॅप्स लवकरच येत आहे'
    },
    'arrivingIn8Mins': {
      'en': 'Arriving in 8 mins',
      'hi': '8 मिनट में आ रहे हैं',
      'mr': '8 मिनिटांत येत आहे'
    },
    'callingPartner': {
      'en': 'Calling delivery partner...',
      'hi': 'डिलीवरी पार्टनर को कॉल कर रहे हैं...',
      'mr': 'डिलिव्हरी पार्टनरला कॉल करत आहे...'
    },
    'orderStatus': {
      'en': 'Order Status',
      'hi': 'ऑर्डर की स्थिति',
      'mr': 'ऑर्डरची स्थिती'
    },
    'orderPlacedStatus': {
      'en': 'Order Placed',
      'hi': 'ऑर्डर दिया गया',
      'mr': 'ऑर्डर दिला गेला'
    },
    'orderConfirmed': {
      'en': 'Order Confirmed',
      'hi': 'ऑर्डर पुष्टि हुई',
      'mr': 'ऑर्डर पुष्टी झाली'
    },
    'preparingFood': {
      'en': 'Preparing Food',
      'hi': 'खाना तैयार हो रहा है',
      'mr': 'जेवण तयार होत आहे'
    },
    'outForDelivery': {
      'en': 'Out for Delivery',
      'hi': 'डिलीवरी के लिए निकला',
      'mr': 'डिलिव्हरीसाठी निघाले'
    },
    'orderedFrom': {
      'en': 'Ordered from',
      'hi': 'यहाँ से ऑर्डर किया',
      'mr': 'येथून ऑर्डर केले'
    },
  };

  String _get(String key) {
    return _strings[key]?[_lang] ?? _strings[key]?['en'] ?? key;
  }

  String get appTitle => _get('appTitle');
  String get continueBtn => _get('continueBtn');
  String get customer => _get('customer');
  String get homeCook => _get('homeCook');
  String get deliveryPartner => _get('deliveryPartner');
  String get language => _get('language');
  String get primaryLanguage => _get('primaryLanguage');
  String get secondaryLanguage => _get('secondaryLanguage');
  String get termsText => _get('termsText');
  String get login => _get('login');
  String get signUp => _get('signUp');
  String get fullName => _get('fullName');
  String get emailAddress => _get('emailAddress');
  String get phoneNumber => _get('phoneNumber');
  String get profile => _get('profile');
  String get logout => _get('logout');
  String get home => _get('home');
  String get orders => _get('orders');
  String get menu => _get('menu');
  String get wallet => _get('wallet');
  String get verify => _get('verify');
  String get navigate => _get('navigate');
  String get dashboard => _get('dashboard');
  String get discover => _get('discover');
  String get activeOrders => _get('activeOrders');
  String get menuManagement => _get('menuManagement');
  String get kitchenVerification => _get('kitchenVerification');
  String get enterDishName => _get('enterDishName');
  String get dishName => _get('dishName');
  String get addDish => _get('addDish');
  String get description => _get('description');
  String get price => _get('price');
  String get prepTime => _get('prepTime');
  String get category => _get('category');
  String get available => _get('available');
  String get unavailable => _get('unavailable');
  String get save => _get('save');
  String get cancel => _get('cancel');
  String get delete => _get('delete');
  String get edit => _get('edit');
  String get search => _get('search');
  String get totalOrders => _get('totalOrders');
  String get earnings => _get('earnings');
  String get rating => _get('rating');
  String get deliveries => _get('deliveries');
  String get orderPlaced => _get('orderPlaced');
  String get viewOrders => _get('viewOrders');
  String get checkout => _get('checkout');
  String get totalToPay => _get('totalToPay');
  String get paymentMethod => _get('paymentMethod');
  String get deliveryFee => _get('deliveryFee');
  String get platformFee => _get('platformFee');
  String get itemTotal => _get('itemTotal');
  String get trackOrder => _get('trackOrder');
  String get invalidLanguageWarning => _get('invalidLanguageWarning');
  String get welcomeBack => _get('welcomeBack');
  String get createAccount => _get('createAccount');
  String get noActiveOrders => _get('noActiveOrders');
  String get editProfile => _get('editProfile');
  String get notifications => _get('notifications');
  String get helpSupport => _get('helpSupport');
  String get myOrders => _get('myOrders');
  String get myWallet => _get('myWallet');
  String get currentBalance => _get('currentBalance');
  String get addMoney => _get('addMoney');
  String get recentTransactions => _get('recentTransactions');
  String get verifiedHomeCooks => _get('verifiedHomeCooks');
  String get startNavigation => _get('startNavigation');
  String get markDelivered => _get('markDelivered');
  String get deliveryComplete => _get('deliveryComplete');
  String get onlineStatus => _get('onlineStatus');
  String get offlineStatus => _get('offlineStatus');
  String get availableForOrders => _get('availableForOrders');
  String get unavailableForOrders => _get('unavailableForOrders');
  String get acceptingOrders => _get('acceptingOrders');
  String get notAcceptingOrders => _get('notAcceptingOrders');
  String get todayOverview => _get('todayOverview');
  String get quickActions => _get('quickActions');
  String get pending => _get('pending');
  String get completed => _get('completed');
  String get accept => _get('accept');
  String get markReady => _get('markReady');
  String get newOrders => _get('newOrders');
  String get preparing => _get('preparing');
  String get ready => _get('ready');
  String get savedAddresses => _get('savedAddresses');
  String get favoriteCooks => _get('favoriteCooks');
  String get paymentMethods => _get('paymentMethods');
  String get joinAs => _get('joinAs');
  String get enterFullName => _get('enterFullName');
  String get enterEmail => _get('enterEmail');
  String get enterPhone => _get('enterPhone');
  String get nameRequired => _get('nameRequired');
  String get nameTooShort => _get('nameTooShort');
  String get emailRequired => _get('emailRequired');
  String get emailInvalid => _get('emailInvalid');
  String get phoneRequired => _get('phoneRequired');
  String get phoneTooShort => _get('phoneTooShort');
  String get connectionError => _get('connectionError');
  String get searchCooks => _get('searchCooks');
  String get cooksAvailable => _get('cooksAvailable');
  String get trackManageOrders => _get('trackManageOrders');
  String get inTransit => _get('inTransit');
  String get delivered => _get('delivered');
  String get order => _get('order');
  String get totalAmount => _get('totalAmount');
  String get pastOrders => _get('pastOrders');
  String get walletTopUp => _get('walletTopUp');
  String get refund => _get('refund');
  String get favorites => _get('favorites');
  String get comingSoon => _get('comingSoon');
  String get profileUpdated => _get('profileUpdated');
  String get saveChanges => _get('saveChanges');
  String get orderUpdates => _get('orderUpdates');
  String get promotions => _get('promotions');
  String get emailNotifications => _get('emailNotifications');
  String get callSupport => _get('callSupport');
  String get emailUs => _get('emailUs');
  String get liveChat => _get('liveChat');
  String get chatWithTeam => _get('chatWithTeam');
  String get logoutConfirm => _get('logoutConfirm');
  String get verifiedKitchen => _get('verifiedKitchen');
  String get subscribeAndSave => _get('subscribeAndSave');
  String get getDailyMealPlans => _get('getDailyMealPlans');
  String get todaysMenu => _get('todaysMenu');
  String get itemsAvailable => _get('itemsAvailable');
  String get add => _get('add');
  String get item => _get('item');
  String get items => _get('items');
  String get reviewYourOrder => _get('reviewYourOrder');
  String get orderSummary => _get('orderSummary');
  String get billDetails => _get('billDetails');
  String get walletBalance => _get('walletBalance');
  String get creditDebitCard => _get('creditDebitCard');
  String get orderPlacedSuccess => _get('orderPlacedSuccess');
  String get pay => _get('pay');
  String get liveTracking => _get('liveTracking');
  String get mapsComingSoon => _get('mapsComingSoon');
  String get arrivingIn8Mins => _get('arrivingIn8Mins');
  String get callingPartner => _get('callingPartner');
  String get orderStatus => _get('orderStatus');
  String get orderPlacedStatus => _get('orderPlacedStatus');
  String get orderConfirmed => _get('orderConfirmed');
  String get preparingFood => _get('preparingFood');
  String get outForDelivery => _get('outForDelivery');
  String get orderedFrom => _get('orderedFrom');
}