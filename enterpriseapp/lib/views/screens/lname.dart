import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/viewmodels/lname.dart';
import 'package:enterpriseapp/views/widgets/keybaord.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:enterpriseapp/providers/session.dart';

class LastNameScreen extends StatelessWidget {
  const LastNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = LastNameVM(
          context.read<SessionProvider>(),
          context.read<ConfigProvider>(),
        );

        // Set the navigation callback
        vm.nextScreen = () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            String nextScreen = context.read<ConfigProvider>().getNextRoute(
              '/lname',
            );
            Navigator.pushReplacementNamed(context, nextScreen);
          });
        };

        vm.timeOut = () {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushReplacementNamed(context, '/start');
          });
        };

        return vm;
      },
      child: Consumer<LastNameVM>(
        builder: (context, vm, child) {
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  SizedBox(height: 5.h),
                  Text(
                    vm.errorMessage ?? vm.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 70.sp,
                      fontWeight: FontWeight.w900,
                      color:
                          vm.errorMessage != null ? Colors.red : Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        children: [
                          TextField(
                            controller: vm.nameController,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[300],
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0.h,
                              ),
                            ),
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 60.sp,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Expanded(child: Keyboard(onKeyPress: vm.onKeyPress)),
                        ],
                      ),
                    ),
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
