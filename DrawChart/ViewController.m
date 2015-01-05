//
//  ViewController.m
//  DrawChart
//
//  Created by Charles Leo on 15/1/5.
//  Copyright (c) 2015年 Charles Leo. All rights reserved.
//

#import "ViewController.h"
#import "CLLineChartView.h"
#import "CLPlot.h"
@interface ViewController ()
            
@property (strong,nonatomic) CLLineChartView * lineChartView;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"图表例子";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    NSArray* plottingDataValues1 =@[@22, @33, @12, @23,@43, @32,@53, @33, @54,@55, @43];
    NSArray* plottingDataValues2 =@[@24, @23, @22, @20,@53, @22,@33, @33, @54,@58, @43];
    self.lineChartView = [[CLLineChartView alloc]initWithFrame:CGRectMake(0, 150, 320, 249)];
    self.lineChartView.backgroundColor = [UIColor whiteColor];
    self.lineChartView.max = 58;
    self.lineChartView.min = 12;
    
    self.lineChartView.interval = (self.lineChartView.max-self.lineChartView.min)/5;
    
    NSMutableArray* yAxisValues = [@[] mutableCopy];
    for (int i=0; i<6; i++) {
        NSString* str = [NSString stringWithFormat:@"%.2f", self.lineChartView.min+self.lineChartView.interval*i];
        [yAxisValues addObject:str];
    }
    
    self.lineChartView.xAxisValues = @[@"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10", @"11"];
    self.lineChartView.yAxisValues = yAxisValues;
    self.lineChartView.axisLeftLineWidth = 39;
    
    
    CLPlot *plot1 = [[CLPlot alloc] init];
    plot1.plottingValues = plottingDataValues1;
    
    plot1.lineColor = [UIColor blueColor];
    plot1.lineWidth = 0.5;
    
    [self.lineChartView addPlot:plot1];
    
    
    CLPlot *plot2 = [[CLPlot alloc] init];
    
    plot2.plottingValues = plottingDataValues2;
    
    plot2.lineColor = [UIColor redColor];
    plot2.lineWidth = 1;
    
    [self.lineChartView  addPlot:plot2];
    [self.view addSubview:self.lineChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
