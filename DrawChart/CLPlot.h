//
//  CLPlot.h
//  DrawChart
//
//  Created by Charles Leo on 15/1/5.
//  Copyright (c) 2015年 Charles Leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CLPlot : NSObject
@property (strong,nonatomic) NSArray * plottingValues;
@property (strong,nonatomic) NSArray * plottingPointsLabels;
@property (strong,nonatomic) UIColor * lineColor;
@property (assign,nonatomic) float lineWidth;
@end
