//
//  MCMenuViewController.m
//  MyCity
//
//  Created by Chen Zeyu on 13-7-20.
//
//

#import "MCMenuViewController.h"
#import "ECSlidingViewController.h"


@interface MCMenuViewController ()

@property NSMutableArray *sections;
@property NSMutableArray *systemConfig;
@property NSMutableArray *addedAreaNames;

@end

@implementation MCMenuViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.sections = [NSMutableArray array];
    self.systemConfig = [NSMutableArray array];
    
    [self refreshAreaNamesArray];
    

    [self.systemConfig addObject:@"go back to previous view"];
    [self.systemConfig addObject:@"go back to home screen"];
    
    [self.sections addObject:self.systemConfig];
    [self.sections addObject:self.addedAreaNames];
    
    [self.slidingViewController setAnchorRightRevealAmount:250.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    
    [self.MyTableView reloadData];
    

    
}


-(void)refreshAreaNamesArray{
    
    MCGeoLocationViewController *onTopViewController = (MCGeoLocationViewController *)self.slidingViewController.mainViewController;
    self.addedAreaNames = [NSMutableArray arrayWithArray: onTopViewController.formattedCityNameArray];
    [self.MyTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.

    return self.sections.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
   if(section == 0)
        return self.systemConfig.count;
   if(section == 1)
        return self.addedAreaNames.count;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.section == 0)
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.systemConfig objectAtIndex:indexPath.row]];
    else
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.addedAreaNames objectAtIndex:indexPath.row]];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return @"System Config";
    
    return @"Added Areas";
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 1){
            
            [self.slidingViewController.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        else{
            
            UIViewController *newTopViewController = self.slidingViewController.mainViewController;
            [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
                CGRect frame = self.slidingViewController.topViewController.view.frame;
                self.slidingViewController.topViewController = newTopViewController;
                self.slidingViewController.topViewController.view.frame = frame;
                [self.slidingViewController resetTopView];
            }];
            
        }
        
    }
    
       
}


@end
