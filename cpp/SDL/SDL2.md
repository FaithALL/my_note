## SDL2

> [官方文档](https://wiki.libsdl.org/)

* [开始和结束](#开始和结束)
* [窗口](#窗口)
* [渲染器](#渲染器)
* [Surface](#Surface)
* [纹理](#纹理)
* [渲染纹理](#渲染纹理)
* [几何绘制](#几何绘制)
* [事件](#事件)
* [音频](#音频)

### 开始和结束

* 用flags初始化SDL子系统

  ```c
  int SDL_Init(Uint32 flags);
  ```

  * flags：`SDL_INIT_VIDEO`、`SDL_INIT_EVENTS`、`SDL_INIT_AUDIO`、`SDL_INIT_EVERYTHING`等

* 清除所有SDL子系统

  ```c
  void SDL_Quit();
  ```

### 窗口

* 创建窗口

  ```c
  SDL_Window* SDL_CreateWindow(const char* title, int x， int y,
                              int w, int h, Uint32 flags);
  ```
  
  * x和y常用的宏：`SDL_WINDOWPOS_CENTERED`、`SDL_WINDOWPOS_UNDEFINED`。
  * flags：`SDL_WINDOW_FULLSCREEN`、`SDL_WINDOW_BORDERLESS`、`SDL_WINDOW_RESIZABLE`等
  
* 销毁窗口

  ```c
  void SDL_DestroyWindow(SDL_Window* window);
  ```

### 渲染器

* 创建渲染器

  ```c
  SDL_Renderer* SDL_CreateRenderer(SDL_Window* window, int index, Uint32 flags);
  ```

  * index指定渲染器的驱动，常用-1，表示第一个可用的驱动
  * flags：`SDL_RENDERER_SOFTWARE`、`SDL_RENDERER_ACCELERATED`

* 销毁渲染器

  ```c
  void SDL_DestroyRenderer(SDL_Renderer* renderer);
  ```

### Surface

* 载入bmp图片为surface

  ```c
  SDL_Surface* SDL_LoadBMP(const char* file);
  ```

* 保存surface到bmp图片

  ```c
  int SDL_SaveBMP(SDL_Surface* surface, const char* file);
  ```

* 释放surface

  ```c
  void SDL_FreSurface(SDL_Surface* surface);
  ```

### 纹理

* 从Surface创建纹理

  ```c
  SDL_Texture* SDL_CreateTextureFromSurface(SDL_Renderer* renderer, SDL_Surface* surface);
  ```

* 创建纹理

  ```c
  SDL_Texture* SDL_CreateTexture(SDL_Renderer* renderer, Uint32 format
                                int access, int w, int h);
  ```

  * format是像素格式的枚举，如`SDL_PIXELFORMAT_RGB888`和`SDL_PIXELFORMAT_IYUV`。
  * access是纹理访问模式的枚举，如`SDL_TEXTUREACCESS_STATIC`和`SDL_TEXTUREACCESS_STREAMING`。

* 用像素数据更新纹理区域

  ```c
  int SDL_UpdateTexture(SDL_Texture* texture, const SDL_Rect* rect, 
                        const void* pixels, int pitch);
  ```
  
  * pixels是纹理的裸像素数据。
  * pitch是一行像素数据的字节数，包括行间填充。
  
* 销毁纹理

  ```c
  void SDL_DestroyTexture(SDL_Texture* texture);
  ```

### 渲染纹理

* 设置渲染器的画笔颜色

  ```c
  int SDL_SetRenderDrawColor(SDL_Renderer* renderer, Uint8 r,
                            Uint8 g, Uint8 b, Uint8 a);
  ```

* 清空渲染器的内容，设置屏幕颜色为画笔颜色

  ```c
  int SDL_RenderClear(SDL_Renderer* renderer);
  ```

* 将纹理中的部分内容复制到渲染目标中

  ```c
  int SDL_RenderCopy(SDL_Renderer* renderer, SDL_Texture* texture,
                    const SDL_Rect* srcrect, const SDL_Rect* dstrect);
  ```

  * 复制过程中，纹理将和目标区域的内容混合在一起，混合的模式可以通过调用`SDL_SetTextureBlendMode`进行设置。
  * 纹理的颜色值在混合之前将根据颜色调制模式进行调制。调制模式可以通过调用`SDL_SetTextureColorMod`进行设置。
  * 纹理的alpha值在混合之前将根据alpha调制模式进行调制。调制模式可以通过调用函数`SDL_SetTextureAlphaMod`进行设置。

* 呈现渲染器内容

  ```c
  void SDL_RenderPresent(SDL_Renderer* renderer)
  ```

### 几何绘制

* 点

  ```c
  int SDL_RenderDrawPoint(SDL_Renderer* renderer, int x, int y);
  int SDL_RenderDrawPoints(SDL_Renderer* renderer, const SDL_Point* points, int count);
  ```

* 线

  ```c
  int SDL_RenderDrawLine(SDL_Renderer* renderer, int x1, int y1, int x2, int y2);
  int SDL_RenderDrawLines(SDL_Renderer* renderer, const SDL_Point* points, int count);
  ```

* 空心矩形

  ```c
  int SDL_RenderDrawRect(SDL_Renderer* renderer, const SDL_Rect* rect);
  int SDL_RenderDrawRects(SDL_Renderer* renderer, const SDL_Rect* rects, int count);
  ```

* 填充矩形

  ```c
  int SDL_RenderFillRect(SDL_Renderer* renderer, const SDL_Rect* rect);
  int SDL_RenderFillRects(SDL_Renderer* renderer, const SDL_Rect* rects, int count);
  ```
  

 ### 事件

* 从事件队列去除一个未处理事件

  ```c
  int SDL_PollEvent(SDL_Event* event);
  ```

### 音频

* 打开音频设备

  ```c
  int SDL_OpenAudio(SDL_AudioSpec * desired, SDL_AudioSpec * obtained);
  ```

  * desired期望音频设备的参数，obtained实际音频设备的参数。

* 播放音频数据

  ```c
  void SDL_PauseAudio(int pause_on);
  ```
