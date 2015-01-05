//
//  CLLineChartView.m
//  DrawChart
//
//  Created by Charles Leo on 15/1/5.
//  Copyright (c) 2015年 Charles Leo. All rights reserved.
//

#import "CLLineChartView.h"
#import "CLPlot.h"
#import <math.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
@interface CLLineChartView()
@property (nonatomic, strong) NSString* fontName;
@property (nonatomic, assign) CGPoint contentScroll;
@end

@implementation CLLineChartView


#define POINT_CIRCLE  6.0f
#define NUMBER_VERTICAL_ELEMENTS (5)
#define HORIZONTAL_LINE_SPACES (40)
#define HORIZONTAL_LINE_WIDTH (0.2)
#define HORIZONTAL_START_LINE (0.17)
#define POINTER_WIDTH_INTERVAL  (50)
#define AXIS_FONT_SIZE    (15)

#define AXIS_BOTTOM_LINE_HEIGHT (30)
#define AXIS_LEFT_LINE_WIDTH (35)

#define FLOAT_NUMBER_FORMATTER_STRING  @"%.2f"

#define DEVICE_WIDTH   (320)

#define AXIX_LINE_WIDTH (0.5)

-(void)commonInit{
    
    self.fontName=@"Helvetica";
    self.numberOfVerticalElements=NUMBER_VERTICAL_ELEMENTS;
    self.xAxisFontColor = [UIColor darkGrayColor];
    self.xAxisFontSize = AXIS_FONT_SIZE;
    self.horizontalLinesColor = [UIColor lightGrayColor];
    
    self.horizontalLineInterval = HORIZONTAL_LINE_SPACES;
    self.horizontalLineWidth = HORIZONTAL_LINE_WIDTH;
    
    self.pointerInterval = POINTER_WIDTH_INTERVAL;
    
    self.axisBottomLinetHeight = AXIS_BOTTOM_LINE_HEIGHT;
    self.axisLeftLineWidth = AXIS_LEFT_LINE_WIDTH;
    self.axisLineWidth = AXIX_LINE_WIDTH;
    
    self.floatNumberFormatterString = FLOAT_NUMBER_FORMATTER_STRING;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)addPlot:(CLPlot *)newPlot;
{
    if(nil == newPlot ) {
        return;
    }
    
    if (newPlot.plottingValues.count ==0) {
        return;
    }
    
    
    if(self.plots == nil){
        _plots = [NSMutableArray array];
    }
    
    [self.plots addObject:newPlot];
    
    [self layoutIfNeeded];
}

-(void)clearPlot{
    if (self.plots) {
        [self.plots removeAllObjects];
    }
}

/**
 *  画图表
 *
 *  @param rect
 */
- (void)drawRect:(CGRect)rect
{
    CGFloat startHeight = self.axisBottomLinetHeight;
    CGFloat startWidth = self.axisLeftLineWidth;
    /**
     *  获取上下文
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    /**
     *  平移变换,沿y轴移动self.bounds.size.height个单位
     */
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    //设置字体和大小
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextSelectFont(context, [self.fontName UTF8String], self.xAxisFontSize, kCGEncodingMacRoman);
    /**
     *  画y轴
     */
    for (int i = 0; i<= self.numberOfVerticalElements; i++) {
        int height = self.horizontalLineInterval * i;
        float verticalLine = height + startHeight - self.contentScroll.y;
        CGContextSetLineWidth(context, self.horizontalLineWidth);
        [self.horizontalLinesColor set];
        //设置线段起始点
        CGContextMoveToPoint(context, startWidth, verticalLine);
        //设置线段终点
        CGContextAddLineToPoint(context, self.bounds.size.width, verticalLine);
        //绘制图形
        CGContextStrokePath(context);
        NSNumber * yAxisValue = [self.yAxisValues objectAtIndex:i];
        NSString * numberString = [NSString stringWithFormat:self.floatNumberFormatterString,yAxisValue.floatValue];
        NSInteger count = [numberString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        CGContextShowTextAtPoint(context, 0, verticalLine - self.xAxisFontSize / 2, [numberString UTF8String], count);
    }
    /**
     *  画线
     */
    for (int i = 0; i<self.plots.count; i++)
    {
        CLPlot * plot = [self.plots objectAtIndex:i];
        [plot.lineColor set];
        CGContextSetLineWidth(context, plot.lineWidth);
        NSArray * pointArray = plot.plottingValues;
        //画线
        for (int i = 0 ; i< pointArray.count; i++)
        {
            NSNumber * value = [pointArray objectAtIndex:i];
            float floatValue = value.floatValue;
            float height = (floatValue - self.min)/self.interval* self.horizontalLineInterval-self.contentScroll.y + startHeight;
            float width = self.pointerInterval * (i+ 1)+ self.contentScroll.x + startHeight + 5;
            if (width < startWidth)
            {
                NSNumber * nextValue = [pointArray objectAtIndex:i+1];
                float nextFloatValue = nextValue.floatValue;
                float nextHeight = (nextFloatValue - self.min)/self.interval * self.horizontalLineInterval + startHeight;
                CGContextMoveToPoint(context, startWidth, nextHeight);
                continue;
            }
            
            if (i == 0)
            {
                //起始点
                CGContextMoveToPoint(context, width, height);
            }
            else
            {
                CGContextAddLineToPoint(context, width, height);
            }
        }
        CGContextStrokePath(context);
        
        
        //画点
        for (int i = 0; i<pointArray.count; i++) {
            NSNumber* value = [pointArray objectAtIndex:i];
            float floatValue = value.floatValue;
            
            float height = (floatValue-self.min)/self.interval*self.horizontalLineInterval-self.contentScroll.y+startHeight;
            float width =self.pointerInterval*(i+1)+self.contentScroll.x+ startWidth;
            
            if (width>startWidth){
                CGContextFillEllipseInRect(context, CGRectMake(width-POINT_CIRCLE, height-POINT_CIRCLE/2, POINT_CIRCLE, POINT_CIRCLE));
            }
        }
         CGContextStrokePath(context);
    }
    
    [self.xAxisFontColor set];
    CGContextSetLineWidth(context, self.axisLineWidth);
    CGContextMoveToPoint(context, startWidth, startHeight);
    
    CGContextAddLineToPoint(context, startWidth, self.bounds.size.height);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, startWidth, startHeight);
    CGContextAddLineToPoint(context, self.bounds.size.width, startHeight);
    CGContextStrokePath(context);
    
    // x axis text
    for (int i=0; i<self.xAxisValues.count; i++) {
        float width =self.pointerInterval*(i+1)+self.contentScroll.x+ startHeight;
        float height = self.xAxisFontSize;
        
        if (width<startWidth) {
            continue;
        }
        
        
        NSInteger count = [[self.xAxisValues objectAtIndex:i] lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        CGContextShowTextAtPoint(context, width, height, [[self.xAxisValues objectAtIndex:i] UTF8String], count);
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation=[[touches anyObject] locationInView:self];
    CGPoint prevouseLocation=[[touches anyObject] previousLocationInView:self];
    float xDiffrance=touchLocation.x-prevouseLocation.x;
    float yDiffrance=touchLocation.y-prevouseLocation.y;
    
    _contentScroll.x+=xDiffrance;
    _contentScroll.y+=yDiffrance;
    
    if (_contentScroll.x >0) {
        _contentScroll.x=0;
    }
    
    if(_contentScroll.y<0){
        _contentScroll.y=0;
    }
    
    if (-_contentScroll.x>(self.pointerInterval*(self.xAxisValues.count +3)-DEVICE_WIDTH)) {
        _contentScroll.x=-(self.pointerInterval*(self.xAxisValues.count +3)-DEVICE_WIDTH);
    }
    
    if (_contentScroll.y>self.frame.size.height/2) {
        _contentScroll.y=self.frame.size.height/2;
    }
    _contentScroll.y =0;// close the move up
    
    [self setNeedsDisplay];
}


@end
