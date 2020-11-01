# AudioUnit中ExtAudioFile的使用

CoreAudio中和读写音频文件有关的有`ExtAudioFile`和`AudioFile`，这里介绍`ExtAudioFile`读写音频文件的相关API和操作。

## 基础知识介绍
### 音频数据格式
`pcm`、`aac`、`opus`等，代表音频的原始数据，是音频的数字信号。
### 文件格式
`aif`、`caf`、`mp3`等，文件存储可以压缩数据进行存储如`mp3`，其中caf是指Core Audio Format，里面可以存储所CoreAudio支持的数据格式。

## 读文件
读文件分为3步：
1. 打开文件
2. 读取数据
3. 关闭文件

### 打开文件
`ExtAudioFile`可以直接设置音频数据格式（`ClientDataFormat`），如果有不同的采样率、数据类型等，它会自动帮我们完成格式转换的过程。
```objc
- (void)openFile:(NSString *)filePath format:(AudioStreamBasicDescription *)format {
    CFURLRef cfurl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath, kCFURLPOSIXPathStyle, false);

    _dataFormat = format;

    // 打开文件
    OSStatus result = ExtAudioFileOpenURL(cfurl, &_fileId);
    printf("ExtAudioFileOpenURL result %d \n", result);

    // 读取文件格式
    UInt32 propSize = sizeof(AudioStreamBasicDescription);
    result = ExtAudioFileGetProperty(_fileId, kExtAudioFileProperty_FileDataFormat, &propSize, &_fileFormat);
    printf("get absd: %d \n", result);

    // 设置音频数据格式
    propSize = sizeof(AudioStreamBasicDescription);
    result = ExtAudioFileSetProperty(_fileId, kExtAudioFileProperty_ClientDataFormat, propSize, _dataFormat);
    printf("set absd: %d \n", result);
}
```
### 读取数据
将数据读到`AudioBufferList`里面，`inNumberFrames`表示音频帧数。
```objc
- (void)readData:(void *)data length:(int)length {
    AudioBufferList ioData = {};
    AudioBuffer buffer = {};
    buffer.mData = data;
    buffer.mDataByteSize = length;
    buffer.mNumberChannels = _dataFormat->mChannelsPerFrame;

    ioData.mBuffers[0] = buffer;
    ioData.mNumberBuffers = 1;

    UInt32 inNumberFrames = length / _dataFormat->mBytesPerFrame;

    OSStatus result = ExtAudioFileRead(_fileId, &inNumberFrames, &ioData);
    printf("ExtAudioFileRead %d \n", result);
}
```
### 关闭文件
使用完需要关闭文件，这是一个好习惯。
```objc
- (void)closeFile {
    ExtAudioFileDispose(_fileId);
}
```

## 写文件
写文件也有3步：
1. 创建文件
需要按文件的类型创建文件。
```objc
- (void)createFile:(NSString *)filePath type:(AudioFileTypeID)type format:(AudioStreamBasicDescription *)format {
    CFURLRef cfurl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath, kCFURLPOSIXPathStyle, false);

    _dataFormat = format;

    // 创建文件
    OSStatus result = ExtAudioFileCreateWithURL(cfurl, type, format, NULL, kAudioFileFlags_EraseFile, &_fileId);
    printf("ExtAudioFileCreateWithURL result %d \n", result);

    // 设置音频数据格式
    UInt32 propSize = sizeof(AudioStreamBasicDescription);
    result = ExtAudioFileSetProperty(_fileId, kExtAudioFileProperty_ClientDataFormat, propSize, _dataFormat);
    printf("set absd: %d \n", result);
}
```
2. 写入数据
写入有两个函数`ExtAudioFileWriteAsync`和`ExtAudioFileWrite`，看名字就知道了，一个是非阻塞的，一个是阻塞的，非阻塞的在关闭文件的时候会写完数据。
```objc
- (void)writeData:(void *)data length:(int)length {
    AudioBufferList ioData = {};
    AudioBuffer buffer = {};
    buffer.mData = data;
    buffer.mDataByteSize = length;
    buffer.mNumberChannels = _dataFormat->mChannelsPerFrame;

    ioData.mBuffers[0] = buffer;
    ioData.mNumberBuffers = 1;

    UInt32 inNumberFrames = length / _dataFormat->mBytesPerFrame;

    OSStatus result = ExtAudioFileWriteAsync(_fileId, inNumberFrames, &ioData);
    printf("ExtAudioFileWriteAsync %d \n", result);
}
```
3. 关闭文件
```objc
- (void)closeFile {
    ExtAudioFileDispose(_fileId);
}
```
