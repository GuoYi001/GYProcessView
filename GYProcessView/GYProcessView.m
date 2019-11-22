//
//  GYProcessView.m
//  ZXTest
//
//  Created by gmy on 2019/11/18.
//  Copyright © 2019 gmy. All rights reserved.
//

#import "GYProcessView.h"

#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]

@implementation GYProcessView

-(instancetype)init
{
    if (self = [super init]) {
        
        self.linwith  = 5;
        [self.layer addSublayer:self.shapeBGLayer];

        [self.layer addSublayer:self.shapeLayer];
        [self addSubview:self.pointView];
        [self.timer fire];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)click
{
    static BOOL  mark = NO;
    if (mark) {
        [self.timer  invalidate];
        self.timer  = nil;
    }
    else
        {
            [self.timer fire];
        }
    
    mark = !mark;

}

-(void)display
{
    
    int r = self.bounds.size.height/2;
    UIBezierPath *path = [UIBezierPath  bezierPath];
    [path moveToPoint:CGPointMake(r,  0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width-r, 0)];
    CGFloat startAngle  =  -M_PI/2;
    CGFloat endAngle = -M_PI/2 + M_PI;
    [path addArcWithCenter:CGPointMake(self.bounds.size.width-r,  r) radius:r startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path moveToPoint:CGPointMake(self.bounds.size.width-r, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(r, self.bounds.size.height )];
    startAngle  =  -M_PI/2 + M_PI;
    endAngle = -M_PI/2 + M_PI + M_PI;
    [path addArcWithCenter:CGPointMake(r, r) radius:r startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.shapeBGLayer.path = path.CGPath;
    


    
    
     CGFloat process = self.progress;
//    process += (100 * 1.0/60);
    
    if (process > 100) {
        process = 0;
    }
    
    path = [UIBezierPath  bezierPath];
    path.lineCapStyle = kCGLineCapButt;
    if (process >= 0) {
        
        CGFloat p = process >= 20 ? 1 : process/20;
         [path moveToPoint:CGPointMake(r,  0)];
         [path addLineToPoint:CGPointMake(r + (self.bounds.size.width-2 * r) * p, 0)];
       
    }
    
    if (process > 20) {
        CGFloat p = process >= 50 ? 1 : (process - 20)/30;
        
        CGFloat startAngle  =  -M_PI/2;
        CGFloat endAngle = -M_PI/2 + M_PI * p;
        [path addArcWithCenter:CGPointMake(self.bounds.size.width-r,  r) radius:r startAngle:startAngle endAngle:endAngle clockwise:YES];
    }
    
    if (process > 50) {
            CGFloat p = process >= 70 ? 1 : (process - 50)/20;
            [path moveToPoint:CGPointMake(self.bounds.size.width-r, self.bounds.size.height)];
            [path addLineToPoint:CGPointMake((self.bounds.size.width - r) - (self.bounds.size.width - 2*r) * p , self.bounds.size.height)];
        }
    
    if (process > 70) {
        CGFloat p =  (process - 70)/30;
        
        CGFloat startAngle  =  -M_PI/2 + M_PI;
        CGFloat endAngle = -M_PI/2 + M_PI + M_PI * p;

        [path addArcWithCenter:CGPointMake(r, r) radius:r startAngle:startAngle endAngle:endAngle clockwise:YES];

    }
    self.shapeLayer.path = path.CGPath;

    self.pointView.center = [self getLastPoint:path];
    
    
}

-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0/60 repeats:YES block:^(NSTimer * _Nonnull timer) {
           
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _shapeLayer.frame = self.bounds;
    _shapeBGLayer.frame = self.bounds;

    
    [self display];
}

-(CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.lineWidth =  self.linwith;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        

    }
    return _shapeLayer;
}

-(CAShapeLayer *)shapeBGLayer
{
    if (!_shapeBGLayer) {
        _shapeBGLayer = [[CAShapeLayer alloc] init];
        _shapeBGLayer.lineWidth =  self.linwith;
        _shapeBGLayer.strokeColor = [UIColor grayColor].CGColor;
        _shapeBGLayer.fillColor = [UIColor clearColor].CGColor;
        
        
    }
    return _shapeBGLayer;
}

-(UIView *)pointView
{
    if (!_pointView) {
        _pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _pointView.backgroundColor = [UIColor blueColor];
        _pointView.layer.cornerRadius = 5;
    }
    return _pointView;
}

-(CGPoint)getLastPoint:(UIBezierPath *)path
{
    NSMutableArray<NSValue *> *points = [NSMutableArray array];
    CGPathApply(path.CGPath, (__bridge void *)points, getPointsFromBezier);
    return [points.lastObject CGPointValue];
}

void getPointsFromBezier(void *info,const CGPathElement *element){
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    if (type != kCGPathElementCloseSubpath) {
        [bezierPoints addObject:VALUE(0)];
        if ((type != kCGPathElementAddLineToPoint) && (type != kCGPathElementMoveToPoint)) {
            [bezierPoints addObject:VALUE(1)];
        }
    }
    
    if (type == kCGPathElementAddCurveToPoint) {
        [bezierPoints addObject:VALUE(2)];
    }
    
}

@end
