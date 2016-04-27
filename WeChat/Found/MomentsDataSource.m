//
//  MomentsDataSource.m
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "Comment.h"
#import "Moment.h"
#import "MomentsDataSource.h"

@implementation MomentsDataSource
- (UIImage*)momentsImage:(NSString*)name
{
    //    NSString* momentsPath = [NSString stringWithFormat:@"%@%@", , @"/moments"];
    NSString* imagePath = [NSString stringWithFormat:@"%@/%@.jpg", [[NSBundle mainBundle] bundlePath], name];
    return [[UIImage alloc] initWithContentsOfFile:imagePath];
}
- (NSString*)randomName
{
    NSArray* namesArray = @[ @"Siegrain Wong", @"Kaiser", @"晓美艳", @"刘北习", @"乔治可撸妮", @"ivanchaos" ];
    return namesArray[arc4random() % namesArray.count];
}
- (NSArray*)moments
{
    NSMutableArray* result = [NSMutableArray array];
    [result addObject:[Moment momentWithContent:@"Blog：http://siegrain.wang\nGithub：https://github.com/Seanwong933\nEmail：siegrain@qq.com\n\n朋友圈数据来自煎蛋网和知乎，侵删，不接受送快递上门服务。"
                                           name:@"Siegrain Wong"
                                       pictures:@[ [UIImage imageNamed:@"siegrain_avatar"] ]
                                       comments:@[]]];

    NSArray* dataArray = @[
        [Moment momentWithContent:@"我跟你们说啊，香港记者就不是吃青春饭的行业。因为在这一行业，太年轻反而是劣势，可能引起被采访人的不悦。"
                             name:@"膜术日报"
                         pictures:@[]
                         comments:@[
                             [Comment commentWithName:@"Kaiser"
                                              content:@"强行膜"],
                             [Comment commentWithName:@"晓美艳"
                                              content:@"应删除「香港」二字，不然将来宣传报道上容易出现偏差。"],
                         ]],

        [Moment momentWithContent:@"心情不好，把朋友圈空间里微商的广告都举报了一下。"
                             name:@"光消失的地方"
                         pictures:@[]
                         comments:@[
                             [Comment commentWithName:@"ivanchaos"
                                              content:@"没用，还是屏蔽吧。"],
                         ]],

        [Moment momentWithContent:@"这几天有点拉肚子，刚才开车在路上突然肚子一阵剧痛……心里一直在安慰自己说这应该是屁，决定赌一把！没想到他妈的赌输了……"
                             name:@"光消失的地方"
                         pictures:@[]
                         comments:@[
                             [Comment commentWithName:@"刘北习"
                                              content:@"赌博想赢要偷看，所以为了赢，在有感觉的时候把手指伸进去探下敌情"],
                         ]],

        [Moment momentWithContent:@"谨以此图向煎蛋两位传奇的老司机致敬。"
                             name:@"0w1"
                         pictures:@[ [self momentsImage:@"laosiji"] ]
                         comments:@[]],

        [Moment momentWithContent:@"华莱士快餐店开业送我的礼物"
                             name:@"汤瑞"
                         pictures:@[ [self momentsImage:@"hualaishi-2"], [self momentsImage:@"hualaishi-1"] ]
                         comments:@[
                             [Comment commentWithName:@"晓美艳"
                                              content:@"卧槽，一颗赛艇！"],
                             [Comment commentWithName:@"乔治可撸妮"
                                              content:@"看来华莱士的后台。。。。。。。。。。。。。。。。。。"],
                             [Comment commentWithName:@"Kaiser"
                                              content:@"看第一张图的时候还以为是假的。。。😑"],
                         ]],

        [Moment momentWithContent:@"1.多旅行，最好能做到西方哪个国家你没去过的水平。\n2.熟悉法律，做一个有责任感的公民，《基本法》是必须的。\n3.精通乐器，夏威夷吉他啊什么的都可以，需要的时候还能自弹自唱一首辣妹子\n4.坚持自我奋斗，把命运把握在自己手里，但是必要时也要考虑历史的行程，不可强求。\n5.要能讲一口流利的英语，要是还能背诵葛底斯堡演讲那就最好不过了。\n6.提高自己的穿衣品味，日常衣着尽量以衬衫为主，裤腰提高是必须的。\n7.最后一点，也是最重要的一条，为人处世要低调，懂得闷声发大财的道理。"
                             name:@"汤瑞"
                         pictures:@[ [self momentsImage:@"jingdizhiwa"] ]
                         comments:@[
                             [Comment commentWithName:@"Siegrain Wong"
                                              content:@"你给我的这几条建议啊 Excited！"],
                             [Comment commentWithName:@"ivanchaos"
                                              content:@"+1s"],

                         ]],

        [Moment momentWithContent:@"俗话说，眼睛是心灵的窗户，所以一般眼镜片能反光的都是高手。\n这方面最厉害的当属柯南同志。\n\n江湖上还有一句话，叫“眯眯眼的都是怪物”。"
                             name:@"Kaiser"
                         pictures:@[
                             [self momentsImage:@"fanguang-1"],
                             [self momentsImage:@"fanguang-2"],
                             [self momentsImage:@"fanguang-3"],
                             [self momentsImage:@"miyan-1"],
                             [self momentsImage:@"miyan-2"],
                             [self momentsImage:@"miyan-3"],
                             [self momentsImage:@"miyan-4"],
                             [self momentsImage:@"miyan-5"],
                             [self momentsImage:@"miyan-6"],
                         ]
                         comments:@[
                             [Comment commentWithName:@"Siegrain Wong"
                                              content:@"强行让鲁鲁修当了眯眯眼。。。"],
                         ]],
        [Moment momentWithContent:@"杰伦大木表情包"
                             name:@"Kaiser"
                         pictures:@[
                             [self momentsImage:@"jf-1"],
                             [self momentsImage:@"jf-2"],
                             [self momentsImage:@"jf-3"],
                             [self momentsImage:@"jf-4"],
                             [self momentsImage:@"jf-5"],
                             [self momentsImage:@"jf-6"],
                             [self momentsImage:@"jf-7"]
                         ]
                         comments:@[
                             [Comment commentWithName:@"乔治可撸妮"
                                              content:@"居然没有求种子的"],
                         ]]
    ];

    [result addObjectsFromArray:[dataArray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                int seed = arc4random_uniform(2);
                if (seed)
                    return NSOrderedDescending;
                else
                    return NSOrderedAscending;
            }]];

    return result;
}
@end
