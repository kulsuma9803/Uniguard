import  'package:uniguard/screens/assignment_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniguard/screens/splash_screen.dart';
import 'package:uniguard/screens/login_screen.dart';
import 'package:uniguard/screens/register_screen.dart';
import 'package:uniguard/screens/home_screen.dart';
import 'package:uniguard/screens/admin_dashboard.dart';
import 'package:uniguard/screens/admin_add_notice.dart';
import 'package:uniguard/screens/admin_manage_users.dart';
import 'package:uniguard/screens/admin_system_logs.dart';
import 'package:uniguard/screens/lost_found_screen.dart';
import 'package:uniguard/screens/edit_profile_screen.dart';
import 'package:uniguard/theme/app_theme.dart';
import 'package:uniguard/screens/admin_profile_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://dolwzmrhylrguryaoouk.supabase.co',
    anonKey: 'sb_publishable_6e6j_WESvuogicp8ETkZ_w_rGHkOpGP',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniGuard',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/admin': (_) => const AdminDashboard(),
        '/admin_add_notice': (_) => const AdminAddNotice(),
        '/admin_manage_users': (_) => const AdminManageUsers(),
        '/admin_system_logs': (_) => const AdminSystemLogs(),
        '/assignments': (_) => AssignmentsScreen(),
        '/lost_found': (_) => const LostFoundScreen(),
        '/edit_profile': (_) => const EditProfileScreen(),
        '/admin_profile': (_) => const AdminProfileScreen(),
      },
    );
  }
}

