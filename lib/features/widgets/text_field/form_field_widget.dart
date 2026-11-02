import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormFieldWidget extends StatelessWidget {
  final String? value;
  final Widget child;
  final FormFieldValidator<String>? validator;

  const FormFieldWidget({
    super.key,
    required this.value,
    required this.child,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      key: ValueKey(value),
      validator: validator,
      initialValue: value,
      builder: (FormFieldState<String> state) {
        return Builder(
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                child,
                state.hasError
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        state.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12.0,
                        ),
                      ),
                    )
                    : Container(),
              ],
            );
          },
        );
      },
    );
  }
}
