//
//  RootViewController.m
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "MainViewController.h"
#import "DeviceViewItem.h"

// |cls|가 현재 Device에서 동작가능한지 확인하고 가능하면 YES, 아니면 NO를 반환.
// isEnableDevice class method를 이용해서 확인하고 만약 해당 함수가 없다면 
// 기본값 YES를 반환한다.
static BOOL IsEnableDevice(Class cls)
{
    if (cls != nil && [cls respondsToSelector:@selector(isEnableDevice)]) {
        if ([cls isEnableDevice]) {
            return YES;
        }
        
        return NO;
    }
    return cls != nil;
}

@interface MainViewController()

// 주어진 indexPath에 해당하는 view controller class 반환 
- (id) classForIndex:(NSIndexPath*) indexPath;

@end


@implementation MainViewController

@synthesize deviceInfoViewControllers=_deviceInfoViewControllers;
@synthesize deviceCtrlViewControllers=_deviceCtrlViewControllers;

- (void)dealloc
{
    [_deviceInfoViewControllers release];
    [_deviceCtrlViewControllers release];
    [super dealloc];
}

- (void)awakeFromNib
{

    //
    // Device Information Classes
    //
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:10];

    // add memory view controller
    // 교제내의 소스와 다르게 다음과 수정합니다. ( 2012-06-27 )
    // NSClassFromString으로 클래스를 조회하여 객체화하는 방식을 취했는데.
    // 만약 해당 클래스가 없으면 nil이 리턴되고 array에 추가되면 죽을
    // 수 있기 때문에 다음과 같이 리턴값을 확인해서 추가하도록 수점.
    id class = NSClassFromString(@"MemoryInfoViewController");
    if (class) {
        [viewControllers addObject:class];
    }

    // add storage view controller
    class = NSClassFromString(@"StorageInfoViewController");
    if (class) {
        [viewControllers addObject:class];
    }

    // add batter view controller
    class = NSClassFromString(@"BatteryInfoViewController");
    if (class) {
        [viewControllers addObject:class];
    }
    
    // add general view controller
    class = NSClassFromString(@"GeneralInfoViewController");
    if (class) {
        [viewControllers addObject:class];
    }
    
    // add process view controller
    class = NSClassFromString(@"ProcessInfoViewController");
    if (class) {
        [viewControllers addObject:class];
    }
    
    // add network view controller
    class = NSClassFromString(@"NetworkInfoViewController");
    if (class) {
        [viewControllers addObject:class];
    }
    
    self.deviceInfoViewControllers = viewControllers;
    [viewControllers release];
    
    //
    // Device Controller Classes
    //
    viewControllers = [[NSMutableArray alloc] initWithCapacity:10];
    
    // flash control view controller
    class = NSClassFromString(@"TorchViewController");
    if (class && IsEnableDevice(class)) {
        [viewControllers addObject:class];
    }
    
    // gyroscope
    class = NSClassFromString(@"GyroscopeViewController");
    if (class && IsEnableDevice(class)) {
        [viewControllers addObject:class];
    }
    
    // accelerometer
    class = NSClassFromString(@"AccelerometerViewController");
    if (class && IsEnableDevice(class)) {
        [viewControllers addObject:class];
    }

    // compass
    class = NSClassFromString(@"CompassViewController");
    if (class && IsEnableDevice(class)) {
        [viewControllers addObject:class];
    }

    // camera control view controller
    class = NSClassFromString(@"CameraViewController");
    if (class && IsEnableDevice(class)) {
        [viewControllers addObject:class];
    }
    
    // gps view controller
    class = NSClassFromString(@"GpsViewController");
    if (class && IsEnableDevice(class)) {
        [viewControllers addObject:class];
    }

    self.deviceCtrlViewControllers = viewControllers;
    [viewControllers release];
    
}

- (void)viewDidLoad
{
    self.navigationItem.title = @"System Information";
    
    
    [super viewDidLoad];
}

#pragma mark - UITableViewDatasource handler

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Device Information";
            
        case 1:
            return @"Device Check";
            
    }
    return @"";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.deviceInfoViewControllers count];
            
        case 1:
            return [self.deviceCtrlViewControllers count];
    }
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    id item = [self classForIndex:indexPath];
    
    //cell.imageView.image = [item iconImage];
    cell.textLabel.text = [item title];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self classForIndex:indexPath];
    
    // back button title을 "Back"으로 변경.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];

    UIViewController *viewController = [item createViewItem];
    viewController.title = [item title];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


#pragma mark - private method

- (id) classForIndex:(NSIndexPath*) indexPath
{
    id item = nil;
    
    if (indexPath.section == 0) {
        item = [self.deviceInfoViewControllers objectAtIndex:indexPath.row];
    } else
    {
        item = [self.deviceCtrlViewControllers objectAtIndex:indexPath.row];
    }
    
    return item;
}



@end
