import 'package:go_router/go_router.dart';
import 'package:sunny_chen_project/screens/feedback_screen.dart';
import 'package:sunny_chen_project/screens/home_screen.dart';
import 'package:sunny_chen_project/screens/login_screen.dart';
import 'package:sunny_chen_project/screens/profile_screen.dart';
import 'package:sunny_chen_project/screens/sign_up_screen.dart';
import 'package:sunny_chen_project/screens/splash_screen.dart';
import 'package:sunny_chen_project/screens/try_screen.dart';
import 'package:sunny_chen_project/screens/unit_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(path: 'profile', builder: (context, state) => ProfileScreen()),
      ],
    ),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => SignUpScreen()),
    GoRoute(
      path: '/unit/:unitNumber',
      builder: (context, state) {
        if (state.pathParameters['unitNumber'] == null) {
          return HomeScreen();
        } else {
          return UnitScreen(id: int.parse(state.pathParameters['unitNumber']!));
        }
      },
      routes: [
        GoRoute(
          path: 'try/:scenarioNumber',
          builder:
              (context, state) => TryScreen(
                unitId: int.parse(state.pathParameters['unitNumber']!),
                scenarioNumber: int.parse(
                  state.pathParameters['scenarioNumber']!,
                ),
              ),
        ),
        GoRoute(
          path: 'feedback/:scenarioNumber',
          builder: (context, state) {
            final Map<String, dynamic> data =
                state.extra! as Map<String, dynamic>;
            return FeedbackScreen(
              unitNumber: int.parse(state.pathParameters['unitNumber']!),
              scenario: data['scenario'],
              userResponse: data['userResponse'],
              scenarioNumber: int.parse(
                state.pathParameters['scenarioNumber']!,
              ),
            );
          },
        ),
      ],
    ),
  ],
);
