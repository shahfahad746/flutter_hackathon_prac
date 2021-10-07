class News {
  final String author;
  final String title;
  final String description;
  final String url;
  final String source;
  final String image;
  final String category;
  final String language;
  final String country;
  final String publishedAt;

  News({
    this.author = '',
    this.title = '',
    this.description = '',
    this.url = '',
    this.source = '',
    this.image = null,
    this.category = '',
    this.language = '',
    this.country = '',
    this.publishedAt = '',
  });

  factory News.fromJson(Map<String, dynamic> data) {
    // final List<dynamic> dataBefore = body['data'];
    // final data = dataBefore[0];

    print("data in news >>> $data");
    return News(
      // author: data['author'] ? data['author'] : '',
      title: data['title'],
      description: data['description'],
      // url: data['url'] ? data['url'] : '',
      // source: data['source'] ? data['source'] : '',
      image: data['image'] ?? '',
      // category: data['category'] ? data['category'] : '',
      // language: data['language'] ? data['language'] : '',
      // country: data['country'] ? data['country'] : '',
      // publishedAt: data['published_at'] ? data['published_at'] : '',
    );
  }
}
