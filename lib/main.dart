import 'package:flutter/material.dart';

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

class InstagramFeed extends StatelessWidget {
  // 貼文資料
  final List<PostData> posts = [
    PostData(
      username: '日月潭',
      imageUrl: 'assets/image/pic1_lake.jpg',
      realtimeUrl: 'assets/image/realtime1.jpg', // 即時影像照片
      caption: '推薦指數：',
    ),
    PostData(
      username: '合歡山武嶺',
      imageUrl: 'assets/image/pic2_parking.jpg',
      realtimeUrl:'assets/image/realtime2.jpg', // 即時影像照片
      caption: '推薦指數：',
    ),
    PostData(
      username: '玉山',
      imageUrl: 'assets/image/pic3_mountain.jpg',
      realtimeUrl: 'assets/image/realtime3.jpg', // 即時影像照片
      caption: '推薦指數：',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return InstagramPost(postData: posts[index]);
          },
        ),
      ),
    );
  }
}

// 貼文資料模型
class PostData {
  final String username;
  final String imageUrl;
  final String realtimeUrl; // 即時影像的照片路徑
  final String caption;

  PostData({
    required this.username,
    required this.imageUrl,
    required this.realtimeUrl,
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 景點名稱
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                size: 20,
                color: Colors.red,
              ),
              SizedBox(width: 8),
              Text(
                widget.postData.username,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // 圖片區域（兩張照片）
        Container(
          width: screenWidth,
          height: screenWidth,
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  // 第一頁：景點照片
                  Image.asset(
                    widget.postData.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image,
                                  size: 64, color: Colors.grey[600]),
                              SizedBox(height: 8),
                              Text(
                                '圖片載入失敗',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // 第二頁：即時影像照片
                  Image.asset(
                    widget.postData.realtimeUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image,
                                  size: 64, color: Colors.grey[600]),
                              SizedBox(height: 8),
                              Text(
                                '即時影像載入失敗',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // 頁面指示器
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    2,
                        (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      width: (screenWidth - 16) / 2 - 6,
                      height: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),

              // 頁面標籤（可選）
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _currentPage == 0 ? '景點照片' : '即時影像',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 推薦指數
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.thumb_up,
                size: 18,
                color: Colors.blue,
              ),
              SizedBox(width: 8),
              Text(
                widget.postData.caption,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // 分隔線
        Divider(height: 1, thickness: 0.5),
      ],
    );
  }
}