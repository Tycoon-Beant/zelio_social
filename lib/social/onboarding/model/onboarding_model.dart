class OnboardingModel {
  String image;

  String description;
  String subDescription;

  OnboardingModel(
      {required this.image,
      required this.description,
      required this.subDescription});   
}

List<OnboardingModel> contents = [
  OnboardingModel(image: "assets/social_media/onbording1.png", description: "We Connect People", subDescription: "Connecting people trough one platform to share the memories together."),

  OnboardingModel(image: "assets/social_media/onboarding2.png", description: "Sharing Happiness", subDescription: "Sharing happiness by sharing your memories in Zelio platform."),

  OnboardingModel(image: "assets/social_media/onboarding3.png", description: "Last Long Memories", subDescription: "You can store memories of your photos in Zelio app without limit.")
];