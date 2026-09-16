import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'edutn6_locale';

/// Langue par defaut au premier lancement : arabe (RTL), avec bascule
/// possible vers le francais — persistee pour les lancements suivants.
const defaultLocale = Locale('ar');

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(defaultLocale) {
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    if (stored != null) {
      state = Locale(stored);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }
}

final localeControllerProvider = StateNotifierProvider<LocaleController, Locale>((ref) {
  return LocaleController();
});
