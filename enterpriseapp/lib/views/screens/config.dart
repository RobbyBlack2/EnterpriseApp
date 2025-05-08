import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/providers/settings.dart';
import 'package:enterpriseapp/viewmodels/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider2<
      ConfigProvider,
      SettingsProvider,
      ConfigVM
    >(
      create: (_) => ConfigVM(),
      update: (_, configProvider, settingsProvider, configVM) {
        configVM!.updateProviders(configProvider, settingsProvider);
        configVM.onLoginSuccess = () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/start',
              (route) => false,
            );
          });
        };
        return configVM;
      },

      child: Scaffold(
        appBar: AppBar(title: const Text("Configuration")),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    right: 60,
                    left: 60,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // System Credentials Card
                              Expanded(
                                flex: 1,
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'System Credentials',
                                            style: TextStyle(
                                              fontSize: 48,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Consumer<ConfigVM>(
                                          builder: (context, configVM, child) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                const SizedBox(height: 32),
                                                TextField(
                                                  controller:
                                                      configVM
                                                          .systemIdController,
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText: "System ID",
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                ),
                                                const SizedBox(height: 24),
                                                TextField(
                                                  controller:
                                                      configVM
                                                          .passwordController,
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText: "Password",
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                  obscureText: true,
                                                ),
                                                const SizedBox(height: 24),
                                                TextField(
                                                  controller:
                                                      configVM.urlController,
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText: "Domain",
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                ),
                                                if (configVM.error != null)
                                                  Text(
                                                    configVM.error!,
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),

                                                const SizedBox(height: 24),
                                                ElevatedButton(
                                                  onPressed:
                                                      configVM.loading
                                                          ? null
                                                          : () =>
                                                              configVM.login(),
                                                  style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 16,
                                                          horizontal: 32,
                                                        ),
                                                    backgroundColor:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                  ),
                                                  child:
                                                      configVM.loading
                                                          ? const CircularProgressIndicator(
                                                            color: Colors.white,
                                                          )
                                                          : Text(
                                                            "Update",
                                                            style: TextStyle(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .onPrimary,
                                                              fontSize: 24,
                                                            ),
                                                          ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 32),
                              // Instructions Card
                              Expanded(
                                flex: 1,
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'Instructions',
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 32),
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                '1. Enter your systemid and password.\n'
                                                '2. Press "Login" to retrieve your configuration.\n'
                                                '3. Ensure your System Id and Kiosk Password are correct.\n'
                                                '4. If you encounter any issues, please contact support.',
                                            style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Consumer<ConfigVM>(
                                          builder: (context, vm, child) {
                                            // Ensure the value is always in colorOptions
                                            final selected = vm.colorOptions
                                                .firstWhere(
                                                  (c) =>
                                                      c.toARGB32() ==
                                                      vm.selectedColor
                                                          .toARGB32(),
                                                  orElse:
                                                      () =>
                                                          vm.colorOptions.first,
                                                );
                                            return DropdownButton<Color>(
                                              value: selected,
                                              items:
                                                  vm.colorOptions.map((color) {
                                                    return DropdownMenuItem(
                                                      value: color,
                                                      child: Container(
                                                        width: 24,
                                                        height: 24,
                                                        color: color,
                                                      ),
                                                    );
                                                  }).toList(),
                                              onChanged: (color) {
                                                if (color != null) {
                                                  vm.setSelectedColor(
                                                    color,
                                                    context,
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
