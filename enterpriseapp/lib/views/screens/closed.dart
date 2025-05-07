import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/viewmodels/closed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ClosedScreen extends StatelessWidget {
  const ClosedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfigProvider>().checkTimeStatus();
    });

    final isClosed = context.watch<ConfigProvider>().isClosed;

    if (!isClosed) {
      // Schedule navigation and prevent UI build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/start');
      });
      return const SizedBox.shrink(); // Prevents the screen from flashing
    }
    return ChangeNotifierProvider(
      create: (_) {
        final vm = ClosedVM(context.read<ConfigProvider>());
        vm.onExit = () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/config',
            (route) => false,
          );
        };

        return vm;
      },
      child: Consumer<ClosedVM>(
        builder: (context, vm, child) {
          return Scaffold(
            body: Center(
              child: GestureDetector(
                onLongPress: vm.onExit,
                child: Container(
                  width: 0.8.sw,
                  padding: EdgeInsets.only(top: 60.h, bottom: 80.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sorry, we are closed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'VarelaRound',
                          fontSize: 60.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Please come back during our open hours.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.sp, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
