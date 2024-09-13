extension StringExtensions on String? {
  String capitalize() {
    String value = (this ?? "").toLowerCase();
    return value[0].toUpperCase() + value.substring(1);
  }
}