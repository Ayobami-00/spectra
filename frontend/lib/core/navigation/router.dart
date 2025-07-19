import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/presentation/index.dart';
import 'package:frontend/features/grind_score_page.dart';
import 'package:frontend/features/home/index.dart';
import 'package:frontend/features/landing_page.dart';
import 'package:frontend/features/pricing_page.dart';
import 'package:go_router/go_router.dart';

import 'am_custom_page_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: locator<NavigationService>().navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: baseRoute,
      pageBuilder: (context, state) {
        return AmCustomPageRoutes.withoutAnimation(
          child: const LandingPage(),
        );
      },
    ),

    GoRoute(
      path: '/landing',
      name: landingRoute,
      pageBuilder: (context, state) {
        return AmCustomPageRoutes.withoutAnimation(
          child: const LandingPage(),
        );
      },
    ),

    GoRoute(
      path: '/grind-score',
      name: grindScoreRoute,
      pageBuilder: (context, state) {
        return AmCustomPageRoutes.withoutAnimation(
          child: GrindScorePage(
            username: state.uri.queryParameters["username"] ?? "",
          ),
        );
      },
    ),

    GoRoute(
      path: '/',
      name: homeRoute,
      pageBuilder: (context, state) {
        return AmCustomPageRoutes.withoutAnimation(
          child: const HomePage(),
        );
      },
    ),

    GoRoute(
      path: '/guest',
      name: guestRoute,
      pageBuilder: (context, state) {
        final sessionId = state.uri.queryParameters["sessionId"] ?? "";
        final message = state.uri.queryParameters["message"] ?? "";
        return AmCustomPageRoutes.guestScreenTransition(
          child: GuestScreen(
            sessionId: sessionId,
            message: message,
          ),
        );
      },
    ),

    GoRoute(
      path: '/pricing',
      name: pricingRoute,
      pageBuilder: (context, state) {
        return AmCustomPageRoutes.withoutAnimation(
          child: const PricingPage(),
        );
      },
    ),

    GoRoute(
        path: '/usecase/auth',
        name: authenticationBaseRoute,
        pageBuilder: (context, state) {
          final taskID = state.uri.queryParameters["taskID"] ?? "";
          final defaultTaskID =
              state.uri.queryParameters["defaultTaskID"] ?? "";

          final type = state.uri.queryParameters["type"] ?? "";

          final workflowId = state.uri.queryParameters["workflowId"] ?? "";
          final stepId = state.uri.queryParameters["stepId"] ?? "";
          final taskTitle = state.uri.queryParameters["taskTitle"] ?? "";

          Map<String, dynamic> params = {};

          params = {
            'taskID': taskID,
            'defaultTaskID': defaultTaskID,
            'workflowId': workflowId,
            'stepId': stepId,
            'taskTitle': taskTitle,
            'type': type,
          };

          return AmCustomPageRoutes.withoutAnimation(
            child: AuthenticationBasePage(
              params: AuthenticationParams(
                type: AuthenticationType.email,
                params: params,
              ),
            ),
          );
        }),

    GoRoute(
      path: '/login',
      name: signInRoute,
      pageBuilder: (context, state) {
        return AmCustomPageRoutes.withoutAnimation(
          child: const SignInPage(),
        );
      },
    ),

    // GoRoute(
    //   path: '/',
    //   name: baseRoute,
    //   pageBuilder: (context, state) {
    //     return AmCustomPageRoutes.withoutAnimation(
    //       child: const GrindScorePage(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: '/register',
    //   name: registerRoute,
    //   pageBuilder: (context, state) {
    //     return AmCustomPageRoutes.withoutAnimation(
    //       child: const SignUpPage(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: '/login',
    //   name: signInRoute,
    //   pageBuilder: (context, state) {
    //     return AmCustomPageRoutes.withoutAnimation(
    //       child: const SignInPage(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: '/otp-verification',
    //   name: otpVerificationRoute,
    //   pageBuilder: (context, state) {
    //     final emailAddress = state.uri.queryParameters["emailAddress"] ?? "";
    //     final bloc = BlocProvider.of<AuthenticationCubit>(context);
    //     return AmCustomPageRoutes.ltrSlideTransition(
    //       child: OtpVerificationPage(
    //         emailAddress: emailAddress,
    //         onOtpVerificationSuccessfull: bloc.onOtpVerificationSuccessfull,
    //       ),
    //     );
    //   },
    // ),
    // StatefulShellRoute.indexedStack(
    //   builder: (context, state, navigationShell) {
    //     // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
    //     // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
    //     return AppBase(appBaseNavigationShell: navigationShell);
    //   },
    //   branches: [
    //     StatefulShellBranch(
    //         navigatorKey: locator<NavigationService>().appBaseNavigatorKey,
    //         routes: <RouteBase>[
    //           GoRoute(
    //             name: overviewRoute,
    //             path: '/dashboard/overview',
    //             builder: (context, state) => const Overview(),
    //           ),
    //         ]),
    //     StatefulShellBranch(
    //       routes: <RouteBase>[
    //         GoRoute(
    //           name: tasksRoute,
    //           path: '/dashboard/tasks',
    //           builder: (context, state) => const AuditLog(),
    //         ),
    //       ],
    //     ),
    //     StatefulShellBranch(
    //       routes: <RouteBase>[
    //         GoRoute(
    //           name: auditsRoute,
    //           path: '/dashboard/audits',
    //           builder: (context, state) => AuditLog(),
    //         ),
    //       ],
    //     ),
    //   ],
    // ),
    // GoRoute(
    //   path: '/onboarding',
    //   name: onboardingRoute,
    //   builder: (context, state) => OnboardingPage(),
    // ),
    // GoRoute(
    //   path: '/register',
    //   name: registerRoute,
    //   builder: (context, state) => const RegistrationIndexPage(),
    // ),
    // GoRoute(
    //   path: '/signIn',
    //   name: signInRoute,
    //   builder: (context, state) => const SignInIndexPage(),
    // ),
    // GoRoute(
    //   path: '/forgotPassword',
    //   name: forgotPasswordRoute,
    //   builder: (context, state) => const ForgotPasswordPage(),
    // ),
    // GoRoute(
    //   path: '/selectLinkingType',
    //   name: selectLinkingTypeRoute,
    //   builder: (context, state) => const SelectLinkingType(),
    // ),
    // GoRoute(
    //   path: '/createVirtualAccount',
    //   name: createVirtualAccountPage,
    //   builder: (context, state) => const CreateVirtualAccountPage(),
    // ),
    // GoRoute(
    //   path: '/linkAccount',
    //   name: linkAccountRoute,
    //   builder: (context, state) {
    //     final args = state.extra as LinkAccountArguments?;
    //     return LinkAccount(
    //       shouldShowDialog: args?.shouldShowDialog ?? true,
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: '/sendCash',
    //   name: sendCashRoute,
    //   builder: (context, state) {
    //     final args = state.extra as SendPaymentSourcePageArguments?;
    //     return SendPaymentSourcePage(
    //       sendAccountInputData: args?.sendAccountInputData,
    //       onSendFunctionalityDone: args?.onSendFunctionalityDone,
    //       currentSendModuleType: args?.currentSendModuleType,
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: '/base',
    //   name: basePageRoute,
    //   builder: (context, state) {
    //     final args = state.extra as AppBaseArguments?;
    //     return AppBase(
    //       passedIndex: args?.passedIndex,
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: '/notification',
    //   name: notificationPageRoute,
    //   builder: (context, state) => const NotificationIndexPage(),
    // ),
    // GoRoute(
    //   path: '/allBills',
    //   name: allBillsPageRoute,
    //   builder: (context, state) => const AllBillsPage(),
    // ),
  ],
);
