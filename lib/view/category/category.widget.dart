import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:krystl/core/extensions/context_extension.dart';
import 'package:krystl/core/extensions/widget_extension.dart';
import 'package:krystl/core/network/firebase_manager.dart';

import '../../product/components/color_picker/colorpicker.dart';
import '../../product/components/color_picker/palette.dart';

/// Created by Balaji Malathi on 5/25/2024 at 19:03.

class CategoryFormWidget extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final Map<String, dynamic> initialValue;

  const CategoryFormWidget({
    super.key,
    required this.formKey,
    required this.initialValue,
  });

  @override
  State<CategoryFormWidget> createState() => _CategoryFormWidgetState();
}

class _CategoryFormWidgetState extends State<CategoryFormWidget> {
  FirestoreService _firestoreService = FirestoreService.instance;

  IconData iconPicked = Icons.shape_line_rounded;
  Color iconPickedColor = Colors.amber;

  @override
  void initState() {
    print(widget.initialValue["icon"]);
    iconPickedColor = Color(widget.initialValue["color"] ?? 0xFFFFB300);
    iconPicked = IconData(widget.initialValue["icon"] ?? 0xf04b6,
        fontFamily: "MaterialIcons");
    super.initState();
  }

  Future<void> _showIconPickerDialog() async {
    var iconPicked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pick an icon',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: IconPicker(),
        );
      },
    );

    if (iconPicked != null) {
      debugPrint('Icon changed to $iconPicked');
      setState(() {
        this.iconPicked = iconPicked["icon"];
        iconPickedColor = Color(iconPicked["color"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFF79747E),
                    borderRadius: BorderRadius.circular(2)),
              ).pa(16),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Add Category',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          _showIconPickerDialog();
                        },
                        icon: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: iconPickedColor.withOpacity(0.2),
                            ),
                            child: Icon(
                              iconPicked,
                              color: iconPickedColor,
                            ).pa(8))),
                    Expanded(
                      child: FormBuilder(
                        key: widget.formKey,
                        initialValue: widget.initialValue,
                        child: FormBuilderTextField(
                          name: "name",
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            fillColor: context.colors.primary,
                          ),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    elevation: 0,
                    backgroundColor: context.colors.primaryContainer,
                    foregroundColor: context.colors.onPrimaryContainer,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    minimumSize: Size(context.width - 32, 48),
                  ),
                  onPressed: () async {
                    if (widget.formKey.currentState?.saveAndValidate() ??
                        false) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      var formVal = widget.formKey.currentState!.value;
                      var dd = {
                        "name": formVal["name"],
                        "icon": iconPicked.codePoint,
                        "color": iconPickedColor.value
                      };

                      if (widget.initialValue["id"] != null) {
                        await _firestoreService
                            .update(
                                '/${FirebaseAuth.instance.currentUser?.uid}/master/category',
                                widget.initialValue["id"],
                                dd)
                            .then((s) {
                          Navigator.pop(context);
                        });
                      } else {
                        await _firestoreService
                            .insert(
                                '/${FirebaseAuth.instance.currentUser?.uid}/master/category',
                                dd)
                            .then((s) {
                          Navigator.pop(context);
                        });
                      }
                      debugPrint(dd.toString());
                    } else {
                      debugPrint(widget.formKey.currentState?.value.toString());
                      debugPrint('validation failed');
                    }
                  },
                  child: Text(
                    widget.initialValue["id"] != null ? "UPDATE" : "ADD",
                    style: context.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700, color: context.colors.onPrimaryContainer),
                  ),
                ).phv(0, 16)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IconPicker extends StatefulWidget {
  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  Color pickerColor = Color(0xffffc100);

  List<IconData> icons = [
    Icons.restaurant,
    Icons.shopping_cart,
    Icons.local_cafe,
    Icons.home,
    Icons.flight,
    Icons.event,
    Icons.account_balance,
    Icons.lightbulb,
    Icons.folder,
    Icons.spa,
    Icons.restaurant_menu,
    Icons.apple,
    Icons.local_drink,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: <Widget>[
        ColorPicker(
          paletteType: PaletteType.hueWheel,
          pickerColor: pickerColor,
          onColorChanged: (Color color) {
            setState(() => pickerColor = color);
          },
        ),
        for (var icon in icons)
          GestureDetector(
            onTap: () => Navigator.pop(
                context, {"icon": icon, "color": pickerColor.value}),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: pickerColor.withOpacity(0.2),
                ),
                child: Icon(
                  icon,
                  color: pickerColor,
                ).pa(8)),
          )
      ],
    );
  }
}
