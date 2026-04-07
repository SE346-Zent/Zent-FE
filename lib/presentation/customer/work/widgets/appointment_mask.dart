import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../presentation/common/core/themes/colors.dart';

class AppointmentInputFormatter extends TextInputFormatter {
  static const String mask = '--:--, --/--/----';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int oldLen = oldValue.text.length;
    final int newLen = newValue.text.length;

    // Keep formatting if set programmatically
    if (oldLen == 0 && newLen > 0) {
      if (newValue.text.length == mask.length) return newValue;
      return TextEditingValue(
        text: mask,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    if (newLen == oldLen) return newValue;

    // Backspace
    if (newLen < oldLen) {
      int cursor = newValue.selection.baseOffset;
      if (cursor < 0) cursor = oldValue.selection.baseOffset - 1;

      String text = oldValue.text;
      int deleteIndex = oldValue.selection.baseOffset - 1;

      if (deleteIndex < 0) return oldValue;
      if (oldValue.selection.baseOffset != oldValue.selection.extentOffset) {
        // Range deleted
        int base = oldValue.selection.start;
        int extent = oldValue.selection.end;
        for (int i = base; i < extent; i++) {
          if (mask[i] == '-') {
            text = text.replaceRange(i, i + 1, '-');
          }
        }
        int targetCursor = base;
        while (targetCursor >= 0 &&
            targetCursor < mask.length &&
            mask[targetCursor] != '-') {
          targetCursor--;
        }
        if (targetCursor < 0) targetCursor = 0;
        return TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: targetCursor),
        );
      }

      // Single char deleted
      if (deleteIndex >= 0 && deleteIndex < mask.length) {
        if (mask[deleteIndex] != '-') {
          while (deleteIndex >= 0 && mask[deleteIndex] != '-') {
            deleteIndex--;
          }
        }

        if (deleteIndex >= 0) {
          text = text.replaceRange(deleteIndex, deleteIndex + 1, '-');
          return TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: deleteIndex),
          );
        }
        return TextEditingValue(
          text: oldValue.text,
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
      return oldValue;
    }

    // Addition
    if (newLen > oldLen) {
      String typed = newValue.text.substring(
        oldValue.selection.baseOffset,
        oldValue.selection.baseOffset + (newLen - oldLen),
      );
      typed = typed.replaceAll(RegExp(r'[^0-9]'), '');
      if (typed.isEmpty) return oldValue;

      List<String> chars = oldValue.text.split('');
      int cursor = oldValue.selection.baseOffset;

      for (int i = 0; i < typed.length; i++) {
        while (cursor < mask.length && mask[cursor] != '-') {
          cursor++;
        }
        if (cursor >= mask.length) break;

        String d = typed[i];

        // Smart Clamping
        if (cursor == 0) {
          if (int.parse(d) > 2) {
            chars[0] = '0';
            cursor = 1;
            chars[1] = d;
            cursor = 3;
            continue;
          } else {
            chars[0] = d;
            cursor = 1;
            continue;
          }
        } else if (cursor == 1) {
          if (chars[0] == '2' && int.parse(d) > 3) {
            chars[1] = '3';
          } else {
            chars[1] = d;
          }
          cursor = 3;
          continue;
        } else if (cursor == 3) {
          if (int.parse(d) > 5) {
            chars[3] = '0';
            cursor = 4;
            chars[4] = d;
            cursor = 7;
            continue;
          } else {
            chars[3] = d;
            cursor = 4;
            continue;
          }
        } else if (cursor == 4) {
          chars[4] = d;
          cursor = 7;
          continue;
        } else if (cursor == 7) {
          if (int.parse(d) > 3) {
            chars[7] = '0';
            cursor = 8;
            chars[8] = d;
            cursor = 10;
            continue;
          } else {
            chars[7] = d;
            cursor = 8;
            continue;
          }
        } else if (cursor == 8) {
          int d1 = chars[7] == '-' ? 0 : int.parse(chars[7]);
          if (d1 == 3 && int.parse(d) > 1) {
            chars[8] = '1';
          } else if (d1 == 0 && d == '0') {
            chars[8] = '1';
          } else {
            chars[8] = d;
          }
          cursor = 10;
          continue;
        } else if (cursor == 10) {
          if (int.parse(d) > 1) {
            chars[10] = '0';
            cursor = 11;
            chars[11] = d;
            cursor = 13;
            continue;
          } else {
            chars[10] = d;
            cursor = 11;
            continue;
          }
        } else if (cursor == 11) {
          int m1 = chars[10] == '-' ? 0 : int.parse(chars[10]);
          if (m1 == 1 && int.parse(d) > 2) {
            chars[11] = '2';
          } else if (m1 == 0 && d == '0') {
            chars[11] = '1';
          } else {
            chars[11] = d;
          }
          cursor = 13;
          continue;
        } else if (cursor >= 13) {
          chars[cursor] = d;
          cursor++;
        }
      }

      // Check max days in month if Day and Month are fully populated
      if (chars[7] != '-' &&
          chars[8] != '-' &&
          chars[10] != '-' &&
          chars[11] != '-') {
        int dd = int.parse(chars[7] + chars[8]);
        int mm = int.parse(chars[10] + chars[11]);
        int yy = 2024; // fallback for leap year checks during partial typing
        if (chars[13] != '-' &&
            chars[14] != '-' &&
            chars[15] != '-' &&
            chars[16] != '-') {
          yy = int.parse(chars[13] + chars[14] + chars[15] + chars[16]);
        }
        int maxD = DateTime(yy, mm + 1, 0).day;
        if (dd > maxD) {
          String md = maxD.toString().padLeft(2, '0');
          chars[7] = md[0];
          chars[8] = md[1];
        }
      }

      String newText = chars.join('');

      // Auto-jump logic
      while (cursor < mask.length && mask[cursor] != '-') {
        cursor++;
      }

      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: cursor),
      );
    }

    return newValue;
  }
}

class AppointmentMaskController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    List<TextSpan> spans = [];
    for (int i = 0; i < text.length; i++) {
      spans.add(
        TextSpan(
          text: text[i],
          style: style?.copyWith(
            color:
                (text[i] == '-' ||
                    text[i] == ':' ||
                    text[i] == '/' ||
                    text[i] == ',' ||
                    text[i] == ' ')
                ? AppColors.secondary300
                : Colors.black,
          ),
        ),
      );
    }
    return TextSpan(style: style, children: spans);
  }
}
