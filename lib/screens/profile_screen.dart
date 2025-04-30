// import 'package:flutter/material.dart';
// import '../models/user.dart';
// import '../services/user_service.dart';
// import 'edit_profile_screen.dart';
// import 'orders_screen.dart';
// import 'settings_screen.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final UserService _userService = UserService();
//   late Future<User> _userFuture;
  
//   @override
//   void initState() {
//     super.initState();
//     _userFuture = _userService.getCurrentUser();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const SettingsScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<User>(
//         future: _userFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return const Center(child: Text('No user data available'));
//           }

//           final user = snapshot.data!;
          
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // User header
//                 Center(
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.deepPurple.shade100,
//                         child: Text(
//                           _getInitials(user.name),
//                           style: const TextStyle(
//                             fontSize: 36,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.deepPurple,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         user.name,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         user.email,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       OutlinedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => EditProfileScreen(user: user),
//                             ),
//                           ).then((_) {
//                             // Refresh user data when returning from edit profile
//                             setState(() {
//                               _userFuture = _userService.getCurrentUser();
//                             });
//                           });
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: Colors.deepPurple),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text('Edit Profile'),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 32),
                
//                 // Profile options
//                 _buildProfileOption(
//                   icon: Icons.shopping_bag_outlined,
//                   title: 'My Orders',
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const OrdersScreen()),
//                     );
//                   },
//                 ),
//                 _buildProfileOption(
//                   icon: Icons.favorite_border,
//                   title: 'Wishlist',
//                   onTap: () {
//                     // Navigate to wishlist screen
//                   },
//                 ),
//                 _buildProfileOption(
//                   icon: Icons.location_on_outlined,
//                   title: 'Shipping Addresses',
//                   onTap: () {
//                     // Navigate to addresses screen
//                   },
//                 ),
//                 _buildProfileOption(
//                   icon: Icons.payment_outlined,
//                   title: 'Payment Methods',
//                   onTap: () {
//                     // Navigate to payment methods screen
//                   },
//                 ),
//                 _buildProfileOption(
//                   icon: Icons.support_agent_outlined,
//                   title: 'Customer Support',
//                   onTap: () {
//                     // Navigate to support screen
//                   },
//                 ),
//                 _buildProfileOption(
//                   icon: Icons.logout,
//                   title: 'Logout',
//                   textColor: Colors.red,
//                   onTap: () {
//                     _showLogoutDialog();
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProfileOption({
//     required IconData icon,
//     required String title,
//     Color? textColor,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: textColor ?? Colors.deepPurple),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           color: textColor,
//         ),
//       ),
//       trailing: const Icon(Icons.chevron_right),
//       onTap: onTap,
//     );
//   }

//   String _getInitials(String name) {
//     List<String> nameParts = name.split(' ');
//     String initials = '';
    
//     if (nameParts.isNotEmpty) {
//       initials += nameParts[0][0];
      
//       if (nameParts.length > 1) {
//         initials += nameParts[nameParts.length - 1][0];
//       }
//     }
    
//     return initials.toUpperCase();
//   }

//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//           ),
//           TextButton(
//             child: const Text(
//               'Logout',
//               style: TextStyle(color: Colors.red),
//             ),
//             onPressed: () {
//               // Perform logout operations
//               Navigator.of(ctx).pop();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Logged out successfully')),