# 类型系统作为 Agent 的沙盒

起因是一次关于轻量级 agent 运行环境的讨论。

## 运行时安全的现状

我们通常把一个完整的沙盒塞给 agent，然后围绕它堆工程措施：网络策略、landlock、凭据注入、提示词防护、容器隔离。边界靠这些措施的交集撑起来。

结构性弱点：**沙盒管的是"能不能碰到资源"，管不了"碰到之后数据流向哪里"**。

论文里的典型例子：agent 通过合法能力读了一个私有文件，又通过合法能力写了一个输出文件，两个操作都在任何合理沙盒的许可范围内。泄露发生在两者之间，而这个"之间"从不跨越沙盒边界。

## 论文的转换

[Tracking Capabilities for Safer Agents](https://arxiv.org/abs/2603.00991)（Odersky 等，EPFL，CAIS '26）把运行时安全的一部分转换成类型安全。

Agent 不再直接发工具调用，而是提交 Scala 3 代码，由开启 capture checking 的编译器先过一遍。核心是这个容器：

```scala
class Classified[T] {
  def reveal(using permission: CanAccess[T]): T
  def map[U](f: T -> U): Classified[U]
}
```

`map` 的参数类型是 `T -> U`，纯箭头，要求这个函数的 capture set 为空——它捕获不到任何能力，因此没有任何把数据送出去的渠道。

这不是"检查回调里有没有调危险函数"，而是**闭包的类型本身不符合签名**：

```scala
secret.map(s => s.toUpperCase)      // OK
secret.map { s => f.write(s); s }   // rejected: String ->{f} String
```

被拒的那个闭包被推导为 `String ->{f} String`，capture set 里有 `f`，不符合要求的空集。

注意表述要准确——不是"map 没有 capture 能力"，而是 **map 要求它的参数 capture set 为空**。

同样要收窄的是保证的范围。`map` 从类型层面杜绝的是**经由 map 回调的泄露**，不是所有泄露：

- 论文明确不覆盖 timing、termination 这类隐蔽信道。Agent 原则上可以通过在不同内容上消耗不同时长泄露一个 bit
- `Classified` 的完整保证还依赖 `toString` 恒为 `Classified(****)`，以及运行时的双输出通道

## Capture Checking

capture checking 让类型除了记录形状，还记录值可能持有的能力。`T^{x1,...,xn}` 里的 capture set 是一个过近似。空集是纯的，`T^` 表示可能持有任意能力。

有了它，能力的**生命周期**也能静态控制。`requestFileSystem(root)(block)` 这种 with-resource 模式，能力创建、传给 block、block 返回后失效。

Agent 想偷运它出去——返回一个闭包，或者把文件句柄装进列表返回——闭包的类型会在 capture set 里提到那个能力，而 block 的返回类型是外部的、不能引用它。编译器直接拒。

论文附录收录了真实 agent 运行中产生的编译错误，其中一条就是 agent 试图从 `requestFileSystem` 块里返回 `FileEntry` 列表，报的是能力 outlive 了自己的作用域、泄漏进外层 capture set。

这类"能力逃逸"在纯运行时机制里只能靠一个失效标志位在调用瞬间报错，在这里连编译都过不了。

### Session Scoped Env

环境和权限统一建模为能力，挂在 session 级的对象上。多轮对话下有三条性质跨轮成立：

- 上一轮 `requestX` 授予的能力在下一轮无效（块已返回）
- 上一轮绑定的 `Classified` 值下一轮仍然是包裹的
- 任何轮次打印的涉密值只经由 secure channel 到达用户，从不以明文进入 agent 的对话上下文

最后一条是它相对运行时 taint tracking 的结构性优势：一旦值以自然语言进入 LLM 上下文，taint 标记就丢了，而这里明文根本没有进入上下文的通道。

## CanAccess 为什么 agent 拿不到

我最初的理解是"`CanAccess` 是一个 context parameter，且无法被构造"。这个说法不准确，而且**它不是安全性的真正来源**。

`using` 的含义是：调用 `reveal` 时编译器必须在当前作用域里隐式解析出一个 `CanAccess[T]`，解析不到就是编译错误。

但"无法被构造"是错的。库自己必须构造得出来，否则这个特性没有意义。实际手法是构造器私有——论文里已实现的 `IOCapability` 就是这么写的。

关键在于：**`IOCapability` 的构造器一样私有，agent 却持有它**。因为 harness 主动把一个实例放进了 REPL 顶层的 given 作用域（agent 需要 println）。

两者在可构造性上完全一样，差别只有一件事：**preamble 选择不把 `CanAccess` 的实例放进 agent 的作用域**。授权的载体是 given 作用域的内容，私有构造器只是防止 agent 自己补上这个缺口。

还有个容易踩的坑：Scala 解析 `using` 参数时除了词法作用域，还会搜索 implicit scope——包括 `CanAccess` 自己的伴生对象。如果库图方便在伴生对象里放一个 `given`，就等于给全世界发钥匙，私有构造器变得完全无关，因为没人需要构造任何东西。

### 私有构造器加 given 纪律，单独并不够

我搭了一个最小复现来验证。直接 `new`、继承、`summon` 三条朴素路线，编译期就被挡住（构造器私有、类是 final、找不到 given 实例）。

但在**标准 Scala 3** 下，另外三条路全部成功泄露了真实明文：

- `given = null`——默认配置下 `Null` 是所有引用类型的子类型，直接过编译
- `null.asInstanceOf[CanAccess[T]]`——泛型擦除，而 `CanAccess` 是个 phantom token，没人调它的方法，所以运行期永远不会抛 ClassCastException
- 反射取私有构造器 `setAccessible(true)`——`private` 挡不住反射

这就是论文为什么必须有 safe mode：禁 unchecked cast 和模式匹配、禁 `caps.unsafe`、禁 `@unchecked`、禁反射、强制开启 capture checking 与 explicit nulls、只允许访问自身安全的全局对象。

这六条不是防御性冗余，是承重墙。实测还确认它们**相互独立**——开了 explicit nulls 之后，cast 那条路照样泄露。

### 一个边界

`given = ???` 是**通得过类型检查**的，因为 `???` 的类型是 `Nothing`，居留于一切类型。它运行时抛异常，什么都没泄露。

所以保证的准确表述是"agent 的作用域里不存在 `CanAccess[T]` 的**可收敛项**"，而不是"不存在该类型的表达式"。

### reveal 其实没有被实现

`reveal` 和 `CanAccess` 只出现在论文的概念模型一节。真正的库只有 `map` 和 `flatMap`，给 agent 的系统提示词里明写"没有公开的 `.get` 或 `unwrap`"。实际的解封出口被替换成了双输出通道。

这个替换很务实。`reveal` 作为设计要回答一堆问题：谁持有凭证、怎么发放、拿到裸值之后它流向哪里——那时它已经是个普通 String，类型系统再也管不住。双通道把答案直接定死为"唯一目的地是人的终端"。

还有一个纯技术层面的理由：协变的 `Classified[+T]` 和 `reveal(using CanAccess[T])` **在 Scala 里无法共存**，编译器会报协变类型参数出现在不变位置。

论文里那两个看似不一致的定义——讲 `reveal` 时用不变的 `class Classified[T]`，实际 API 用协变的 `trait Classified[+T]`——不是笔误，是这个约束逼出来的取舍。

## 这个方案不保证什么

论文自己划得比较清楚：

- 不解决正确性和幻觉
- 不覆盖 timing、termination 这类隐蔽信道
- 允许的命令自身可以有副作用
- 安全关键部署仍应叠加沙盒做纵深防御

所以"把运行时安全转换成类型安全"这个说法要收一下——转换的是其中一层。

tacit 的运行期仍然有检查：路径越界抛 SecurityException、异常用 `Try` 容纳、进程超时。类型系统做的是把**沙盒抓不到的那一类**（合法能力之间的数据流）提到编译期，而不是替代沙盒。论文自己的措辞是两者互补。

工程成本比预期低：

- 可复用基础设施约一千行 Scala，per-domain facade 和它们替代的 JSON schema 体量相当
- 编译开销在一秒以内，相对 LLM 推理延迟可以忽略
- 需要重试的代码片段占 0.32% 到 7.93%
- capture checking 是实验特性、训练数据里很少，但实验结论是模型能写——注解很轻且模式重复

## 实现

[lampepfl/tacit](https://github.com/lampepfl/tacit) 是论文的原始实现，一个 MCP server：agent 通过 MCP 提交 Scala 片段，server 用 safe mode 编译，只有通过的才丢进常驻 REPL 执行。Agent 本身不需要用 Scala 写，也不需要知道类型系统的存在。

[mishudark/citron](https://github.com/mishudark/citron) 是 Go + Starlark 的移植。我最初的判断是"只是写了一个类似的 runtime，没有类型层面的机制"——方向对，但不够严谨。

**架构是逐条移植的。** `RequestFileSystem` / `RequestExecPermission` / `RequestNetwork` 的签名形状、`FileSystem.Access` 返回 `FileEntry`、`Classified` 的 map/flat_map、`Classified(****)` 这个字面量、双输出通道、多轮 session 的三条性质、乃至论文实验用的六个 domain facade（τ²-bench 的 airline/retail，AgentDojo 的 banking/slack/travel/workspace），全都在。这不是撞车。

**丢掉的恰好是论文的核心贡献。** local purity 那一半——`T -> U` 纯箭头——在 Go 里没有对应物，被替换成一个遍历 Starlark AST、猜回调纯不纯的静态检查器。

代价直接写在仓库里。它的 bypass 回归测试是一串已发现的绕过：

- 用 `getattr` 间接调用 `map`
- 把方法值存下来稍后调用
- 用非字面量属性名动态取 `map`
- 把能力藏进容器再从回调里取出
- 同名函数重定义，让检查器验了第一个定义而运行的是第二个

这些在 Scala 那边根本不成为问题。无论怎么 getattr、别名、重绑定，值的类型还是 `String ->{net} String`，不符合 `T -> U`。用语法分析近似一个类型系统属性，就得一条条补，而且没有理由认为补完了。

能力逃逸也一样降级：capture checking 里"能力不能出现在结果类型中"是编译期不可能，citron 这边是一个原子布尔标志位，逃逸的代码能正常编译，在调用瞬间才报 used outside its scope。

### Starlark 的扩展机制

但有一半 citron 其实拿到了，而且比 Scala 更容易——这点反直觉。

Starlark 出自 Bazel，设计目标是确定性的配置语言：

- 没有 import，模块由宿主决定
- 没有反射
- 没有类型转换
- 没有 null
- 不能定义类，不能继承

宿主通过 `starlark.StringDict` 注入全局变量，脚本能看见的整个世界就是这个 dict。

扩展方式是让 Go 类型实现 `starlark.Value`，再实现 `Attr(name)` 和 `AttrNames()`。`Attr` 在**属性被求值的那一刻**返回一个包装了 Go 闭包的 builtin，解释器随即调用它。

所以 `f.write("x")` 这条链是：解释器求值 `Attr("write")` → 拿到闭包 → 立即调用 → 进到 Go 侧做检查和实际操作。同步、内联，没有中间表示，也没有可供审查的计划。

关键在于**能力对象始终是 Go 值，脚本只持有一个不透明句柄**。`Classified` 在 Go 侧有一个 `Value()` 方法可以取出明文，但 bindings 没有暴露它，脚本层面拿不到——这和 tacit 说的"没有公开的 get 或 unwrap"效果等价。

citron 的 `Extras` 机制（注入 mcpgen 生成的远端 MCP 工具绑定）遵守同一条规则：内置能力始终覆盖 Extras，宿主保留最终控制权。

于是：论文需要花一整节造一个 `language.experimental.safe`，从完整的 Scala 里挖出安全子集，禁掉 cast、反射、`@unchecked`、`caps.unsafe`、乃至全局 print 函数——**而 Starlark 天生就是那个子集**。

前面实测能泄露明文的三条路（null、cast、反射）在 Starlark 里根本不存在。这不只是省事，还更可信：不存在"忘记加语言 import"这种失效模式。

更准确的表述是：**citron 保住了 capability safety（能力不可伪造），丢掉了 local purity（纯度不可静态保证）。** 换来的是零依赖、可嵌入 Go 服务、毫秒级启动——对比常驻一个 Scala 编译器加 REPL。

公允地说，Starlark 也不是完全没有动态性。`getattr` 就是一个，而它恰好出现在 citron 的绕过列表里。

## 判断

论文的立场：多数 agent 安全方案试图让模型变可信（对齐训练、运行时监控、人工审批），而它选择**让媒介变安全**。当 agent 把意图表达为一门能力安全语言里的类型化代码，举证责任就从模型转移到了编译器。这个保证与模型行为无关，无论代码是工程师写的还是被误导的模型幻觉出来的。

代价是它需要一门能在类型里表达能力的语言，而论文的说法是 Scala 3 目前是唯一生产可用的选择。

移植到别的语言时要清楚自己丢了什么：capability safety 相对容易复制，甚至挑一门受限语言就免费得到；local purity 不行——它就是类型系统本身。

## 引用

- Odersky, Zhao, Xu, Bračevac, Pham. *Tracking Capabilities for Safer Agents*, CAIS '26（正式标题 *Securing Agents With Tracked Capabilities*）— <https://arxiv.org/abs/2603.00991>
- Scala 3 capture checking — <https://docs.scala-lang.org/scala3/reference/experimental/cc.html>
- Safe mode — <https://nightly.scala-lang.org/docs/reference/experimental/capture-checking/safe.html>
- tacit（论文实现）— <https://github.com/lampepfl/tacit>
- citron（Go/Starlark 移植）— <https://github.com/mishudark/citron>
