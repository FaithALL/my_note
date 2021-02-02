[toc]

# STL

## 容器

* vector

  * 删除vector中多个元素时，可先std::remove，再调用erase。

    ```c++
    //从vec中移除所有元素2
    //只是将待删除元素移到末尾
    auto new_end = std::remove(vec.begin(), vec.end(), 2);
    vec.erase(new_end, vec.end());
    ```

  * 快速删除一个元素

    ```c++
  //删除位置idx上的元素(不考虑删除后的相对顺序)
    vec[idx] = std::move(v.back());
    vec.pop_back();
    ```
  
  * at与[]区别：at提供安全检查，出错时抛出异常

* string/string_view

* map

  * 插入

    ```c++
    //尝试构建插入，在key已存在，即无法插入时，少一次构造函数，unordered_map也适用，原型如下
    std::pair<iterator, bool> try_emplace(const key_type& k, Args&&... args);
    //O(1)插入，已知2是最大元素，提示(hint)插入最后
    auto iter(rb_tree.end());
    rb_tree.insert(iter, 2);
    ```

  * 提取元素

    ```c++
    //适用于map/multimap/set/multiset unordered_map/unordered_multimap/unordered_set/unordered_multiset
    node_type extract(const_iterator position);
    node_type extract(const key_type& x)
    ```

* unordered_map

  * [自定义数据类型](https://blog.csdn.net/lpstudy/article/details/54345050)

    ```c++
    //unordered_map的定义，Hash是哈希函数，KeyEqual是发生hash冲突时，如何区分不同对象
    template<
        class Key,
        class T,
        class Hash = std::hash<Key>,
        class KeyEqual = std::equal_to<Key>,
        class Allocator = std::allocator< std::pair<const Key, T> >
    > class unordered_map;
    //KeyEqual重载==后就不必实现
    ```
    
    ```c++
    //方法1，class/struct：默认构造函数+重载括号运算符
    struct hash_p {
        hash_p() = default;
        int operator()(const pair<int, int> &p) const { return p.first; }
    };
    unordered_set<pair<int, int>, hash_p> hash_set;
    ```
    
    ```c++
    //方法2，函数：decltype(&)，传递函数unordered_*的构造函数，
    //&是必要的，因为decltype作用于函数是函数类型而不是指针类型
    int hash_p(const pair<int, int> &p) { return p.first; }
    
    unordered_set<pair<int, int>, decltype(&hash_p)> hash_set(10, hash_p);
    ```
    
    ```c++
    //方法3，lambda表达式：decltype、传lambda给unordered_*的构造函数
    auto hash_p = [](const pair<int, int>& p) {return p.first;};
    unordered_set<pair<int, int>, decltype(hash_p)> hash_set(10, hash_p);
    ```
    
    > [关于lambda需要传参的解释](https://stackoverflow.com/questions/64074068/cant-use-lambda-as-hash-for-unordered-set-of-pairs)：c++20前lamda表达式没有默认构造函数，c++20后，如果未指定捕获，则具有默认的构造函数，c++20可以不传参
    
    ```c++
    //方法4，模板特例化
    //全局作用域
    namespace std{
        template<>
        struct hash<pair<int, int>>{
            int operator()(const pair<int, int>& p) const {
                return p.first;
            }
        };
    }
    
    unordered_set<pair<int, int>> hash_set;
    ```

## 容器适配器

* priority_queue：默认大顶堆

  ```c++
  template<
      class T,
      class Container = std::vector<T>,
      class Compare = std::less<typename Container::value_type>
  > class priority_queue;
  ```

## 迭代器

* 范围for：

  > 迭代器类需重载三个运算符：!=  	前置++	解引用*
  >
  > 具体类需实现两个方法：begin()和end()

  ```c++
  for (auto x : range) { code_block; }
  //上面语句相当于下面
  {
      auto __begin = std::begin(range);
      auto __end = std::end(range);
      for ( ; __begin != __end; ++__begin) {
          auto x = *__begin;
          code_block
      }
  }
  ```

* 自定义迭代器：

  > c++17前推荐继承std::iterator<...>
  >
  > c++17后推荐继承std::iterator_traits<...>

  ```c++
  //TODO
  ```

* 迭代适配器

  * sback_insert_iterator

  * front_insert_iterator

  * insert_iterator：同上两个，只不过可以指定插入位置

  * istream_iterator/ostream_iterator：流输入输出迭代器

    ```c++
    //与迭代适配器功能相似的还有一组模板函数
    //返回插入位置insert_iterator，通常配合copy使用，调用的是insert
    inserter(vec, vec.end());
    //插入末尾，调用的是push_back，
    back_inserter(vec);
    //插入开头，调用pop_back
    front_inserter(vec)
    ```

## 泛型算法

* 排序问题

  ```c++
  //检查是否有序
  is_sorted(vec.begin(), vec.end());
  //排序,还有stable_sort
  sort(vec.begin(), vec.end());
  //选取哨兵，小于5的元素排前面，还有stable_partition
  partition(vec.begin(), vec.end(), [](int i){return i < 5;});
  //部分排序，只排前n个元素
  partial_sort(vec.begin(), vec.begin() + n, vec.end());
  ```
  
* 查找问题

  ```c++
  //有序查找
  //只返回有没有true/false
  binary_search(vec.begin(), vec.end(), 2);
//返回范围
  lower_bound(vec.begin(), vec.end(), 2);
  upper_bound(vec.begin(), vec.end(), 2);
  equal_range(vec.begin(), vec.end(), 2);
  
  //无序查找
  find(vec.begin(), vec.end(), 2)
  ```
  
* 拷贝、移动

  ```c++
  //把[begin, end)的元素复制到out之后，类似的还有copy_if
  copy(vec.begin(), vec.end(), back_inserter(out));
  copy_n(vec.begin(), vec.size(), back_inserter(out));
  //把[begin, end)的元素复制并modify到out之后
  transform(vec.begin(), vec.end(), back_inserter(out), modify);
  
  //移动begin到end的2到末尾，类似的还有remove_if
  remove(vec.begin(), vec.end(), 2);
  ```
  
* 排列问题

  ```c++
  //使用rand随机化[begin,end)的元素，使每种排列的可能相同
  random_device rd;
  default_random_engine  g(rd());
  shuffle(vec.begin(), vec.end(), g);
  
  //下一个字典序，有则返回true并改变vec
  next_permutation(vec.begin(), vec.end());
  //上一个字典序
  prev_permutation(vec.begin(), vec.end());
  
  //旋转：[begin, begin+ n)和[begin +n, end)交换位置
  rotate(vec.begin(), vec.begin() + n, vec.end());
  
  //反转[begin,end)的元素
  reverse(vec.begin(), vec.end());
  ```

* 二路归并

  ```c++
  //外归并v1，v2到vec
  merge(v1.begin(), v1.begin(), v2.begin(), v2.end(), back_inserter(vec));
  //内归并，归并[begin, middle)和[middle, end)
  inplace_merge(vec.begin(), vec.begin() + middle, vec.end());
  ```
  
* 原地二叉堆

  ```c++
  //建堆，默认是大顶堆
  make_heap(vec.begin(), vec.end());
  //插入一个元素，进行堆调整
  push_heap(vec.begin(), vec.end());
  //将堆顶元素移动到end
  pop_heap(vec.begin(), vec.end());
  //堆排序
  sort_heap(vec.begin(), vec.end());
  ```
  
* 集合运算

  ```c++
  //集合差运算，v1 - v2存放到v3
  set_difference(v1.begin(), v1.end(), v2.begin(), v2.end(), back_inserter(v3));
  //集合并运算，v1 并 v2存放到v3
  set_union(v1.begin(), v1.end(), v2.begin(), v2.end(), back_inserter(v3));
  //集合交运算，v1 交 v2存放到v3
  set_intersection(v1.begin(), v1.end(), v2.begin(), v2.end(), back_inserter(v3));
  //对称差运算，v1并v2 - v1交v2存放到v3
  set_symmetric_difference(v1.begin(), v1.end(), v2.begin(), v2.end(), back_inserter(v3));
  ```

* 遍历与修改

  ```c++
  //遍历每个元素，执行打印操作
  for_each(vec.begin(), vec.end(), [](int x){cout << x << endl;});
  
  //从1升序，填充[begin, end）即{1, 2, 3...}
  iota(vec.begin(), vec.end(), 1);
  
  //将vec全部填充为2
  fill(vec.begin(), vec.end(), 2);
  
  //将[begin,end)中的2替换为6，类似的还有replcae_if
  replace(vec.begin(), vec.end(), 2, 6);
  ```

* 数值算法

  ```c++
  //最值
  minmax_element(vec.begin(), vec.end());
  min_element(vec.begin(), vec.end());
  max_element(vec.begin(), vec.end());
  //将[begin, end)中，第n小的元素放在vec.begin() + n
  nth_element(vec.begin(), vec.begin() + n, vec.end());
  
  //将vec中的值限定在[minV, maxV]
  clamp(vec, minV, maxV);
  
  //求x, y的最大公因数
  gcd(x, y);
  //求x, y的最小公倍数
  lcm(x, y);
  
  //计算[begin, end)的运算，默认是+，初值为0
  accumulate(vec.begin(), vec.end(), 0);
  //计算[begin, end)的部分运算，结果从v2.begin()开始存储，默认是+，初值为0
  partial_sum(vec.begin(), vec.end(), v2.begin());
  
  //计数，计算[begin, end)中2出现的次数
  count(vec.begin(), vec.end(), 2);
  //求距离，计算[begin, end)的距离(因为有的迭代器不支持 - 操作)
  distance(vec.begin(), vec.end());
  
  //比较大小
  greater<>();
  less<>();
  ```

## 杂项

* 智能指针：内置指针只能直接初始化智能指针

  * `shared_ptr`：允许多个指针指向同一对象
  * `unique_ptr`：独占所指对象，不支持拷贝、赋值，只可移动
  * `weak_ptr`：弱引用，指向shared_ptr所管理的对象，但不改变其引用计数，解决shared_ptr的循环引用问题。

  ```c++
  //空智能指针
  shared_ptr<T> sp;
  unique_ptr<T> up;
  weak_ptr<T> w;
  //返回动态创建的T类型的对象的智能指针，用arg初始化
  make_shared<T> (args);
  make_unique<T> (args);   //c++14
  //q为内置指针，p接管q所指对象，并且最后使用d来删除对象
  shared_ptr<T> p(q, d);
  p.reset(q, d);
  //unique的删除器，u接管q所指对象，并且最后使用d来删除对象，没有reset版本
  unique_ptr<T, D> u(q, d);
  //u1接管u2所指对象，单独的u2.relsease()没有意义
  u1.reset(u2.release());
  ```

* allocator：将内存分配与对象构造分离

  ```c++
  //定义一个allocator对象
  allocator<T> a;
  //分配n个T类型大小的内存，返回指针
  a.allocate(n);
  //使用args在地址p处构造一个T类型的对象
  a.construct(p, args);
  //使用p的析构函数销毁对象
  a.destroy(p);
  //释放p处的内存
  a.deallocate(p, n);
  //几个伴随算法
  uninitialized_copy(b, e, b2);
  uninitialized_copy_n(b, n, b2);
  uninitialized_fill(b, e, t);
  uninitialized_fill_n(b, n, t);
  ```

* 多线程

  ```c++
  //创建线程
  std::thread th(func);
  //parm等左值是值传递的，类似std::bind
  //如果想传引用需要std::ref(parm)
  //右值依然是按右值传递，thread对象可移动不可复制
  std::thread th(func, parm1, parm2, ...);
  //线程等待/分离
  th.join();
  th.detach();
  th.joinable();
  //获取线程id，线程id是std::thread::id类型的
  th.get_id(); 
  //获取本线程id
  std::this_thread::get_id();
  //获取cpu数目，获取thread native_handle。
  std::thread::hardware_concurrency();
  th.native_handle();
  //线程休眠
  std::this_thread::sleep_for(std::chrono::seconds(1));
  
  //线程同步
  //互斥量mutex、recursive_mutex、timed_mutex、recursive_timed_mutex、shared_mutex、shared_timed_mutex
  std::mutex m;
  m.lock();
  m.unlock();
  //互斥量的自动管理
  std::lock_guard<mutex> guard(m);
  std::scoped_lock<mutex,mutex> guard(m1, m2);   //c++17同时管理多个互斥量
  std::unique_lock<mutex> lock(m);
  //类似互斥量
  std::once_flag flag;
  std::call_once(flag, func);   //线程安全的调用func一次
  //条件变量
  std::condition_variable cond;
  cond.wait();
  cond.notify_one();
  cond.notify_all();
  //条件变量的补充
  std::future<T> fut = std::async(func, parm1, std::ref(parm2));
  //在新线程上执行std::launch::async或者当fut.wait()/fut.get()时执行
  std::future<T> fut = std::async(std::launch::deferred | std::launch::async, func);
  //原子类型
  std::atomic<int> at;
  ```

* 移动语义`std::move`

  ```c++
  //右值引用，只能绑定到一个将要销毁的对象
  //获取var对应的右值，在move后，只能销毁var或者给它赋值
  std::move(var); //底层通过static_cast
  ```
  
* bind绑定：调整可调用对象接口

  ```c++
  void func(string& parm1, int parm2);
  //str是一个已有的stirng对象
  auto newFunc = std::bind(func, str, std::placeholders::_1);
  //那么可以如下使用，相当于调用了func(str, 2)
  newFunc(2);
  //注意：非占位符都是拷贝到bind返回的可调用对象中
  //即尽管parm1希望是引用类型，但是对newFunc而言，它是拷贝的
  //要引用，必须使用std::ref，类似要常引用，需使用std::cref
  auto newFunc = std::bind(func, std::ref(str), std::placeholders::_1);
  ```

* 多态包装器`function`：将调用形式一样的可调用对象看成同类型的对象

  ```c++
  //函数，函数指针，lambda，bind返回的对象，重载()的类对象
  int func(int, int);
  int func2(int, int, int);
  function<int(int, int)> f = func;
  f = [](int a, int b) {return a + b;};
  f = bind(_1, 0, _2);
  ```

* 完美转发`std::forward`

  ```c++
  //std::forward<T>()返回T&&类型，配合引用折叠达到完美转发的效果
  template <typename T> 
  void func(T&& t) {
      f(std::forward<T>(t))
  }
  //t是左值，则T为左值引用，则传给f的为左值引用
  //t是右值，则T为普通非引用类型，则传给f的为右值引用
  ```

* IO：`istream`、`ostream`、`istringstream`、`ostringstream`、`ifstream`、`ofsream`

* 多值类型`tuple`、`pair`

* 任意类型`any`、`variant`

* 失败标识`optional`

* 时间：`ratio`、`chrono`

* 文件系统：`std::filesystem::path`