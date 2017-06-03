//
//  ZCXCollectionViewLayout.m
//  ZCXCollectionView
//
//  Created by ZhangCX on 2017/6/3.
//  Copyright © 2017年 ZhangCX. All rights reserved.
//

#import "ZCXCollectionViewLayout.h"

@implementation ZCXCollectionViewLayout

#pragma mark - 懒加载
- (NSMutableDictionary *)maxYDic{
    if (_maxYDic == nil) {
        _maxYDic = [[NSMutableDictionary alloc]init];
    }
    return _maxYDic;
}
- (NSMutableArray *)attributesArray{
    if (_attributesArray == nil) {
        _attributesArray = [[NSMutableArray alloc]init];
    }
    return _attributesArray;
}

#pragma mark - 构造函数
-(instancetype)init{
    if (self = [super init]) {
        self.columnCount = 2;
    }
    return self;
}
-(instancetype)initWithColumnCount:(NSInteger)columnCount{
    if (self = [super init]) {
        self.columnCount = columnCount;
    }
    return self;
}
+ (instancetype)flowLayoutWithColumnCount:(NSInteger)columnCount{
    return [[self alloc]initWithColumnCount:columnCount];
}
#pragma mark - 设置方法
- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset {
    self.columnSpacing = columnSpacing;
    self.rowSpacing = rowSepacing;
    self.sectionInset = sectionInset;
}
#pragma mark - 布局相关
//布局前的准备工作
- (void)prepareLayout{
    for (int i = 0; i < self.columnCount; i++) {
        //初始化保存有最大Y值得字典，有几列就有几个键值对，初始值为上内边距
        self.maxYDic[@(i)] = @(self.sectionInset.top);
    }
    //创建每个item的attributes，并存入数组:
    //根据collectionView获取总共有多少个item
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    //为每一个item创建一个attributes并存入数组
    for (int i = 0; i < itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}
//计算collectionViewContentSize
/* 不能水平滚动，因此contentSize.width = 0，我们只需要计算contentSize.height即可
 
 从字典中找出最长列的最大y值，再加上下面的内边距，即为contentSize.height */

- (CGSize)collectionViewContentSize{
    //假设第0列是最长的那列
    __block NSNumber *maxIndex = @0;
    //遍历字典，找出最长的那一列
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber * key,NSNumber * obj, BOOL * _Nonnull stop) {
        //如果maxColumn列的最大Y值小于obj，则让maxIndex等于obj所属的列
        if ([self.maxYDic[maxIndex] floatValue] < obj.floatValue) {
            maxIndex = key;
        }
    }];
    //collectionView的contentSize.height就等于最长列的最大Y值+下内边距
    return CGSizeMake(0, [self.maxYDic[maxIndex] floatValue] + self.sectionInset.bottom);
}

/* 
 该方法则用来设置每个item的attributes，在这里，我们只需要简单的设置每个item的attributes.frame即可
 
 首先我们必须得知collectionView的尺寸，然后我们根据collectionView的宽度，以及列数、各个间距来计算每个item的宽度
 
 item的宽度 = (collectionView的宽度 - 内边距及列边距) / 列数
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width  ;
    //设置大小item的宽度
    CGFloat bigItemWidth = (collectionViewWidth - self.sectionInset.right * 3) / 2;
    CGFloat smallItemWidth = (bigItemWidth - _columnSpacing) / 2;
    
    CGFloat itemWidth = 0;
    if (indexPath.item == 0 || indexPath.item == 9) {
        itemWidth = bigItemWidth;
    }else{
        itemWidth = smallItemWidth;
    }
    //找出最短的那一列
    __block NSNumber *minIndex = @0 ;
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber * key, NSNumber * obj, BOOL * _Nonnull stop) {
        if ([self.maxYDic[minIndex] floatValue] > obj.floatValue) {
            //当处于第二行并且在列数大于第二列的时候令列归零
            if (indexPath.item == 7) {
                minIndex = @0;
            }else if(indexPath.item == 8){
                minIndex = @1;
            }else{
                minIndex = key;
            }
        }
    }];
    
    CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) *minIndex.integerValue;
    CGFloat itemY = [self.maxYDic[minIndex] floatValue] + self.rowSpacing;
    
    if (indexPath.item > 0 && indexPath.item < 5) {
        itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) *(minIndex.integerValue - 1) + bigItemWidth + self.rowSpacing;
    }else if (indexPath.item == 9) {
        itemX = self.sectionInset.left + (self.columnSpacing + itemWidth);
    }
    
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemWidth);
    //更新字典中的最大Y值
    self.maxYDic[minIndex] = @(CGRectGetMaxY(attributes.frame));
    return attributes;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributesArray;
}

@end
