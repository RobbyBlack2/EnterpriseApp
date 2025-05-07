import 'package:enterpriseapp/core/constants/constants.dart';
import 'package:enterpriseapp/main.dart';

import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/providers/settings.dart';
import 'package:enterpriseapp/services/api.dart';
import 'package:enterpriseapp/services/config.dart';
import 'package:enterpriseapp/services/localstorage.dart';
import 'package:flutter/material.dart';

/// Make sure you have a StatefulWidget root (e.g., AppRoot) with updateSeedColor(int colorValue)
/// so this VM can call it to reload the app theme.

class ConfigVM extends ChangeNotifier {
  late final ConfigService _configService;
  final ConfigProvider _configProvider;
  late final SettingsProvider _settingsProvider;
  final apiService = ApiService(baseUrl: Constants.baseUrl);
  late final ConfigService configService = ConfigService(apiService);
  final LocalStorage _localStorage = LocalStorage();
  Color _selectedColor = Colors.blue; // Default

  Color get selectedColor => _selectedColor;

  final List<Color> colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
  ];

  bool _loading = false;
  String? _error;
  String? _system;

  String? get system => _system;

  final TextEditingController systemIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  bool get loading => _loading;
  String? get error => _error;

  static final List<Map<String, String?>> systems = [
    {
      'name': 'Medical Check In',
      'url': 'https://www.medicalcheckin.com/login/webapi_2024.php',
    },
    {
      'name': 'Vet Lobby',
      'url': 'https://www.vetlobby.com/login/webapi_2024.php',
    },
    {
      'name': 'Student Check In',
      'url': 'https://www.studentcheckin.com/login/webapi_2024.php',
    },
    {
      'name': 'Patient Check In',
      'url': 'https://www.patientcheckin.com/login/webapi.php',
    },
  ];

  VoidCallback? onLoginSuccess;

  ConfigVM(this._configProvider, this._settingsProvider) {
    _setFields();
    loadSelectedColor();
  }

  Future<void> _setFields() async {
    systemIdController.text = await _localStorage.getSystemid() ?? '';
    passwordController.text = await _localStorage.getPassword() ?? '';
    urlController.text = await _localStorage.getApiUrl() ?? '';
    notifyListeners();
  }

  /// Call this when the user selects a color in the dropdown.
  /// Pass the BuildContext from the widget so we can find the root state.
  void setSelectedColor(Color color, BuildContext context) {
    _selectedColor = color;
    _localStorage.setSeedColor(color.toARGB32()); // Use .value, not .toARGB32()
    notifyListeners();

    // Reload app theme if possible
    final appRootState = context.findAncestorStateOfType<AppRootState>();
    if (appRootState != null && appRootState.mounted) {
      appRootState.updateSeedColor(color.toARGB32());
    }
  }

  /// Loads the saved color from storage on startup.
  Future<void> loadSelectedColor() async {
    final value = await _localStorage.getSeedColor();
    if (value != null) {
      _selectedColor = Color(value);
      notifyListeners();
    }
  }

  Future<void> login() async {
    _setLoading(true);
    try {
      await _configProvider.getConfig(
        systemIdController.text,
        passwordController.text,
        urlController.text,
      );
      if (_configProvider.error != null) {
        _setError(_configProvider.error);
        return;
      }
      onLoginSuccess?.call();
      notifyListeners();
    } catch (e) {
      _setError('An unexpected error occurred $e');
    } finally {
      _setLoading(false);
    }
  }

  //System Dropdwon in ui
  void setSystem(String? value) {
    _system = value;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  @override
  void dispose() {
    systemIdController.dispose();
    passwordController.dispose();
    urlController.dispose();
    super.dispose();
  }
}
