//
//  ViewController.m
//  AudioFile
//
//  Created by 钟凡 on 2019/11/20.
//  Copyright © 2019 钟凡. All rights reserved.
//

#import "ViewController.h"
#import "ZFAudioFileReader.h"
#import "ZFAudioFileWriter.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic) AudioStreamBasicDescription inputFormat;
@property (nonatomic) AudioStreamBasicDescription outputFormat;

@property (nonatomic, strong) ZFAudioFileReader *fileReader;
@property (nonatomic, strong) ZFAudioFileWriter *fileWriter;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fileReader = [ZFAudioFileReader new];
    _fileWriter = [ZFAudioFileWriter new];
    [self readAndWriteFile];
}
-(void)readAndWriteFile {
    NSString *source1 = [[NSBundle mainBundle] pathForResource:@"DrumsMonoSTP" ofType:@"aif"];
    NSString *source2 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"a.caf"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:source2]) {
        [[NSFileManager defaultManager] createFileAtPath:source2 contents:nil attributes:nil];
    }
    NSLog(@"source1: %@", source1);
    NSLog(@"source2: %@", source2);
    int length = 100000;
    void *buffer = malloc(length);
    AudioStreamBasicDescription dataFormat = {};
    dataFormat.mFormatID = kAudioFormatLinearPCM;
    dataFormat.mSampleRate = 44100;
    dataFormat.mChannelsPerFrame = 1;
    dataFormat.mBitsPerChannel = 16;
    dataFormat.mBytesPerPacket = 1 * sizeof(SInt16);
    dataFormat.mBytesPerFrame = 1 * sizeof(SInt16);
    dataFormat.mFramesPerPacket = 1;
    dataFormat.mFormatFlags = kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsSignedInteger;
    
    [_fileReader openFile:source1 format:&dataFormat];
    [_fileReader readData:buffer length:length];
    [_fileReader closeFile];
    
    [_fileWriter createFile:source2 type:kAudioFileCAFType format:&dataFormat];
    [_fileWriter writeData:buffer length:length];
    [_fileWriter closeFile];
    free(buffer);
}
@end
