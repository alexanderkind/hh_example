import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

class _FormControlHookCreator<T> {
  const _FormControlHookCreator();

  FormControl<String> call({
    String? value,
    List<Validator<dynamic>> validators = const [],
    List<AsyncValidator<dynamic>> asyncValidators = const [],
    int asyncValidatorsDebounceTime = 250,
    bool touched = false,
    bool disabled = false,
  }) {
    return use(_FormControlHook<String>(
      value: value,
      asyncValidators: asyncValidators,
      asyncValidatorsDebounceTime: asyncValidatorsDebounceTime,
      disabled: disabled,
      touched: touched,
      validators: validators,
    ));
  }
}

const useFormControl = _FormControlHookCreator<String>();

class _FormControlHook<T> extends Hook<FormControl<String>> {
  const _FormControlHook({
    this.value,
    this.validators = const [],
    this.asyncValidators = const [],
    this.asyncValidatorsDebounceTime = 250,
    this.touched = false,
    this.disabled = false,
    super.keys,
  });

  final String? value;
  final List<Validator<dynamic>> validators;
  final List<AsyncValidator<dynamic>> asyncValidators;
  final int asyncValidatorsDebounceTime;
  final bool touched;
  final bool disabled;

  @override
  _FormControlHookState<String> createState() {
    return _FormControlHookState();
  }
}

class _FormControlHookState<T> extends HookState<FormControl<String>, _FormControlHook<String>> {
  late final _controller = FormControl<String>(
    value: hook.value,
    asyncValidators: hook.asyncValidators,
    asyncValidatorsDebounceTime: hook.asyncValidatorsDebounceTime,
    disabled: hook.disabled,
    touched: hook.touched,
    validators: hook.validators,
  );

  @override
  FormControl<String> build(BuildContext context) => _controller;

  @override
  void dispose() => _controller.dispose();

  @override
  String get debugLabel => 'useFormControl';
}
