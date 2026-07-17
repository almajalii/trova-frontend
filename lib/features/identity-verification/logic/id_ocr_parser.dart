/// Heuristic parser for Jordanian National ID cards.
///
/// We only OCR the Latin-script side of the card (English name + National ID
/// number are both printed in Latin/digits — Arabic OCR was ruled out as too
/// unreliable for the timeline). This takes the raw recognized text lines
/// and guesses which one is the National ID and which one is the name.
///
/// Both fields are nullable because OCR can simply fail to find a good
/// candidate — the caller (ScanIdScreen) is expected to hand the guesses to
/// an editable confirm screen rather than trust them blindly.
///
/// Tuned against real device output. A real card produced lines like:
///   "The Hashemite Kingdom of Jordan"
///   "me: GANA MOH'D HANI AHMAD AL JBOUR ALMAJALI"
///   "U 2000947251"
/// — note the clipped "Na" off "Name:" (common OCR artifact when Arabic
/// text precedes the Latin label) and the apostrophe in "MOH'D". Both of
/// those needed explicit handling below.
class IdOcrParser {
  /// Words that show up as boilerplate card text, not the cardholder's name.
  /// Kept upper-case since we compare against upper-cased lines.
  static const _boilerplateWords = {
    'THE',
    'HASHEMITE',
    'KINGDOM',
    'OF',
    'JORDAN',
    'MINISTRY',
    'INTERIOR',
    'CIVIL',
    'STATUS',
    'PASSPORT',
    'DEPT',
    'DEPARTMENT',
    'IDENTITY',
    'CARD',
    'NATIONAL',
    'ID',
    'NUMBER',
    'NAME',
    'DATE',
    'BIRTH',
    'SEX',
    'M',
    'F',
  };

  /// Matches a run of 9 or 10 digits — the National ID length on Jordanian
  /// cards. Requires a word boundary so it doesn't grab a substring of a
  /// longer number (e.g. part of a barcode/serial).
  static final _nationalIdPattern = RegExp(r'(?<!\d)\d{9,10}(?!\d)');

  /// Strips a leading "label:" prefix — e.g. "Name:" or a clipped OCR
  /// fragment like "me:" — before evaluating the rest of the line as a
  /// name. Only matches short all-letter prefixes so it can't accidentally
  /// eat into an actual name.
  static final _labelPrefix = RegExp(r'^[A-Za-z]{1,15}:\s*');

  /// Matches a line made up of Latin letters, spaces, apostrophes, and
  /// hyphens — names often contain both (e.g. "MOH'D", "AL-RAWI").
  static final _latinLettersOnly = RegExp(r"^[A-Za-z'\-\s]+$");

  static ({String? nationalId, String? fullName}) parse(List<String> lines) {
    final nationalId = _findNationalId(lines);
    final fullName = _findFullName(lines);
    return (nationalId: nationalId, fullName: fullName);
  }

  static String? _findNationalId(List<String> lines) {
    for (final line in lines) {
      final match = _nationalIdPattern.firstMatch(line);
      if (match != null) {
        return match.group(0);
      }
    }
    return null;
  }

  /// Finds the name. First looks for a line with an explicit "label:"
  /// prefix (e.g. "Name:", or a clipped "me:") — every real card tested
  /// had one, and it's a far more reliable signal than guessing among
  /// unlabeled lines. Only falls back to the general "longest run of
  /// name-like lines" heuristic if no labeled line is found at all.
  static String? _findFullName(List<String> lines) {
    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (!_labelPrefix.hasMatch(line)) continue;

      final stripped = line.replaceFirst(_labelPrefix, '').trim();
      if (stripped.isEmpty || !_latinLettersOnly.hasMatch(stripped)) continue;

      final words = stripped.split(RegExp(r'\s+'));
      final isBoilerplate = words.every((w) => _boilerplateWords.contains(w.toUpperCase()));
      if (isBoilerplate) continue;

      return stripped;
    }

    return _findFullNameByLongestRun(lines);
  }

  static String? _findFullNameByLongestRun(List<String> lines) {
    List<String> bestRun = [];
    List<String> currentRun = [];

    // Score by total WORD count across the run, not line count — a single
    // line with a 7-word name must beat a 2-line run of 1-word OCR noise
    // (e.g. garbled fragments like "Jlaliy" / "i" seen in real testing).
    int wordCount(List<String> run) => run.fold(0, (sum, l) => sum + l.split(RegExp(r'\s+')).length);

    void flushRun() {
      final betterByWordCount = wordCount(currentRun) > wordCount(bestRun);
      final betterByLength =
          wordCount(currentRun) == wordCount(bestRun) && currentRun.join(' ').length > bestRun.join(' ').length;
      if (betterByWordCount || betterByLength) {
        bestRun = List.of(currentRun);
      }
      currentRun = [];
    }

    for (final rawLine in lines) {
      var line = rawLine.trim();

      if (line.isEmpty) {
        flushRun();
        continue;
      }

      line = line.replaceFirst(_labelPrefix, '').trim();

      if (line.isEmpty || !_latinLettersOnly.hasMatch(line)) {
        flushRun();
        continue;
      }

      final words = line.split(RegExp(r'\s+'));
      final isBoilerplate = words.every((w) => _boilerplateWords.contains(w.toUpperCase()));
      if (isBoilerplate) {
        flushRun();
        continue;
      }

      currentRun.add(line);
    }
    flushRun();

    if (bestRun.isEmpty) return null;
    return bestRun.join(' ');
  }
}
