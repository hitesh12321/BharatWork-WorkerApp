class Onboard {
  final String imagePath;
  final String text1;
  final String text2;

  Onboard({required this.imagePath, required this.text1, required this.text2});
}

List<Onboard> onboard = [
  Onboard(
    imagePath: 'assets/onboard1.png',
    text1: "Search your job",
    text2:
        "Figure out your top five priorities whether it is company culture, salary.",
  ),
  Onboard(
    imagePath: 'assets/onboard2.png',
    text1: "Browse jobs List",
    text2:
        "Our job list includes several industries,so you can find the best job for you . ",
  ),
  Onboard(
    imagePath: 'assets/onboard3.png',
    text1: "Make your Career",
    text2:
        "We help you find your dream job based on your skillset, location , demand .",
  ),
];
