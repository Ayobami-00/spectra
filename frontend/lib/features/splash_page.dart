import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/presentation/index.dart';
// import 'package:frontend/features/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // final authBloc = BlocProvider.of<AuthenticationCubit>(context);
    // authBloc.getSignedInUserLogic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) async {
        // final coreBloc = BlocProvider.of<CoreCubit>(context);
        if (state is AuthenticationSuccessful) {
          final authBloc = BlocProvider.of<AuthenticationCubit>(context);
          await authBloc.sendOnAppStartPriorityEvent();

          Future.delayed(
            const Duration(milliseconds: 2000),
            () {
              authBloc.sendOnAppStartLazyEvent();
            },
          );
          locator<NavigationService>().goNamed(overviewRoute);
        } else {
          locator<NavigationService>().goNamed(signInRoute);
        }
      },
      builder: (context, state) {
        // final double appWidth = MediaQuery.of(context).size.width;
        // final double appHeight = MediaQuery.of(context).size.width;
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              top: 350.0.h,
              bottom: 100.0.h,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }
}
