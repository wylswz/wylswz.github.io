# 类型系统作为 Agent 的沙盒

起因是一次关于轻量级 agent 运行环境的讨论。

## 运行时安全

通常的做法是把完整沙盒塞给 agent，再围绕它堆工程措施。
- 网络策略
- landlock
- 凭据注入
- 提示词防护
- 容器隔离

弱点：沙盒管的是能不能碰到资源，管不了碰到之后数据流向哪里。

典型泄露路径：合法能力读私有文件，合法能力写输出文件，泄露发生在两者之间，而这个之间从不跨越沙盒边界。

## 转换

[论文](https://arxiv.org/abs/2603.00991)把运行时安全的一层转换成类型安全。Agent 提交 Scala 3 代码，由开启 capture checking 的编译器先过一遍。

```scala
class Classified[T] {
  def reveal(using permission: CanAccess[T]): T
  def map[U](f: T -> U): Classified[U]
}
```

`T -> U` 是纯箭头：map 要求参数的 capture set 为空。

```scala
secret.map(s => s.toUpperCase)      // OK
secret.map { s => f.write(s); s }   // String ->{f} String，不符合
```

不是检查回调里调了什么，是闭包的类型本身不符合签名。

杜绝的只是经由 map 回调的泄露。
- 不覆盖 timing、termination 等隐蔽信道
- 完整保证还依赖 `toString` 恒为 `Classified(****)` 和运行时的双输出通道

## Capture Checking

类型除记录形状，还记录值可能持有的能力。`T^{x1,...,xn}` 的 capture set 是过近似，空集为纯，`T^` 为任意。

能力的生命周期由此静态控制。`requestFileSystem(root)(block)` 中能力随 block 返回失效——偷运出去的闭包会在 capture set 里提到它，而 block 的返回类型不能引用它。

同一性质跨轮成立。
- 上一轮授予的能力在下一轮无效
- 上一轮绑定的 `Classified` 下一轮仍然包裹
- 涉密值只经 secure channel 到达用户，不以明文进入对话上下文

第三条是相对运行时 taint tracking 的结构性优势：值一旦以自然语言进入上下文，taint 标记就丢了。

## CanAccess

`using` 的含义是调用 `reveal` 时编译器必须在当前作用域隐式解析出一个 `CanAccess[T]`，解析不到即编译错误。

它并非无法被构造。库必须构造得出来，手法是构造器私有。`IOCapability` 的构造器一样私有，agent 却持有它——因为 preamble 把实例放进了 given 作用域。

**授权的载体是 given 作用域的内容，私有构造器只是防止 agent 自己补上缺口。**

坑：`using` 的解析还会搜索 implicit scope，包括伴生对象。在伴生对象里放 `given` 等于给全世界发钥匙。

私有构造器加 given 纪律并不够。`new`、继承、`summon` 编译期被挡，但标准 Scala 3 下另有三条路能拿到真实明文。
- `given = null`——默认配置下 `Null` 是所有引用类型的子类型
- `asInstanceOf`——泛型擦除，且 phantom token 没人调方法，运行期不会抛 ClassCastException
- 反射 `setAccessible(true)`——`private` 挡不住反射

所以 safe mode 的六条限制是承重墙，不是冗余：禁 unchecked cast 与模式匹配、禁 `caps.unsafe`、禁 `@unchecked`、禁反射、强制 capture checking 与 explicit nulls、只允许访问自身安全的全局对象。实测这几条相互独立，开了 explicit nulls 后 cast 那条照样泄露。

边界：`given = ???` 通得过类型检查（`Nothing` 居留于一切类型），运行时抛异常，无泄露。保证是作用域内不存在该类型的可收敛项，不是不存在该类型的表达式。

`reveal` 和 `CanAccess` 只存在于论文的概念模型。实际库只有 `map` 和 `flatMap`，解封出口是双输出通道。
- `reveal` 要回答凭证怎么发放、裸值之后流向哪里；双通道把答案定死为人的终端
- 协变的 `Classified[+T]` 和 `reveal(using CanAccess[T])` 在 Scala 里无法共存，编译器报协变类型参数出现在不变位置。论文两处定义的差异不是笔误

## 非目标

- 不解决正确性和幻觉
- 不覆盖隐蔽信道
- 允许的命令自身可以有副作用
- 安全关键部署仍需叠加沙盒

即类型系统把沙盒抓不到的那一类提到编译期，不替代沙盒。tacit 的运行期仍有路径越界、异常容纳、进程超时等检查。

成本低于预期：基础设施约一千行 Scala，编译开销一秒内，需重试的片段占 0.32% 到 7.93%。

## 实现

[tacit](https://github.com/lampepfl/tacit) 是原始实现，一个 MCP server：agent 提交片段，safe mode 编译，通过的丢进常驻 REPL。Agent 不需要知道类型系统存在。

[citron](https://github.com/mishudark/citron) 是 Go + Starlark 移植。架构逐条照搬——API 签名形状、`Classified(****)` 字面量、双输出通道、session 三性质、论文实验用的六个 domain facade。

丢掉的恰好是核心贡献。local purity 在 Go 里没有对应物，被替换成遍历 Starlark AST 猜回调纯不纯的检查器。代价是它的 bypass 回归测试里那一串已发现的绕过。
- `getattr` 间接调用 `map`
- 方法值存下来稍后调用
- 非字面量属性名动态取 `map`
- 能力藏进容器再从回调取出
- 同名函数重定义，检查器验第一个定义而运行第二个

这些在 Scala 那边不成为问题：怎么别名重绑定，类型还是 `String ->{net} String`。用语法分析近似类型系统属性就得一条条补。

能力逃逸同样降级：capture checking 里是编译期不可能，citron 这边是原子布尔标志位，逃逸代码正常编译，调用瞬间才报错。

### Starlark 的扩展机制

Starlark 出自 Bazel，目标是确定性配置语言。
- 没有 import，模块由宿主决定
- 没有反射
- 没有类型转换
- 没有 null
- 不能定义类和继承

宿主通过 `starlark.StringDict` 注入全局变量，脚本可见的世界就是这个 dict。扩展方式是 Go 类型实现 `starlark.Value` 加 `Attr`/`AttrNames`，`Attr` 在属性被求值的瞬间返回包装 Go 闭包的 builtin，解释器随即调用。同步内联，没有中间表示，也没有可审查的计划。

能力对象始终是 Go 值，脚本只持有不透明句柄。`Classified` 在 Go 侧有 `Value()` 能取明文，bindings 不暴露它，效果等价于 tacit 的没有公开 get 或 unwrap。`Extras`（注入 mcpgen 生成的远端 MCP 绑定）遵守同一规则：内置能力覆盖 Extras。

于是论文花一整节造 `language.experimental.safe` 挖出的安全子集，Starlark 天生就是。前面那三条泄露路径在这里根本不存在，且不存在忘记加语言 import 的失效模式。

**citron 保住了 capability safety，丢掉了 local purity。** 换来零依赖、可嵌入、毫秒级启动。

Starlark 也不是没有动态性，`getattr` 就在 citron 的绕过列表里。

## 判断

多数 agent 安全方案试图让模型变可信，这篇选择让媒介变安全：举证责任从模型转移到编译器，与代码是人写的还是幻觉出来的无关。

代价是需要一门能在类型里表达能力的语言，而论文认为 Scala 3 目前是唯一生产可用的选择。

移植时要清楚丢了什么。capability safety 容易复制，挑一门受限语言就免费得到；local purity 不行，它就是类型系统本身。

## 引用

- Odersky, Zhao, Xu, Bračevac, Pham. *Tracking Capabilities for Safer Agents*, CAIS '26 — <https://arxiv.org/abs/2603.00991>
- Capture checking — <https://docs.scala-lang.org/scala3/reference/experimental/cc.html>
- Safe mode — <https://nightly.scala-lang.org/docs/reference/experimental/capture-checking/safe.html>
- tacit — <https://github.com/lampepfl/tacit>
- citron — <https://github.com/mishudark/citron>
