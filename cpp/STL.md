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
  
* 拷贝、移动和替换

  ```c++
  //把[begin, end)的元素复制到out之后，类似的还有copy_if
  copy(vec.begin(), vec.end(), back_inserter(out));
  copy_n(vec.begin(), vec.size(), back_inserter(out));
  //把[begin, end)的元素复制并modify到out之后
  transform(vec.begin(), vec.end(), back_inserter(out), modify);
  
  //移动begin到end的2到末尾，类似的还有remove_if
  remove(vec.begin(), vec.end(), 2);
  
  //将[begin,end)中的2替换为6，类似的还有replcae_if
  replace(vec.begin(), vec.end(), 2, 6);
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
  
  rotate();
      
  reverse();
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
  make_heap
  push_heap
  pop_heap
  sort_heap
  ```
  
* 集合运算

  ```c++
  set_difference
  set_union
  set_intersection
  set_symmetric_difference
  ```

* 遍历与修改

  ```;
  for_each();
  iota();
  fill();
  generate();
  ```

* 数值算法

  ```c++
  //特值
  minmax_element(vec.begin(), vec.end());
  min_element(vec.begin(), vec.end());
  max_element(vec.begin(), vec.end());
  //将[begin, end)中，第n小的元素放在vec.begin() + n
  nth_element(vec.begin(), vec.begin() + n, vec.end());
  
  //将vec中的值限定在[minV, maxV]
  clamp(vec, minV, maxV);
  
  //
  gcd();
  lcm();
  
  count
  accumulate
  partial_sum
  ```

## 杂项

* IO：`istream`、`ostream`、`istringstream`、`ostringstream`、`ifstream`、`ofsream`
* 多值类型`tuple`、`pair`
* 任意类型`any`、`variant`
* 失败标识`optional`

* 移动语义`std::move`
* 完美转发`std::forward`
* 多态包装器`function`
* `bind`
* 智能指针：`shared_ptr`、`unique_ptr`、`weak_ptr`
* 时间：`ratio`、`chrono`
* 多线程：`thread`
* 文件系统：`std::filesystem::path`、`directory_iterator`、`directory_entry`