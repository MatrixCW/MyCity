//
//  MCMenuViewController.m
//  MyCity
//
//  Created by Chen Zeyu on 13-7-20.
//
//

#import "MCMenuViewController.h"
#import "ECSlidingViewController.h"
#import "MCGeoLocationViewController.h"

@interface MCMenuViewController ()

@property NSMutableArray *sections;
@property NSMutableArray *systemConfig;
@property NSMutableArray *allAddedGeoLocationCoordinates;

@end

@implementation MCMenuViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.sections = [NSMutableArray array];
    self.systemConfig = [NSMutableArray array];
    self.allAddedGeoLocationCoordinates = [NSMutableArray array];
    
    [self.systemConfig addObject:@"go back to choose region"];
    [self.systemConfig addObject:@"go back to start screen"];
    
    [self.allAddedGeoLocationCoordinates addObject:@"111,222"];
    [self.allAddedGeoLocationCoordinates addObject:@"333,444"];
    [self.allAddedGeoLocationCoordinates addObject:@"555,666"];
    
    [self.sections addObject:self.systemConfig];
    [self.sections addObject:self.allAddedGeoLocationCoordinates];
    
    [self.slidingViewController setAnchorRightRevealAmount:250.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    

    
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
        return self.allAddedGeoLocationCoordinates.count;
    
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
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.allAddedGeoLocationCoordinates objectAtIndex:indexPath.row]];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return @"System config";
    
    return @"Added Coordinates";
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIViewController *newTopViewController;
    NSString *identifier;
    
    if(indexPath.section == 0 && indexPath.row == 1){
        
        [self.slidingViewController.navigationController popToRootViewControllerAnimated:YES];
        return;
        
    }
    
    if(indexPath.section == 1){
      identifier = @"MapPreview";
      newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    else {
        newTopViewController = self.slidingViewController.mainViewController;
        
    }
    
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if(indexPath.section == 1)
        return YES;
    return NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        [self.allAddedGeoLocationCoordinates removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
@end
