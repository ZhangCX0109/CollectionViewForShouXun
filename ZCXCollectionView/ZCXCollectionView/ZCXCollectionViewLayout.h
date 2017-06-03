//
//  ZCXCollectionViewLayout.h
//  ZCXCollectionView
//
//  Created by ZhangCX on 2017/6/3.
//  Copyright © 2017年 ZhangCX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCXCollectionViewLayout : UICollectionViewLayout
//总列数
@property (nonatomic, assign) NSInteger columnCount;
//列间距
@property (nonatomic, assign) NSInteger columnSpacing;
//行间距
@property (nonatomic, assign) NSInteger rowSpacing;
//section到collectionView的边距
@property (nonatomic, assign) UIEdgeInsets sectionInset;
//保存每一列最大y值的数组
@property (nonatomic, strong) NSMutableDictionary *maxYDic;
//保存每一个item的attributes的数组
@property (nonatomic, strong) NSMutableArray *attributesArray;

- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset;


#pragma mark- 构造方法
+ (instancetype)flowLayoutWithColumnCount:(NSInteger)columnCount;
- (instancetype)initWithColumnCount:(NSInteger)columnCount;
@end
