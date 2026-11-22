String roman(int number) {
  const values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
  const numerals = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I'];
  var n = number;
  final out = StringBuffer();
  for (var i = 0; i < values.length; i++) {
    while (n >= values[i]) {
      out.write(numerals[i]);
      n -= values[i];
    }
  }
  return out.isEmpty ? number.toString() : out.toString();
}

