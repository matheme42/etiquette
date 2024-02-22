import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension StringExtensions on String {
  String replaceAllDiacritics() {
    return replaceAllMapped(
      RegExp('[À-ž]'),
          (m) => diacriticsMapping[m.group(0)] ?? '',
    );
  }

  // put here your mapping, this cover chars corresponding to regex [À-ž]
  static const diacriticsMapping = {
    //[À-ÿ]
    'À': 'A',
    'Á': 'A',
    'Â': 'A',
    'Ã': 'A',
    'Ä': 'A',
    'Å': 'A',
    'Æ': 'AE',
    'Ç': 'C',
    'È': 'E',
    'É': 'E',
    'Ê': 'E',
    'Ë': 'E',
    'Ì': 'I',
    'Í': 'I',
    'Î': 'I',
    'Ï': 'I',
    'Ð': 'D',
    'Ñ': 'N',
    'Ò': 'O',
    'Ó': 'O',
    'Ô': 'O',
    'Õ': 'O',
    'Ö': 'O',
    '×': 'x', //math multiplication
    'Ø': 'O',
    'Ù': 'U',
    'Ú': 'U',
    'Û': 'U',
    'Ü': 'U',
    'Ý': 'Y',
    'Þ': 'TH',
    'ß': 'SS',
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ã': 'a',
    'ä': 'a',
    'å': 'a',
    'ǎ': 'a',
    'æ': 'ae',
    'ç': 'c',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    'ì': 'i',
    'í': 'i',
    'î': 'i',
    'ï': 'i',
    'ð': 'd',
    'ñ': 'n',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ö': 'o',
    '÷': ' ', //math division
    'ø': 'o',
    'ù': 'u',
    'ú': 'u',
    'û': 'u',
    'ü': 'u',
    'ý': 'y',
    'þ': 'th',
    'ÿ': 'y',
    //[Ā-ž] EuropeanLatin
    'Ā': 'A',
    'ā': 'a',
    'Ă': 'A',
    'Ą': 'A',
    'ą': 'a',
    'Ć': 'C',
    'ć': 'c',
    'Ĉ': 'C',
    'ĉ': 'c',
    'Ċ': 'C',
    'ċ': 'c',
    'Č': 'C',
    'č': 'c',
    'Ď': 'D',
    'ď': 'd',
    'Đ': 'D',
    'đ': 'd',
    'Ē': 'E',
    'ē': 'e',
    'Ĕ': 'E',
    'ĕ': 'e',
    'Ė': 'E',
    'ė': 'e',
    'Ę': 'E',
    'ę': 'e',
    'Ě': 'E',
    'ě': 'e',
    'Ĝ': 'G',
    'ĝ': 'g',
    'Ğ': 'G',
    'ğ': 'g',
    'Ġ': 'G',
    'ġ': 'g',
    'Ģ': 'G',
    'ģ': 'g',
    'Ĥ': 'H',
    'ĥ': 'h',
    'Ħ': 'H',
    'ħ': 'h',
    'Ĩ': 'I',
    'ĩ': 'i',
    'Ī': 'I',
    'ī': 'i',
    'Ĭ': 'I',
    'ĭ': 'i',
    'Į': 'I',
    'į': 'i',
    'İ': 'I',
    'ı': 'i',
    'Ĳ': 'IJ',
    'ĳ': 'ij',
    'Ĵ': 'J',
    'ĵ': 'j',
    'Ķ': 'K',
    'ķ': 'k',
    'ĸ': 'k',
    'Ĺ': 'L',
    'ĺ': 'l',
    'Ļ': 'L',
    'ļ': 'l',
    'Ľ': 'L',
    'ľ': 'l',
    'Ŀ': 'L',
    'ŀ': 'l',
    'Ł': 'L',
    'ł': 'l',
    'Ń': 'N',
    'ń': 'n',
    'Ņ': 'N',
    'ņ': 'n',
    'Ň': 'N',
    'ň': 'n',
    'ŉ': 'n',
    'Ŋ': 'N',
    'ŋ': 'n',
    'Ō': 'O',
    'ō': 'o',
    'Ŏ': 'O',
    'ŏ': 'o',
    'Ő': 'O',
    'ő': 'o',
    'Œ': 'OE',
    'œ': 'oe',
    'Ŕ': 'R',
    'ŕ': 'r',
    'Ŗ': 'R',
    'ŗ': 'r',
    'Ř': 'R',
    'ř': 'r',
    'Ś': 'S',
    'ś': 's',
    'Ŝ': 'S',
    'ŝ': 's',
    'Ş': 'S',
    'ş': 's',
    'Š': 'S',
    'š': 's',
    'Ţ': 'T',
    'ţ': 't',
    'Ť': 'T',
    'ť': 't',
    'Ŧ': 'T',
    'ŧ': 't',
    'Ũ': 'U',
    'ũ': 'u',
    'Ū': 'U',
    'ū': 'u',
    'Ŭ': 'U',
    'ŭ': 'u',
    'Ů': 'U',
    'ů': 'u',
    'Ű': 'U',
    'ű': 'u',
    'Ų': 'U',
    'ų': 'u',
    'Ŵ': 'W',
    'ŵ': 'w',
    'Ŷ': 'Y',
    'ŷ': 'y',
    'Ÿ': 'Y',
    'Ź': 'Z',
    'ź': 'z',
    'Ż': 'Z',
    'ż': 'z',
    'Ž': 'Z',
    'ž': 'z',
  };
}

extension BoldSubString on Text {
  Text boldSubString(String target) {
    target = target.toLowerCase().replaceAllDiacritics();
    final textSpans = List.empty(growable: true);
    final escapedTarget = RegExp.escape(target);
    final pattern = RegExp(escapedTarget, caseSensitive: false);
    final matches = pattern.allMatches(data!.toLowerCase().replaceAllDiacritics());

    int currentIndex = 0;
    for (final match in matches) {
      final beforeMatch = data!.substring(currentIndex, match.start);
      if (beforeMatch.isNotEmpty) {
        textSpans.add(TextSpan(text: beforeMatch));
      }

      final matchedText = data!.substring(match.start, match.end);
      textSpans.add(
        TextSpan(
          text: matchedText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < data!.length) {
      final remainingText = data!.substring(currentIndex);
      textSpans.add(TextSpan(text: remainingText));
    }

    return Text.rich(
      TextSpan(children: <TextSpan>[...textSpans]),
    );
  }
}