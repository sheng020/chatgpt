# Flutter 开发的高仿ChatGPT界面应用

### 背景
#### ChatGPT在平时工作中算是50%替代Google了，使用中发现几个痛点，这个项目就是为了解决这几个痛点
##### 1.OpenAI对大陆地区IP访问有严格限制，使用时需要翻墙，翻墙会影响正常网页浏览，所以不得不来回开关VPN
##### 2.网页开多了经常找不到Chatgpt的页面，又或者误关页面又要重新登陆
##### 3.时不时要登录一下，麻烦
##### 4.独立应用可以装x

#### 基于上述需求，开发该应用
### Feature
#### 1.支持自定义访问域名，实现免翻墙（一个字，爽）
#### 2.支持免登录
#### 3.同时支持Android，IOS，MACOS，WINDOWS，LINUX，其中移动端还没做屏幕适配

#### 注意事项
##### 出于隐私和安全问题，项目中访问OpenAI的私钥已隐藏，需要配置私钥才能正常工作，下面会说明配置方法

#### 使用方法
#####1.配置参数（必须）：clone 仓库，找到main.dart文件，在main函数中加入如下配置
```dart
void main() async {
  ///这里如果有自己搭建服务器的可以自己设置服务器域名，格式如下：
  ///https://your_client_adress.com
  ///注意最后没有/
  ///没有的话也可以不设置，默认是OpenAI的域名，但是需要翻墙才能访问
  ///OpenAI.baseUrl = "your client address";
  OpenAI.apiKey = "your api key";
  ///...other code
}
```
##### 配置后编译工程即可
#### 编译方法
##### 1.本地安装flutter环境，见 [Flutter环境配置](https://docs.flutter.dev/get-started/install)
##### 2.终端cd到项目根目录，运行Flutter编译，根据不同平台执行不同的编译命令，见[Flutter工程编译](https://docs.flutter.dev/development/platform-integration/desktop)
##### 3.编译后运行对应的可执行文件或者安装包即可

#### 其他说明
##### 工作较忙，不会经常有更新，如果有好的想法或者功能，欢迎issue或pr
### Preview
<p float="left">
  <br/>
  

![ezgif com-crop(1)](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2ZjOTg1YmIzYTE5NmQ3ZDFkMDE4ZjdhZGQ0ZTBjN2U0NTUzY2QzMyZjdD1n/BEqJvejTzBm2o9vXtC/giphy.gif)

 <br/>
  

![ezgif com-crop(1)](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNTFhOWZlMmFlMjE4MzNiYmM3M2IxNjMzOGM3ZDQ2MzZmYjU4NDQ4MiZjdD1n/bw72FdJDxRzrBugDbJ/giphy.gif)

</p>

### Screenshots

<p float="left">
<br/>
  <img src="https://user-images.githubusercontent.com/10207753/220455546-5948d56c-adec-49a3-aee0-05cf64e60e13.png" height="500" />
 <br/>
  <img src="https://user-images.githubusercontent.com/10207753/220456066-fa0035c3-f706-43ce-a7b9-43f9de1b9c1e.png" height="500" />
<br/>
  <br />
</p>

### 参考项目(特别鸣谢) Thanks a lot
#### https://github.com/amirk3321/flutter-chatgpt-clone
#### https://github.com/anasfik/openai
 
### 附关于搭建代理的方法
#### 网上有很多OpenAI的代理搭建的方法，这里推荐一个我在用的，实际使用下来比较流畅，当然只适用于低并发的情况，方法较简单，也不用写代码，step by step即可，按照步骤处理完之后把地址按照上面代码配置的方法设置一下，就可以实现免翻墙了
https://github.com/riba2534/openai-scf-goproxy
https://github.com/easychen/openai-api-proxy/tree/master


