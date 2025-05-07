import 'package:enterpriseapp/models/subreason.dart';
import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/providers/session.dart';
import 'package:enterpriseapp/viewmodels/subreason.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubReasonScreen extends StatelessWidget {
  const SubReasonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configProvider = context.read<ConfigProvider>();

    return ChangeNotifierProvider(
      create: (_) {
        final vm = SubReasonVM(context.read<SessionProvider>(), configProvider);

        // Navigation callback
        vm.nextScreen = () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final nextRoute = configProvider.getNextRoute('/subreason');
            Navigator.pushReplacementNamed(context, nextRoute);
          });
        };

        // Timeout callback
        vm.timeOut = () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/submit');
          });
        };

        return vm;
      },
      child: Consumer<SubReasonVM>(
        builder: (context, vm, child) {
          // Prepare a fixed list of 16 slots, each slot is either a SubReason or null
          final List<SubReason?> slots = List<SubReason?>.filled(16, null);
          for (final subreason in vm.subReasons) {
            final idx = (subreason.index) - 1;
            if (idx >= 0 && idx < 16) {
              slots[idx] = subreason;
            }
          }

          // Split into left (0-7) and right (8-15)
          final leftSlots = slots.sublist(0, 8);
          final rightSlots = slots.sublist(8, 16);

          Widget buildColumn(List<SubReason?> slotList) {
            return Expanded(
              child: Column(
                children: List.generate(8, (i) {
                  final subreason = slotList[i];
                  if (subreason != null && subreason.title.isNotEmpty) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => vm.submitScreen(subreason.title),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                subreason.title,
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Spacer();
                  }
                }),
              ),
            );
          }

          return Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          vm.title,
                          style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Row(
                          children: [
                            buildColumn(leftSlots),
                            buildColumn(rightSlots),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
