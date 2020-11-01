//
//  ZFAudioFileManager.m
//  AudioFile
//
//  Created by 钟凡 on 2020/10/30.
//  Copyright © 2020 钟凡. All rights reserved.
//

#import "ZFAudioFileManager.h"

@interface ZFAudioFileManager()

@property (nonatomic) ExtAudioFileRef fileId;
@property (nonatomic) AudioStreamBasicDescription *inputFormat;
@property (nonatomic) AudioStreamBasicDescription *outputFormat;

@end

@implementation ZFAudioFileManager

- (void)openFile:(NSString *)filePath format:(AudioStreamBasicDescription *)format mode:(ZFFileMode)mode {
    CFURLRef cfurl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath, kCFURLPOSIXPathStyle, false);
    
    if (mode == ZFFileModeRead) {
        _inputFormat = format;
    }
    if (mode == ZFFileModeWrite) {
        _outputFormat = format;
    }
    // 打开文件
    OSStatus result = ExtAudioFileOpenURL(cfurl, &_fileId);
    printf("ExtAudioFileOpenURL result %d \n", result);
    
    // 读取文件格式
    UInt32 propSize = sizeof(AudioStreamBasicDescription);
    result = ExtAudioFileGetProperty(_fileId, kExtAudioFileProperty_FileDataFormat, &propSize, _inputFormat);
    printf("get absd: %d \n", result);
    
    // 设置音频数据格式
//    propSize = sizeof(format);
//    result = ExtAudioFileSetProperty(_fileId, kExtAudioFileProperty_ClientDataFormat, propSize, &format);
//    printf("set absd: %d \n", result);
}
- (void)writeData:(void *)data length:(int)length {
    
}
- (void)readData:(void *)data length:(int)length {
    AudioBufferList ioData = {};
    AudioBuffer buffer = {};
    buffer.mData = data;
    buffer.mDataByteSize = length;
    buffer.mNumberChannels = _inputFormat->mChannelsPerFrame;
    
    ioData.mBuffers[0] = buffer;
    ioData.mNumberBuffers = 1;
    
    UInt32 inNumberFrames = length / _inputFormat->mBytesPerFrame;
    
    OSStatus result = ExtAudioFileRead(_fileId, &inNumberFrames, &ioData);
    printf("ExtAudioFileRead %d \n", result);
}
- (void)closeFile {
    
}

@end
