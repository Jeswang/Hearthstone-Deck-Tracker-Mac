#OTWebImage

Asynchronous image downloader with cache support with an NSImageView category

#Usage

```
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:windowContentView.bounds];
    NSString *imageURLString = @"http://p3.music.126.net/xaewG0WYxo0Ry0pw8puIBw==/1907652674296516.jpg";
    [imageView setImageURL:[NSURL URLWithString:imageURLString]];
```

Then the web image will be loaded into `imageView`, like this:

![ScreenShot](https://raw.githubusercontent.com/OpenFibers/OTWebImage/master/ScreenShot1.png "ScreenShot")

#Used libs
[OTFileCacheManager](https://github.com/OpenFibers/OTFileCacheManager "OTFileCacheManager")  
[OTHTTPRequest](https://github.com/OpenFibers/OTHTTPRequest "OTHTTPRequest")

#Lisence
MIT.