//
//  ZFAudioFileWriter.m
//  AudioFile
//
//  Created by 钟凡 on 2020/10/31.
//  Copyright © 2020 钟凡. All rights reserved.
//

#import "ZFAudioFileWriter.h"

@interface ZFAudioFileWriter()

@property (nonatomic) ExtAudioFileRef fileId;
@property (nonatomic) AudioStreamBasicDescription fileFormat;
@property (nonatomic) AudioStreamBasicDescription *dataFormat;

@end


@implementation ZFAudioFileWriter

- (void)createFile:(NSString *)filePath type:(AudioFileTypeID)type format:(AudioStreamBasicDescription *)format {
    CFURLRef cfurl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath, kCFURLPOSIXPathStyle, false);
    
    _dataFormat = format;
    
    // 创建文件
    OSStatus result = ExtAudioFileCreateWithURL(cfurl, type, format, NULL, kAudioFileFlags_EraseFile, &_fileId);
    printf("ExtAudioFileCreateWithURL result %d \n", result);
    
    CFRelease(cfurl);
    
    // 设置音频数据格式
    UInt32 propSize = sizeof(AudioStreamBasicDescription);
    result = ExtAudioFileSetProperty(_fileId, kExtAudioFileProperty_ClientDataFormat, propSize, _dataFormat);
    printf("set absd: %d \n", result);
}
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
- (void)closeFile {
    ExtAudioFileDispose(_fileId);
}

@end
