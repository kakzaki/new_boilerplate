import 'package:intl/intl.dart';

class Waktu {

  late DateTime dateTime;

  static const List<String> _hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  static const List<String> _bulan = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  static const List<String> _kuartal = ['pertama', 'kedua', 'ketiga', 'keempat'];

  Waktu([DateTime? dateTime]) {
    this.dateTime = dateTime ?? DateTime.now();
  }

  String fE() => _hari[dateTime.weekday - 1].substring(0, 3);
  String fEEEE() => _hari[dateTime.weekday - 1];
  String fLLL() => _bulan[dateTime.month - 1].substring(0, 3);
  String fLLLL() => _bulan[dateTime.month - 1];
  String fMMM() => _bulan[dateTime.month - 1].substring(0, 3);
  String fMMMd() => '${dateTime.day.toString()} ${_bulan[dateTime.month - 1].substring(0, 3)}';
  String fMMMEd() => '${_hari[dateTime.weekday - 1].substring(0, 3)}, ${dateTime.day.toString()} ${_bulan[dateTime.month - 1].substring(0, 3)}';
  String fMMMM() => _bulan[dateTime.month - 1];
  String fMMMMd() => '${dateTime.day.toString()} ${_bulan[dateTime.month - 1]}';
  String fMMMMEEEEd() => '${_hari[dateTime.weekday - 1]}, ${dateTime.day.toString()} ${_bulan[dateTime.month - 1]}';
  String fQQQQ() => 'Kuartal ${_kuartal[((dateTime.month - 1) / 3).floor()]}';
  String fyMd() => '${dateTime.day.toString()}/${dateTime.month.toString()}/${dateTime.year.toString()}';
  String fyMEd() => '${_hari[dateTime.weekday - 1].substring(0, 3)}, ${dateTime.day.toString()}/${dateTime.month.toString()}/${dateTime.year.toString()}';
  String fyMMM() => '${_bulan[dateTime.month - 1].substring(0, 3)} ${dateTime.year.toString()}';
  String fyMMMd() => '${dateTime.day.toString()} ${_bulan[dateTime.month - 1].substring(0, 3)} ${dateTime.year.toString()}';
  String fyMMMEd() => '${_hari[dateTime.weekday - 1].substring(0, 3)}, ${dateTime.day.toString()} ${_bulan[dateTime.month - 1].substring(0, 3)} ${dateTime.year.toString()}';
  String fyMMMM() => '${_bulan[dateTime.month - 1]} ${dateTime.year.toString()}';
  String fyMMMMd() => '${dateTime.day.toString()} ${_bulan[dateTime.month - 1]} ${dateTime.year.toString()}';
  String fyMMMMEEEEd() => '${_hari[dateTime.weekday - 1]}, ${dateTime.day.toString()} ${_bulan[dateTime.month - 1]} ${dateTime.year.toString()}';

  String format(String format) {
    format = format.replaceAll('EEEE', "'${fEEEE()}'");
    format = format.replaceAll('E', "'${fE()}'");
    format = format.replaceAll('LLLL', "'${fLLLL()}'");
    format = format.replaceAll('LLL', "'${fLLL()}'");
    format = format.replaceAll('MMMM', "'${fMMMM()}'");
    format = format.replaceAll('MMM', "'${fMMM()}'");

    return DateFormat(format).format(dateTime);
  }
}


class Numerik {

  int number;

  static const List<String> _bilang = ['', 'satu', 'dua', 'tiga', 'empat', 'lima', 'enam', 'tujuh', 'delapan', 'sembilan'];

  Numerik(this.number);

  String _doTerbilang(int number) {
    if (number < 10) return _bilang[number];
    if (number < 20) {
      int modsepuluh = number % 10;
      if (modsepuluh == 0) {
        return 'sepuluh';
      } else if (modsepuluh == 1) {
        return 'sebelas';
      }
      return '${_bilang[modsepuluh]} belas';
    }
    if (number < 100) {
      int divsepuluh = number ~/ 10;
      int modsepuluh = number % 10;
      String result = '${_bilang[divsepuluh]} puluh';
      if (modsepuluh > 0) result = '$result ${_bilang[modsepuluh]}';
      return result;
    }
    if (number < 1000) {
      int divseratus = number ~/ 100;
      int modseratus = number % 100;
      String result = '';
      if (divseratus == 1) {
        result = 'seratus';
      } else {
        result = '${_bilang[divseratus]} ratus';
      }
      if (modseratus > 0) result = '$result ${_doTerbilang(modseratus)}';
      return result;
    }
    if (number < 1000000) {
      int divseribu = number ~/ 1000;
      int modseribu = number % 1000;
      String result = '';
      if (divseribu == 1) {
        result = 'seribu';
      } else {
        result = '${_doTerbilang(divseribu)} ribu';
      }
      if (modseribu > 0) result = '$result ${_doTerbilang(modseribu)}';
      return result;
    }
    if (number < 1000000000) {
      int divjuta = number ~/ 1000000;
      int modjuta = number % 1000000;
      String result = '${_doTerbilang(divjuta)} juta';
      if (modjuta > 0) result = '$result ${_doTerbilang(modjuta)}';
      return result;
    }
    if (number < 1000000000000) {
      int divm = number ~/ 1000000000;
      int modm = number % 1000000000;
      String result = '${_doTerbilang(divm)} milyar';
      if (modm > 0) result = '$result ${_doTerbilang(modm)}';
      return result;
    }
    if (number < 1000000000000000) {
      int divt = number ~/ 1000000000000;
      int modt = number % 1000000000000;
      String result = '${_doTerbilang(divt)} triliun';
      if (modt > 0) result = '$result ${_doTerbilang(modt)}';
      return result;
    }
    return '';
  }

  String terbilang() {
    if (number < 0) throw Exception('Not accept negative number');
    if (number >= 1000000000000000) throw Exception('Out of limit convertion');
    if (number == 0) return 'nol';
    return _doTerbilang(number);
  }
}