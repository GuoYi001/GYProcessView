//
//  ViewController.m
//  GYProcessView
//
//  Created by gmy on 2019/11/18.
//  Copyright © 2019 gmy. All rights reserved.
//

#import "ViewController.h"
#import "GYProcessView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GYProcessView *v  = [[GYProcessView alloc] init];
    v.frame = CGRectMake((self.view.frame.size.width-260)/2, 110 - 45, 260 , 150);
    v.progress = 90;
    [self.view addSubview:v];
}


@end
