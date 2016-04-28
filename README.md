# Fake Wechat

# 简介
仿iOS微信客户端，基于Objective-C语言及MVC框架实现。
此为本人第二个iOS项目，第一个项目：[知乎日报](https://github.com/Seanwong933/zhihuDaily)

Blog: <a href="http://siegrain.wang/" target="_blank">Siegrain.Wang</a>

# 实现功能
1. 聊天（接入图灵机器人API，并用CoreData存储聊天记录）
2. 通讯录（排序、模糊查询、拼音查询）
3. 发现（朋友圈）

# 项目演示
![](http://ww4.sinaimg.cn/mw690/0067hDr2gw1f3ckbs513rg308w0ftnpe.gif)  ![](http://siegrain.wang/_image/fake%20wechat%20summary/chat_2_scroll.gif)
![](http://siegrain.wang/_image/fake%20wechat%20summary/moments_1_refresh.gif) ![](http://ww1.sinaimg.cn/mw690/0067hDr2gw1f3ckfgqv7ug308w0ftx6t.gif)

# 部分截图
![](http://siegrain.wang/_image/fake%20wechat%20summary/pic1_home.png) ![](http://siegrain.wang/_image/fake%20wechat%20summary/pic2_contact.png)
![](http://siegrain.wang/_image/fake%20wechat%20summary/pic3_moments.jpeg) ![](http://siegrain.wang/_image/fake%20wechat%20summary/pic4_moments2.jpeg)

# 部分技术说明
**1. 布局（AutoLayout）**
    聊天界面用的布局库为`Masonry+FDTemplateLayoutCell`
    后在开发朋友圈时，发现算高插件高度计算有误差，换用`SDAutoLayout`进行布局
    
**2. 自动回复**
    接入图灵机器人API实现自动回复，仅支持文字回复。
    
**3. 聊天记录存储（CoreData）**
    聊天记录通过`CoreData`进行存储，中间使用`IQDatabaseManager`帮助类方便操作
    
**4. 刷新**
    上下拉刷新均使用`MJRefresh`，朋友圈下拉刷新通过扩展`MJRefresh`插件实现。
