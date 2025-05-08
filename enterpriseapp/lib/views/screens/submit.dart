import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/providers/session.dart';
import 'package:enterpriseapp/viewmodels/submit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitScreen extends StatelessWidget {
  const SubmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = SubmitVM(
          context.read<SessionProvider>(),
          context.read<ConfigProvider>(),
        );
        vm.nextScreen = () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/start',
              (route) => false,
            );
          });
        };
        return vm;
      },
      child: Consumer<SubmitVM>(
        builder: (context, vm, child) {
          if (vm.loading) {
            // Show loading indicator while waiting for API
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (vm.errorMessage != null) {
            // Show error message if API call fails
            return Scaffold(
              body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/start',
                    (route) => false,
                  );
                },
                child: Center(
                  child: Text(
                    vm.errorMessage!,
                    style: TextStyle(
                      fontSize: 70.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      vm.title,
                      style: TextStyle(
                        fontSize: 90.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 60.h),
                    Text(
                      vm.subtitle,
                      style: TextStyle(fontSize: 40.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
