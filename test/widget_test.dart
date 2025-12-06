import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quake_alert/main.dart';

void main() {
  testWidgets('App starts and displays main screen', (WidgetTester tester) async {
    await EasyLocalization.ensureInitialized();
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('bn')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: const MainScreen(),
            );
          },
        ),
      ),
    );

    // Verify that the MainScreen is displayed.
    expect(find.byType(MainScreen), findsOneWidget);
    // The AppBar title is 'Quake Alert' when _pageIndex is not 1.
    expect(find.text('Quake Alert'), findsOneWidget);
  });
}