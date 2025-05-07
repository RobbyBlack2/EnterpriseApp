import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/viewmodels/yn2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:enterpriseapp/providers/session.dart';

class YesNo2Screen extends StatelessWidget {
  const YesNo2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final configProvider = context.read<ConfigProvider>();

    return ChangeNotifierProvider(
      create: (_) {
        final vm = YN2VM(
          context.read<SessionProvider>(),
          context.read<ConfigProvider>(),
        );

        // Navigation callback
        vm.nextScreen = () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            String nextScreen = configProvider.getNextRoute('/yn2');
            Navigator.pushReplacementNamed(context, nextScreen);
          });
        };

        // Timeout callback
        vm.timeOut = () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/start');
          });
        };

        return vm;
      },
      child: Consumer<YN2VM>(
        builder: (context, vm, child) {
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    vm.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 70.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => vm.submitScreen('1'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(
                            255,
                            48,
                            166,
                            8,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 55.w,
                            vertical: 30.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 50.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => vm.submitScreen('0'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(
                            255,
                            255,
                            37,
                            37,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 55.w,
                            vertical: 30.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontSize: 50.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
