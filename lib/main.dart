import 'package:chatapp/screens/authScreen.dart';
import 'package:chatapp/screens/chatScreen.dart';
import 'package:chatapp/screens/editProfileScreen.dart';
import 'package:chatapp/screens/messageScreen.dart';
import 'package:chatapp/screens/profile.dart';
import 'package:chatapp/theme.dart';
import 'package:chatapp/utils/authService.dart';
import 'package:chatapp/widgets/tabbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyThemeNotify myThemeNotify = MyThemeNotify();
  @override
  void initState() {
    super.initState();
    print('ChangedTheme  ${myThemeNotify.hasListeners}');
  }

  @override
  void dispose() {
    print('Disposiingg');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyThemeNotify(),
      child: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MyThemeNotify>(
      builder: (context, myTheme, child) {
        return MaterialApp(
            darkTheme: MyThemes.darkTheme,
            themeMode: myTheme.currentTheme(),
            debugShowCheckedModeBanner: false,
            title: 'ChatApp',
            theme: MyThemes.lightTheme,
            home: AuthService().handleAuthState(),
            routes: {
              '/chatScreen': (context) => ChatScreen(),
              '/messageScreen': (context) => MessageScreen(),
              '/profileScreen': (context) =>
                  ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid),
              '/authScreen': (context) => AuthScreen(),
              '/tabsScreen': (context) => TabsScreen(),
              '/editScreen': (context) => EditProfilePage(),
            });
      },
    );
  }
}
