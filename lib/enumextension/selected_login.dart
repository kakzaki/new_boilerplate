import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum SelectedLogin {
  gmail,
  email,
  phone,
}

extension SelectedLoginExtension on SelectedLogin {
  String get name => describeEnum(this);

  Color get colorFilterGmail {
    switch (this) {
      case SelectedLogin.gmail:
        return Colors.transparent;
      case SelectedLogin.phone:
        return Colors.grey;
      case SelectedLogin.email:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  Color get colorFilterPhone {
    switch (this) {
      case SelectedLogin.gmail:
        return Colors.grey;
      case SelectedLogin.phone:
        return Colors.transparent;
      case SelectedLogin.email:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color get colorFilterEmail {
    switch (this) {
      case SelectedLogin.gmail:
        return Colors.grey;
      case SelectedLogin.phone:
        return Colors.grey;
      case SelectedLogin.email:
        return Colors.transparent;
      default:
        return Colors.grey;
    }
  }

  BlendMode get blendModeGMail {
    switch (this) {
      case SelectedLogin.gmail:
        return BlendMode.color;
      case SelectedLogin.phone:
        return BlendMode.hue;
      case SelectedLogin.email:
        return BlendMode.hue;
      default:
        return BlendMode.color;
    }
  }

  BlendMode get blendModePhone {
    switch (this) {
      case SelectedLogin.gmail:
        return BlendMode.hue;
      case SelectedLogin.phone:
        return BlendMode.color;
      case SelectedLogin.email:
        return BlendMode.hue;
      default:
        return BlendMode.hue;
    }
  }

  BlendMode get blendModeEmail {
    switch (this) {
      case SelectedLogin.gmail:
        return BlendMode.hue;
      case SelectedLogin.phone:
        return BlendMode.hue;
      case SelectedLogin.email:
        return BlendMode.color;
      default:
        return BlendMode.hue;
    }
  }
}

SelectedLogin getRandomSelectedLogin(int index) {
  switch (index) {
    case 0:
      return SelectedLogin.gmail;
    case 1:
      return SelectedLogin.email;
    case 2:
      return SelectedLogin.phone;
    default:
      return SelectedLogin.gmail;
  }
}
