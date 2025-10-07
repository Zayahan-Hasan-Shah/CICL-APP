import 'package:cicl_app/src/models/family_model/family_model.dart';
import 'package:cicl_app/src/routing/routes_names.dart';
import 'package:cicl_app/src/views/auth/forget_password_screen.dart';
import 'package:cicl_app/src/views/auth/login_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/bottom_navigation.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/claim/add_claim_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/claim/claim_Detail_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/claim/claim_list_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/family/add_family_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/family/family_detail_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/family/family_list_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/home/home_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/profile/profile_screen.dart';
import 'package:cicl_app/src/views/hospital/hospital_list_screen.dart';
import 'package:cicl_app/src/views/laboratory/laboratory_list_screen.dart';
import 'package:cicl_app/src/views/limit/claim_limit_screen.dart';
import 'package:cicl_app/src/views/on_boarding/boarding_screen.dart';
import 'package:cicl_app/src/views/on_boarding/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutesNames.splasScreen,
    routes: [
      GoRoute(
        path: RoutesNames.splasScreen,
        name: RoutesNames.splasScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutesNames.loginScreen,
        name: RoutesNames.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutesNames.forgotPasswordScreen,
        name: RoutesNames.forgotPasswordScreen,
        builder: (context, state) => const ForgetPasswordScreen(),
      ),
      GoRoute(
        path: RoutesNames.dashboardScreen,
        name: RoutesNames.dashboardScreen,
        builder: (context, state) {
          final initialIndex = state.extra as int? ?? 0;
          return BottomNavigation(initialIndex: initialIndex);
        },
      ),
      // GoRoute(
      //   path: RoutesNames.dashboardScreen,
      //   name: RoutesNames.dashboardScreen,
      //   builder: (context, state) => const BottomNavigation(),
      // ),
      GoRoute(
        path: RoutesNames.homeScreen,
        name: RoutesNames.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutesNames.familyListScreen,
        name: RoutesNames.familyListScreen,
        builder: (context, state) => const FamilyListScreen(),
      ),
      GoRoute(
        path: RoutesNames.familyDetailScreen,
        name: RoutesNames.familyDetailScreen,
        builder: (context, state) {
          final famMeb =
              state.extra as FamilyModel; // <-- replace with your model
          return FamilyDetailScreen(
            name: famMeb.name,
            relation: famMeb.relation,
            gender: famMeb.gender == 'F' ? 'Female' : 'Male',
            cnicBform: 'XXXXX XXXXXXX X',
            dateOfBirth: famMeb.date_of_birth,
          );
        },
      ),
      GoRoute(
        path: RoutesNames.addFamilyScreen,
        name: RoutesNames.addFamilyScreen,
        builder: (context, state) => const AddFamilyScreen(),
      ),
      GoRoute(
        path: RoutesNames.claimlistScreen,
        name: RoutesNames.claimlistScreen,
        builder: (context, state) => const ClaimListScreen(),
      ),
      GoRoute(
        path: RoutesNames.addClaimScreen,
        name: RoutesNames.addClaimScreen,
        builder: (context, state) => const AddClaimScreen(),
      ),
      GoRoute(
        path: RoutesNames.claimDetailScreen,
        name: RoutesNames.claimDetailScreen,
        builder: (context, state) {
          final claimNo = state.extra as String;
          final clmseqnos = state.extra as String;
          return ClaimDetailScreen(claimNo: claimNo, clmseqnos: clmseqnos);
        },
      ),
      GoRoute(
        path: RoutesNames.profileScreen,
        name: RoutesNames.profileScreen,
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: RoutesNames.onBoardingScreen,
        name: RoutesNames.onBoardingScreen,
        builder: (context, state) => const BoardingScreen(),
      ),
      GoRoute(
        path: RoutesNames.claimLimitScreen,
        name: RoutesNames.claimLimitScreen,
        builder: (context, state) => const ClaimLimitScreen(),
      ),
      GoRoute(
        path: RoutesNames.hospitalListScreen,
        name: RoutesNames.hospitalListScreen,
        builder: (context, state) => const HospitalListScreen(),
      ),
      GoRoute(
        path: RoutesNames.laboratoryListScreen,
        name: RoutesNames.laboratoryListScreen,
        builder: (context, state) => const LaboratoryListScreen(),
      ),
    ],
  );
}
