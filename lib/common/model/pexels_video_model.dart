/// jacokwu
/// 8/18/21 3:19 PM

class PexelsVideoModel {
  late int id;
  late int width;
  late int height;
  late String url;
  late String image;
  late Null fullRes;
  late List<String> tags;
  late int duration;
  late User user;
  late List<VideoFiles> videoFiles;
  late List<VideoPictures> videoPictures;

  PexelsVideoModel(
      {required this.id,
      required this.width,
      required this.height,
      required this.url,
      required this.image,
      required this.fullRes,
      required this.tags,
      required this.duration,
      required this.user,
      required this.videoFiles,
      required this.videoPictures});

  PexelsVideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
    image = json['image'];
    fullRes = json['full_res'];
    tags = json['tags'].cast<String>();
    duration = json['duration'];
    user = new User.fromJson(json['user']);
    if (json['video_files'] != null) {
      videoFiles = <VideoFiles>[];
      json['video_files'].forEach((v) {
        videoFiles.add(new VideoFiles.fromJson(v));
      });
    }
    if (json['video_pictures'] != null) {
      videoPictures = <VideoPictures>[];
      json['video_pictures'].forEach((v) {
        videoPictures.add(new VideoPictures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['width'] = this.width;
    data['height'] = this.height;
    data['url'] = this.url;
    data['image'] = this.image;
    data['full_res'] = this.fullRes;
    data['tags'] = this.tags;
    data['duration'] = this.duration;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.videoFiles != null) {
      data['video_files'] = this.videoFiles.map((v) => v.toJson()).toList();
    }
    if (this.videoPictures != null) {
      data['video_pictures'] = this.videoPictures.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  late int id;
  late String name;
  late String url;

  User({required this.id, required this.name, required this.url});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class VideoFiles {
  late int id;
  late String quality;
  late String fileType;
  int? width;
  int? height;
  late String link;

  VideoFiles(
      {required this.id, required this.quality, required this.fileType, this.width, this.height, required this.link});

  VideoFiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quality = json['quality'];
    fileType = json['file_type'];
    width = json['width'];
    height = json['height'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quality'] = this.quality;
    data['file_type'] = this.fileType;
    data['width'] = this.width;
    data['height'] = this.height;
    data['link'] = this.link;
    return data;
  }
}

class VideoPictures {
  late int id;
  late String picture;
  late int nr;

  VideoPictures({required this.id, required this.picture, required this.nr});

  VideoPictures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    picture = json['picture'];
    nr = json['nr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['picture'] = this.picture;
    data['nr'] = this.nr;
    return data;
  }
}
