//
//  PPSNetSpeedTest.h
//  网络速度测试
//
//  Created by 羊谦 on 2017/2/21.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^NetSpeedBlock)(NSString *speed);


@interface PPSNetSpeedTest : NSObject


/**
 下载网速测试
 
 @param callBackBlock 每秒回调，用于实时回传网速
 @param completeBlock 最后测试完成，回调平均网速
 */
- (void)startDownLoadTestWithCallBlock:(NetSpeedBlock)callBackBlock completeBlock:(NetSpeedBlock)completeBlock;

@end
