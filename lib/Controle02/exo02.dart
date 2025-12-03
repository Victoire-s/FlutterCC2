import 'package:flutter/material.dart';

class SliderFormField extends FormField<double> {
  SliderFormField({
    Key? key,
    required String label,
    required double min,
    required double max,
    int? divisions,
    double? initialValue,
    FormFieldSetter<double>? onSaved,
    FormFieldValidator<double>? validator,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) : super(
          key: key,
          initialValue: initialValue ?? min,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<double> state) {
            final value = state.value ?? min;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label + valeur actuelle
                Text('$label : ${value.toStringAsFixed(0)}'),

                Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  label: value.toStringAsFixed(0),
                  onChanged: (double newValue) {
                    state.didChange(newValue);
                  },
                ),

                // Message d’erreur du FormField si besoin
                if (state.hasError)
                  Text(
                    state.errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            );
          },
        );
}
