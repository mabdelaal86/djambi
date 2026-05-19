extension NotNullExtension<T> on T {
  R convert<R>(R Function(T e) fun) => fun(this);
}

extension EnumExtension on Enum {
  // capitalize first letter and add space between words
  String get title => name[0].toUpperCase() + name.substring(1).replaceAllMapped(RegExp("[A-Z]"), (m) => " ${m[0]}");
}
