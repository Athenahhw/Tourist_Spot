import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '景點人流',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: InstagramFeed(),
    );
  }
}

// 主頁面 - 顯示多個貼文
class InstagramFeed extends StatelessWidget {
  // 貼文資料
  final List<PostData> posts = [
    PostData(
      username: '日月潭',
      imageUrl: 'assets/image/pic1_lake.jpg',//圖片直接寫死
      videoUrl: 'https:',
      caption: '推薦指數：',
    ),
    PostData(
      username: '合歡山武嶺',
      imageUrl: 'assets/image/pic2_parking.jpg',//圖片直接寫死
      videoUrl: 'https:',
      caption: '推薦指數：',
    ),
    PostData(
      username: '玉山',
      imageUrl: 'assets/image/pic3_mountain.jpg',//圖片直接寫死
      videoUrl: 'https:',
      caption: '推薦指數：',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return InstagramPost(postData: posts[index]);
        },
      ),
    );
  }
}
// 貼文資料模型
class PostData {
  final String username;
  final String imageUrl;
  final String videoUrl;
  final String caption;

  PostData({
    required this.username,
    required this.imageUrl,
    required this.videoUrl,
    required this.caption,
  });
}

// 單個貼文元件
class InstagramPost extends StatefulWidget {
  final PostData postData;
  InstagramPost({required this.postData});

  @override
  _InstagramPostState createState() => _InstagramPostState();
}

class _InstagramPostState extends State<InstagramPost> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  VideoPlayerController? _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.network(widget.postData.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });
  }
  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }
  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    if (page == 1) {
      _videoController?.play();
    } else {
      _videoController?.pause();
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.postData.username,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // 圖片/影片區域
        Container(
          width: screenWidth,
          height: screenWidth,
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  // 第一頁：圖片
                  Image.asset(
                    widget.postData.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),

                  // 第二頁：影片
                  Container(
                    color: Colors.black,
                    child: _isInitialized
                        ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_videoController!.value.isPlaying) {
                            _videoController!.pause();
                          } else {
                            _videoController!.play();
                          }
                        });
                      },
                      child: Center(
                        child: AspectRatio(
                          aspectRatio:
                          _videoController!.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(_videoController!),
                              if (!_videoController!.value.isPlaying)
                                Icon(
                                  Icons.play_circle_outline,
                                  size: 64,
                                  color: Colors.white,
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // 推薦指數
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: widget.postData.caption,
                ),
              ],
            ),
          ),
        ),
        // 三個景點分隔線
        SizedBox(height: 12),
        Divider(height: 1, thickness: 0.5),
      ],
    );
  }
}