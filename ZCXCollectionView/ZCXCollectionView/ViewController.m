//
//  ViewController.m
//  ZCXCollectionView
//
//  Created by ZhangCX on 2017/6/2.
//  Copyright © 2017年 ZhangCX. All rights reserved.
//

#import "ViewController.h"
#import "ZCXCollectionViewLayout.h"

@interface ViewController ()<UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZCXCollectionViewLayout *layout = [ZCXCollectionViewLayout flowLayoutWithColumnCount:3];
    [layout setColumnSpacing:5 rowSpacing:5 sectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    /* 创建collectionView */
    self.collectionView = [[UICollectionView alloc ]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor blueColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView ];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
