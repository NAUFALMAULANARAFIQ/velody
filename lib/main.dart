import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_mobile/core/configs/themes/app_theme.dart';
import 'package:project_mobile/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:project_mobile/presentation/splash/pages/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider(create: (_) => ThemeCubit())
      ],
      child :BlocBuilder<ThemeCubit,ThemeMode>(
        builder: (context,mode) => MaterialApp( 
        theme: AppTheme.lightTheme,
        themeMode: mode,
        darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false, 
        home: const SplashPage()
            ),
      )
    );
  }
}
