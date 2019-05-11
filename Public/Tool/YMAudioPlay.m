//
//  YMAudioPlay.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/8/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAudioPlay.h"
#import <AVFoundation/AVFoundation.h>

static id _instance = nil;

@implementation YMAudioPlay
//声明单例方法
+ (instancetype)shareInstance
{
    return [[self alloc]init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
+(void)playAudio:(NSString *)str
{
    //语音播报
    AVSpeechUtterance * utterance = [AVSpeechUtterance speechUtteranceWithString:str];
    
    utterance.pitchMultiplier=0.8;
    
    //中式发音
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-TW"];
    
    utterance.voice = voice;
    
    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    
    [synth speakUtterance:utterance];
  
}
@end
