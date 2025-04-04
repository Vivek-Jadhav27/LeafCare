import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafcare/apis_data.dart';
import 'package:leafcare/core/constants.dart';
import 'package:leafcare/core/theme/app_theme.dart';
import 'package:leafcare/data/datasources/database_helper.dart';
import 'package:leafcare/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
      url: ApisData.supabaseUrl,
      anonKey: ApisData.supabaseKey,
      authOptions: FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ));
  final dbHelper = DatabaseHelper();
  await dbHelper.loadDataFromJson();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [...AppRoutes.allproviders()],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
