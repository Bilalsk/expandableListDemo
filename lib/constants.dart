class Constants {
  static final Constants _instance = Constants._internal();
  static const apiURL =
      'http://103.143.46.18:33031/NurtureLearningWebApp2/custom-api/knowledgeFetchApi/loginWise/subject-topics/';

  factory Constants() {
    return _instance;
  }

  Constants._internal();
}
