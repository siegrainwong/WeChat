# Fake Wechat

# 简介
仿微信 iOS 客户端，基于 Objective-C 语言及 MVC 框架实现。
此为本人第二个 iOS 项目，第一个项目：[知乎日报](https://github.com/Seanwong933/zhihuDaily)

项目详情可以看我的博客: <a href="https://siegrain.wang/%E5%BC%80%E6%BA%90%E9%A1%B9%E7%9B%AE/wechat-summary/" target="_blank">《仿微信》项目总结</a>
有什么问题希望可以多多交流，顺便求个⭐️~

# 实现功能
1. 聊天（接入图灵机器人 API ，并用 CoreData 存储聊天记录）
2. 通讯录（排序、模糊查询、拼音查询）
3. 发现（朋友圈）

# 项目演示
![1](https://raw.githubusercontent.com/Seanwong933/WeChat/master/Gif/chat_1_chatting.gif)  ![2](https://github.com/Seanwong933/WeChat/blob/master/Gif/chat_2_scroll.gif?raw=true)
![3](https://github.com/Seanwong933/WeChat/blob/master/Gif/moments_1_refresh.gif?raw=true)  ![4](https://github.com/Seanwong933/WeChat/blob/master/Gif/moments_2_photo&expand.gif?raw=true)

# 部分截图
![](http://siegrain.wang/_image/fake%20wechat%20summary/pic1_home.png) ![](http://siegrain.wang/_image/fake%20wechat%20summary/pic2_contact.png)
![](http://siegrain.wang/_image/fake%20wechat%20summary/pic3_moments.jpeg) ![](http://siegrain.wang/_image/fake%20wechat%20summary/pic4_moments2.jpeg)

# 部分技术说明

#### 1. 布局（AutoLayout）
聊天界面用的布局库为 `Masonry+FDTemplateLayoutCell`
后在开发朋友圈时，发现算高插件高度似乎计算有误差，换用 `SDAutoLayout` 进行布局
    
#### 2. 自动回复
接入图灵机器人 API 实现自动回复，仅支持文字回复。
    
#### 3. 聊天记录存储（CoreData）
聊天记录通过 `CoreData` 进行存储，中间使用 `IQDatabaseManager` 帮助类方便操作，并使用 `NSPredicate` 进行筛选。
    
#### 4. 刷新
上下拉刷新均使用 `MJRefresh`

#### 5. 朋友圈菊花
通过扩展 `MJRefresh` 插件实现（事实证明完全没有必要），下拉旋转通过 `CGAffineTransform` 实现，刷新时的转动通过 `CABasicAnimation` 实现
