class MarketplaceReview {
  final String id;
  final String beanId;
  final String authorName;
  final int rating; // 1 to 5
  final String brewMethod;
  final String comment;
  final String createdAtLabel;

  const MarketplaceReview({
    required this.id,
    required this.beanId,
    required this.authorName,
    required this.rating,
    required this.brewMethod,
    required this.comment,
    required this.createdAtLabel,
  });

  Map<String, dynamic> toParseJson() {
    return {
      'beanId': beanId,
      'authorName': authorName,
      'rating': rating,
      'brewMethod': brewMethod,
      'comment': comment,
      'createdAtLabel': createdAtLabel,
    };
  }
}
