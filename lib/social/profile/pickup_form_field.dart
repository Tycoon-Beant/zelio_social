import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PickerFormField<T> extends FormField<T> {
  final BuildContext context;
  final Widget? suffix;
  final String hint;
  final Future<T?> Function(T? value) onSelect;

  PickerFormField({
    super.key,
    required this.onSelect,
    required this.context,
    required this.hint,
    this.suffix,
    super.onSaved,
    super.validator,
    super.initialValue,
    bool autovalidate = false,
  }) : super(
          builder: (FormFieldState<T> field) {
            final state = field as _TimePickerState;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  readOnly: true,
                  controller: state.effectiveController,
                  decoration: InputDecoration(
                    hintText: hint,
                    errorText: state.errorText,
                    suffixIcon: suffix,
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 191, 189, 189)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () async {
                    final value = await onSelect(state.value ?? initialValue);
                    state.didChange(value);
                  },
                ),
              ],
            );
          },
        );

  @override
  FormFieldState<T> createState() => _TimePickerState();
}

class _TimePickerState<T> extends FormFieldState<T> {
  late TextEditingController _effectiveController;
  TextEditingController get effectiveController => _effectiveController;

  @override
  void initState() {
    final initialDate = widget.initialValue;
    _effectiveController = TextEditingController.fromValue(
        TextEditingValue(text: formatString(initialDate)));
    super.initState();
    super.setValue(initialDate);
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    effectiveController.text = formatString(value);
  }

  String formatString(T? value) {
    if (value == null) {
      return "";
    }
    if (value is DateTime) {
      return DateFormat("dd/MM/yyyy").format(value);
    }
    if (value is TimeOfDay) {
      return value.format(context);
    }
    return "";
  }

  @override
  void dispose() {
    effectiveController.dispose();
    super.dispose();
  }
}
