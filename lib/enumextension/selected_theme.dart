enum SelectedTheme {
  system,
  light,
  dark,
  blue,
}

SelectedTheme getSelectedThemeID(String selectedTheme) {
  switch (selectedTheme) {
    case "light":
      return SelectedTheme.light;
    case 'dark':
      return SelectedTheme.dark;
    case "blue":
      return SelectedTheme.blue;
    default:
      return SelectedTheme.system;
  }
}
