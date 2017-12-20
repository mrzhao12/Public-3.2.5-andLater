//
//  LBBillOfLadingrefuseRecoderViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBillOfLadingrefuseRecoderViewController.h"
#import "LBBillOfLadingAuditRecoderoneTableViewCell.h"
#import "LBBillOfLadingDetailViewController.h"

@interface LBBillOfLadingrefuseRecoderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@end

static NSString *ID = @"LBBillOfLadingAuditRecoderoneTableViewCell";
@implementation LBBillOfLadingrefuseRecoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"订单列表";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableview.estimatedRowHeight = 95;
    _tableview.rowHeight = UITableViewAutomaticDimension;
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    self.tableview.tableFooterView = [UIView new];
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerrefresh];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableview.mj_header = header;
    self.tableview.mj_footer = footer;
    
    [self.tableview.mj_header beginRefreshing];
}

//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
    [self postRequest];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    [self postRequest];
}

- (void)postRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"page"] = @(_page);
    dict[@"type"] = @(0);
    
    [NetworkManager requestPOSTWithURLStr:@"User/getShopOrderLineList" paramDic:dict finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.models removeAllObjects];
            }
            for (NSDictionary *dic in responseObject[@"data"]) {
                LBBillOfLadingModel *model = [LBBillOfLadingModel mj_objectWithKeyValues:dic];
                [self.models addObject:model];
            }
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            if (_refreshType == NO) {
                [self.models removeAllObjects];
            }
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
            
        }
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    } enError:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [MBProgressHUD showError:@"请求数据失败"];
    }];
}

#pragma  UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count == 0 ? 0:self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBBillOfLadingAuditRecoderoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.models[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    LBBillOfLadingDetailViewController *vc=[[LBBillOfLadingDetailViewController alloc]init];
    vc.model = self.models[indexPath.row];
    vc.isbutton = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return UITableViewAutomaticDimension;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}


@end
