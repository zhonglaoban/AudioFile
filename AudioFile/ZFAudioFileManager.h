//
//  ZFAudioFileManager.h
//  AudioFile
//
//  Created by 钟凡 on 2020/10/30.
//  Copyright © 2020 钟凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZFFileMode) {
    ZFFileModeRead,
    ZFFileModeWrite,
};

@interface ZFAudioFileManager : NSObject

- (void)openFile:(NSString *)filePath format:(AudioStreamBasicDescription *)format mode:(ZFFileMode)mode;
- (void)writeData:(void *)data length:(int)length;
- (void)readData:(void *)data length:(int)length;
- (void)closeFile;

@end

NS_ASSUME_NONNULL_END
