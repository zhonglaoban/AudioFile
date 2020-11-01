//
//  ZFAudioFileWriter.h
//  AudioFile
//
//  Created by 钟凡 on 2020/10/31.
//  Copyright © 2020 钟凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFAudioFileWriter : NSObject

- (void)createFile:(NSString *)filePath type:(AudioFileTypeID)type format:(AudioStreamBasicDescription *)format;
- (void)writeData:(void *)data length:(int)length;
- (void)closeFile;

@end

NS_ASSUME_NONNULL_END
