//
//  LeftMenuViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import "LeftMenuViewController.h"
#import "Macro.h"
#import "LeftMenuCell.h"
#import "PlistReader.h"
#import "LeftMenuCellModel.h"

#define kLabelHeight 30

@interface LeftMenuViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSArray *identifierArray;

- (void)configureBottomBarButton;
- (void)configureTableView;
@end

@implementation LeftMenuViewController
@synthesize menuTableView = _menuTableView;
@synthesize isLogin = _isLogin;
@synthesize delegate = _delegate;
@synthesize settingButton = _settingButton;
@synthesize infoButton = _infoButton;

@synthesize identifierArray = _identifierArray;
#pragma mark - IBAction
- (IBAction)triggerInfo:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}

- (IBAction)triggerSetting:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}

#pragma mark - Private Method
- (void)configureTableView
{
    self.menuTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenuBg.png"]];
    [self.menuTableView registerNib:[UINib nibWithNibName:@"LeftMenuCell" bundle:nil] forCellReuseIdentifier:kLeftMenuCell];
    
    //TableViewHeader
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMenuDisplayedWidth, kLabelHeight)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"We";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    label.textAlignment = UITextAlignmentCenter;
    self.menuTableView.contentInset = UIEdgeInsetsMake(label.frame.size.height, 0.0f, 0.0f, 0.0f);
    [self.view addSubview:label];
}

- (void)configureBottomBarButton
{
    [self.settingButton setImage:[UIImage imageNamed:@"settings_btn_hl"] forState:UIControlStateSelected];
    [self.infoButton setImage:[UIImage imageNamed:@"info_btn_hl.png"] forState:UIControlStateSelected];
}

#pragma mark - Getter & Setter
- (NSArray *)identifierArray
{
    if (_identifierArray == nil) {
        _identifierArray = [[[PlistReader alloc] init] getLeftMenuResult];
    }
    return _identifierArray;
}

- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    [self.menuTableView reloadData];
}

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [self configureBottomBarButton];
}

- (void)viewDidUnload
{
    [self setMenuTableView:nil];
    [self setSettingButton:nil];
    [self setInfoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.isLogin) {
//        return [self.identifierArray count];
//    } else {
//        return ;
//    }
    return [self.identifierArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftMenuCell] ;
    if (cell == nil) {
        cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLeftMenuCell];
    }
    LeftMenuCellModel *model = (LeftMenuCellModel *)[self.identifierArray objectAtIndex:indexPath.row];
    cell.title.text = model.cellName;
    cell.identifer = model.identifier;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuCell *cell = (LeftMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:cell.identifer];
    [self.delegate changeMiddleContent:controller];
}

@end
