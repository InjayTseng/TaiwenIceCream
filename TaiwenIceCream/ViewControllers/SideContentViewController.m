//
//  SideContentViewController.m
//  TaiwenIceCream
//
//  Created by David Tseng on 2/27/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import "SideContentViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import <Parse/Parse.h>
#import "NSDate+Calculations.h"
#define BACK_TAG 9001

#define SEVEN_ELEVE_TAG 9101
#define FAMILY_MART_TAG 9102

#define VOTE_SEVEN_ELEVE_TAG 9301
#define VOTE_FAMILY_MART_TAG 9302

@interface SideContentViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableDictionary *showDictionary;
@property (strong, nonatomic) IBOutlet UILabel *lb711Popularity;
@property (strong, nonatomic) IBOutlet UILabel *lbFamilyMartPopularity;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIButton *btnReload;

@property (strong, nonatomic) IBOutlet UILabel *lbNextVoteTime;
@end

@implementation SideContentViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSNumber*)isShowWithSiteName:(NSString*)name{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults objectForKey:name];
    if ([defaults objectForKey:name] == nil) {
        return [NSNumber numberWithInt:1];
    }
    return [defaults objectForKey:name];
}

-(void)setSite:(NSString*)siteName withIsShowOnMap:(BOOL)isShow{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isShow] forKey:siteName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)updateLabels{
    self.lb711Popularity.text = [NSString stringWithFormat:@"%d",[[Data sharedManager] sevenPopularity]];
    self.lbFamilyMartPopularity.text = [NSString stringWithFormat:@"%d",[[Data sharedManager] familyPopularity]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabels) name:@"FinishedFetchingData" object:nil];
    
    self.showDictionary  = [[NSMutableDictionary alloc]init];
    [self updateLabels];
    [self.showDictionary setObject:@1 forKey:@"711isShowOnMap"];
    [self.showDictionary setObject:@1 forKey:@"FamilyisShowOnMap"];
    self.lbNextVoteTime.text = @"投票時間: - -";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    
//    return cell;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.sidePanelController showCenterPanelAnimated:YES];
    }
    else if (indexPath.section == 1) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        NSString* siteName;
        siteName = (cell.tag == SEVEN_ELEVE_TAG)?@"711isShowOnMap":@"FamilyisShowOnMap";
        
        BOOL isShowOrNot = TRUE;
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            
            //要show改成不要show
            [self setSite:siteName withIsShowOnMap:NO];
            isShowOrNot = FALSE;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }else if (cell.accessoryType == UITableViewCellAccessoryNone){
            
            //不要show改成要show
            isShowOrNot = TRUE;
            [self setSite:siteName withIsShowOnMap:YES];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        [self.showDictionary setObject:[NSNumber numberWithBool:isShowOrNot] forKey:siteName];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadMapWithDictionary" object:self.showDictionary];
    }
    else if (indexPath.section == 2){
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.tag == VOTE_FAMILY_MART_TAG || cell.tag == VOTE_SEVEN_ELEVE_TAG) {
            
            self.lbNextVoteTime.text = [NSString stringWithFormat:@"過 %@ 可再投",[Data nextVoteTime]];
            
            if ([Data canVote]) {
                if (cell.tag == VOTE_SEVEN_ELEVE_TAG) {
                    
                    [self voteFor711];
                    
                }else if (cell.tag == VOTE_FAMILY_MART_TAG){
                    
                    [self voteForFamilyMart];
                }
                
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"今天已經投票過了喔！"];
            }
            
        }
    }
    
}

-(void)voteFor711{
    
    int current = [self.lb711Popularity.text intValue];
    [self.lb711Popularity setText:[NSString stringWithFormat:@"%d",current+1]];
    [SVProgressHUD showSuccessWithStatus:@"已投票給7-11!"];
    PFQuery *query = [PFQuery queryWithClassName:@"IceCreamShops"];
    [query whereKey:@"name" equalTo:@"7-11"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //EXIST
        for (PFObject *object in objects) {
            
            NSNumber* popularity_count = [object objectForKey:@"popularity"];
            popularity_count = [NSNumber numberWithInt:[popularity_count intValue]+1];
            [object setObject:popularity_count forKey:@"popularity"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                NSLog(@"Success %@ on 7-11.",popularity_count);
            } ];
            
            
        }
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[NSDate date] endOfDay] forKey:@"VoteDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.lbNextVoteTime.text = [NSString stringWithFormat:@"過 %@ 可再投",[Data nextVoteTime]];
}

-(void)voteForFamilyMart{
    
    int current = [self.lbFamilyMartPopularity.text intValue];
    [self.lbFamilyMartPopularity setText:[NSString stringWithFormat:@"%d",current+1]];
    [SVProgressHUD showSuccessWithStatus:@"已投票給Family Mart!"];
    PFQuery *query = [PFQuery queryWithClassName:@"IceCreamShops"];
    [query whereKey:@"name" equalTo:@"FamilyMart"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //EXIST
        for (PFObject *object in objects) {
            
            NSNumber* popularity_count = [object objectForKey:@"popularity"];
            popularity_count = [NSNumber numberWithInt:[popularity_count intValue]+1];
            [object setObject:popularity_count forKey:@"popularity"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                NSLog(@"Success %@ on FamilyMart.",popularity_count);
                
            } ];
        }
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[NSDate date] endOfDay] forKey:@"VoteDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.lbNextVoteTime.text = [NSString stringWithFormat:@"過 %@ 可再投",[Data nextVoteTime]];
}


-(int)getPopularityByName:(NSString*)name{
    
    PFQuery *query = [PFQuery queryWithClassName:@"IceCreamShops"];
    [query whereKey:@"name" equalTo:name];
    NSArray *objects = [query findObjects];
    //EXIST
    for (PFObject *object in objects) {
        
        NSNumber* popularity_count = [object objectForKey:@"popularity"];
        
        return [popularity_count intValue];
    }
    return 0;
}

//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

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

- (IBAction)btnReloadClicked:(id)sender {
    
    [self.activity startAnimating];
    
    [Data fetchDataWithBlock:^{

        [self.activity stopAnimating];
        [SVProgressHUD showSuccessWithStatus:@"已是最新數據"];
    }];
    
}


@end
