
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qutub/screen/sign_up.dart';

import '../controller/language controller.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) onLanguageSelected;

  const LanguageSelectionScreen({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openBottomSheet(context);
      },
      child: ListTile(
        style: ListTileStyle.drawer,
        leading: widget.selectedLanguage == "Uzbek"
            ? const CircleAvatar(
          backgroundImage: AssetImage("assets/UZ.png"),
        )
            : const CircleAvatar(
          backgroundImage: AssetImage("assets/RU.png"),
        ),
        title: Text("change_lang".tr()),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Consumer(
              builder: (ctx, ref, child) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RadioListTile(
                        title: const Text("Uzbek tili"),
                        value: "Uzbek",
                        groupValue: widget.selectedLanguage,
                        onChanged: (value) {
                          widget.onLanguageSelected(value!);
                          context.setLocale(const Locale("uz"));
                          ref.read(langController.notifier).langChanged();
                         // Close the bottom sheet
                        },
                      ),
                      RadioListTile(
                        title: const Text("Russian"),
                        value: "Russian",
                        groupValue: widget.selectedLanguage,
                        onChanged: (value) {
                          widget.onLanguageSelected(value!);
                          context.setLocale(const Locale("ru"));
                          ref.read(langController.notifier).langChanged();
                          // Close the bottom sheet
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  _ParentScreenState createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  String _selectedLanguage = "Russian"; // Def
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    setState(() {
      _selectedLanguage = box.read("selectedLanguage") ?? "Uzbek";
    });
  }

  Future<void> saveSelectedLanguage(String language) async {
    await box.write("selectedLanguage", language);
    if (language == "Uzbek") {
      box.write("language", 'uz');
    } else {
      box.write("language", 'ru');
    }

    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LanguageSelectionScreen(
          selectedLanguage: _selectedLanguage,
          onLanguageSelected: (value) {
            saveSelectedLanguage(value);
          },
        ));
  }
}
