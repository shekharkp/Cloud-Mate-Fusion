class Videos
{
  String videoId;
  String title;
  String imagePath;
  String content;
  String videoLink;

  Videos(this.videoId, this.title, this.imagePath,
      this.content,this.videoLink);

  toJson()
  {
    return
      {
        "videoId" : videoId,
        "title" : title,
        "imagePath" : imagePath,
        "content" : content,
        "videoLink" : videoLink
      };
  }

}