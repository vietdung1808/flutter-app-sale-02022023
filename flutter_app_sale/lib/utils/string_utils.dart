class StringUtils {
  static bool isNotEmpty(List<String> data) {
    for (int i = 0; i < data.length; i++){
      if (data[i].isEmpty) {
        return false;
      }
    }
    return true;
  }
}