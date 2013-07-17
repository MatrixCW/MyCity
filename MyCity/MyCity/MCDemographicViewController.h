//
//  MCDemographicViewController.h
//  MyCity
//
//  Created by Chen Zeyu on 13-7-17.
//
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
@interface MCDemographicViewController : UIViewController<XYPieChartDataSource, XYPieChartDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cityNameTag;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property NSString *currentCityName;
@property NSInteger mode;
- (void)setCityName:(NSString *)name;
@end
