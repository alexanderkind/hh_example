mixin TipCentsMixin {
  int get tipInCents;

  double get tip => tipInCents / 100;
}
