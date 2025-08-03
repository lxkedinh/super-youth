class Unit {
  String name;
  String id;
  String description;
  int numScenarios;

  // List<String> references;
  // String youtubeLink;

  Unit(
    this.name,
    this.id,
    this.description,
    // this.references,
    // this.youtubeLink,
    this.numScenarios,
  );
}

final List<Unit> units = [
  Unit(
    "Needs and Values",
    "needs-and-values",
    "Helping teens define their needs and values",
    5,
  ),
  Unit(
    "Active Listening",
    "active-listening",
    "Helping teens improve their communication through active listening",
    5,
  ),
  Unit(
    "Conflict Resolution",
    "conflict-resolution",
    "Helping teens peacefully resolve conflicts with others",
    5,
  ),
  Unit(
    "Coping Skills",
    "coping-skills",
    "Helping teens develop healthy coping skills to manage stress and anxiety",
    7,
  ),
  Unit(
    "Maintaining relationships",
    "maintaining-relationships",
    "Helping teens maintain their relationships with friends and family as they grow up",
    7,
  ),
  Unit(
    "Financial Literacy",
    "financial-literacy",
    "Helping teens manage your personal finances",
    7,
  ),
];
