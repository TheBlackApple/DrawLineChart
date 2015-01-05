//
//  CLLineChartView.h
//  DrawChart
//
//  Created by Charles Leo on 15/1/5.
//  Copyright (c) 2015年 Charles Leo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLPlot;
@interface CLLineChartView : UIView
@property (strong,nonatomic) NSArray * xAxisValues;                 //x轴数组
@property (assign,nonatomic) NSInteger xAxisFontSize;               //x轴字体大小
@property (strong,nonatomic) UIColor * xAxisFontColor;              //x轴字体颜色
@property (assign,nonatomic) NSInteger numberOfVerticalElements;    //垂直方向的元素个数
@property (strong,nonatomic) UIColor * horizontalLinesColor;        //水平方向线条颜色

@property (assign,nonatomic) float max;                             //轴线最大值
@property (assign,nonatomic) float min;                             //轴线最小值
@property (assign,nonatomic) float interval;                        //水平线间隔值
@property (assign,nonatomic) float pointerInterval;                   //x轴点之间的间隔
@property (assign,nonatomic) float axisLineWidth;                   //轴线宽度
@property (assign,nonatomic) float horizontalLineInterval;          //水平线垂直间隔
@property (assign,nonatomic) float horizontalLineWidth;             //水平线宽度
@property (assign,nonatomic) float axisBottomLinetHeight;
@property (assign,nonatomic) float axisLeftLineWidth;
@property (strong,nonatomic) NSString * floatNumberFormatterString;
@property (strong,nonatomic) NSArray * yAxisValues;                 //y轴数值
@property (strong,nonatomic,readonly) NSMutableArray * plots;       //图线个数


- (void) addPlot:(CLPlot *)newPlot;//添加图线的方法

@end
