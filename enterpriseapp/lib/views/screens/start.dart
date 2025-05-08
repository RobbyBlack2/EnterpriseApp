import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/providers/session.dart';
import 'package:enterpriseapp/viewmodels/start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfigProvider>().checkTimeStatus();
    });

    final isClosed = context.watch<ConfigProvider>().isClosed;

    if (isClosed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/closed');
      });
      return const SizedBox.shrink();
    }
    return ChangeNotifierProvider(
      create: (_) {
        final vm = StartVM(
          context.read<SessionProvider>(),
          context.read<ConfigProvider>(),
        );
        vm.nextScreen = () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/fname',
            (route) => false,
          );
        };
        return vm;
      },
      child: Consumer<StartVM>(
        builder: (context, vm, child) {
          // Hardcoded background image URL
          const backgroundImageUrl =
              'https://images-cdn.ispot.tv/ad/7NIO/default-large.jpg';

          Widget content;
          if (!vm.askAltLang) {
            // Tap anywhere to sign in, with title and subtitle
            content = GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => vm.submitScreen('en'),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10.h,
                  bottom: 60.h,
                  left: 16.w,
                  right: 16.w,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 100.h),
                      child: Column(
                        children: [
                          Text(
                            'Please Sign In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 90.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 0.7.sw,
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                            ),
                            onPressed: () => vm.submitScreen('en'),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 60.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Language selection buttons
            content = Padding(
              padding: EdgeInsets.only(
                top: 10.h,
                bottom: 60.h,
                left: 16.w,
                right: 16.w,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 100.h),
                    child: Column(
                      children: [
                        Text(
                          '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 90.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 0.4.sw,
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                          ),
                          onPressed: () => vm.submitScreen('en'),
                          child: Text(
                            'English',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 65.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 0.4.sw,
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                          ),
                          onPressed: () => vm.submitScreen('es'),
                          child: Text(
                            'Español',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 65.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 100,
              backgroundColor: Theme.of(context).primaryColor,
              title: const Text(
                'Please Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 65,
                  fontWeight: FontWeight.w500,
                ),
              ),
              //backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(backgroundImageUrl, fit: BoxFit.cover),
                ),
                content,
              ],
            ),
          );
        },
      ),
    );
  }
}
