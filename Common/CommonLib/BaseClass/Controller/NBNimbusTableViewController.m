//
//  NBNimbusTableViewController.m
//  NBChat
//
//  Created by Li Zhiping on 11/26/14.
//  Copyright (c) 2014 Li Zhiping. All rights reserved.
//

#import "NBNimbusTableViewController.h"
#import "XDNibCellObject.h"

@interface NBNimbusTableViewController (){
    
}

@property (strong, nonatomic) NITableViewActions *actions;

@end

@implementation NBNimbusTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self resetActions];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)resetActions{
    self.actions = [[NITableViewActions alloc] initWithTarget:self];
}

//设置数据源, 将数据源设置到TableView的dataSource
- (void)setDataSource:(NIMutableTableViewModel *)dataSource{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        self.tableView.dataSource = _dataSource;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = tableView.rowHeight;
    id object = [(NIMutableTableViewModel *)tableView.dataSource objectAtIndexPath:indexPath];
    Class cellClass = nil;
    if ([object respondsToSelector:@selector(cellClass)]) {
        cellClass = [object cellClass];
    }
    
    if ([object respondsToSelector:@selector(cellClassForHeight)]) {
        cellClass = [object cellClassForHeight];
    }
    
    if ([cellClass respondsToSelector:@selector(heightForObject:atIndexPath:tableView:)]) {
        CGFloat cellHeight = [cellClass heightForObject:object
                                            atIndexPath:indexPath tableView:tableView];
        if (cellHeight > 0) {
            height = cellHeight;
        }
    }
    return height;
}

- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object
{
    return [[self class] tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
}

+ (UITableViewCell *)cellWithClass:(Class)cellClass
                         tableView:(UITableView *)tableView
                            object:(id)object {
    UITableViewCell* cell = nil;
    
    NSString* identifier = NSStringFromClass(cellClass);
    
    if ([cellClass respondsToSelector:@selector(shouldAppendObjectClassToReuseIdentifier)]
        && [cellClass shouldAppendObjectClassToReuseIdentifier]) {
        identifier = [identifier stringByAppendingFormat:@".%@", NSStringFromClass([object class])];
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        UITableViewCellStyle style = UITableViewCellStyleDefault;
        if ([object respondsToSelector:@selector(cellStyle)]) {
            style = [object cellStyle];
        }
        cell = [[cellClass alloc] initWithStyle:style reuseIdentifier:identifier];
    }
    
    // Allow the cell to configure itself with the object's information.
    if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
        [(id<NICell>)cell shouldUpdateCellWithObject:object];
    }
    
    return cell;
}

+ (UITableViewCell *)cellWithNib:(UINib *)cellNib
                       tableView:(UITableView *)tableView
                       indexPath:(NSIndexPath *)indexPath
                          object:(id)object {
    UITableViewCell* cell = nil;
    
    NSString* identifier = NSStringFromClass([object class]);
    if ([object respondsToSelector:@selector(cellIdentify)]) {
        identifier = [object cellIdentify];
    }
    [tableView registerNib:cellNib forCellReuseIdentifier:identifier];
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Allow the cell to configure itself with the object's information.
    if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
        [(id<NICell>)cell shouldUpdateCellWithObject:object];
    }
    
    return cell;
}

+ (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel
                   cellForTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
                         withObject:(id)object {
    UITableViewCell* cell = nil;
    
    // Only NICellObject-conformant objects may pass.
    if ([object respondsToSelector:@selector(cellClass)]) {
        Class cellClass = [object cellClass];
        cell = [self cellWithClass:cellClass tableView:tableView object:object];
        
    } else if ([object respondsToSelector:@selector(cellNib)]) {
        UINib* nib = [object cellNib];
        cell = [self cellWithNib:nib tableView:tableView indexPath:indexPath object:object];
    }
    
    return cell;
}

- (BOOL)tableViewModel:(NIMutableTableViewModel *)tableViewModel
         canEditObject:(id)object
           atIndexPath:(NSIndexPath *)indexPath
           inTableView:(UITableView *)tableView
{
    return NO;
}

- (UITableViewRowAnimation)tableViewModel:(NIMutableTableViewModel *)tableViewModel
              deleteRowAnimationForObject:(NICellObject *)object
                              atIndexPath:(NSIndexPath *)indexPath
                              inTableView:(UITableView *)tableView
{
    return UITableViewRowAnimationNone;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self.actions tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.actions tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.actions tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (void)dealloc{
    self.dataSource = nil;
    self.actions = nil;
    _tableView.dataSource = nil;
}

@end
