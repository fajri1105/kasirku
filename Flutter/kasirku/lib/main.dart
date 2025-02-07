import 'package:flutter/material.dart';
import 'package:sop_app/models/user.dart';
import 'package:sop_app/pages/account.dart';
import 'package:sop_app/pages/login.dart';
import 'package:sop_app/pages/login_check.dart';
import 'package:sop_app/pages/menus.dart';
import 'package:sop_app/pages/navigation.dart';
import 'package:sop_app/pages/new_product.dart';
import 'package:sop_app/pages/order_history.dart';
import 'package:sop_app/pages/register.dart';
import 'package:sop_app/pages/shopping.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sop_app/provider/order_item_provider.dart';
import 'package:sop_app/provider/order_provider.dart';
import 'package:sop_app/provider/product_provider.dart';
import 'package:sop_app/provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => ProductProvider()),
    ChangeNotifierProvider(create: (context) => OrderProvider()),
    ChangeNotifierProvider(create: (context) => OrderItemProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.white))),
      initialRoute: Login.routeName,
      routes: {
        Login.routeName: (context) => Login(),
        Register.routeName: (context) => Register(),
        Shopping.routeName: (context) => Shopping(),
        Navigation.routeName: (context) => Navigation(),
        LoginCheck.routeName: (context) => LoginCheck(),
        Menus.routeName: (context) => Menus(),
        Account.routeName: (context) => Account(),
        NewProduct.routeName: (context) => NewProduct(),
        OrderHistory.routeName: (context) => OrderHistory(),
      },
    );
  }
}
