//
//  GYProcessView.h
//  ZXTest
//
//  Created by gmy on 2019/11/18.
//  Copyright © 2019 gmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYProcessView : UIView

@property(nonatomic,strong)UIView *pointView;
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
@property(nonatomic,assign)CGRect drawRect;
@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)CAShapeLayer *shapeBGLayer;
@property(nonatomic,assign)NSInteger linwith;
@property(nonatomic,assign)NSInteger progress;

@end

NS_ASSUME_NONNULL_END
