# Zanzibar 的一致性模型

## 背景

Zanzibar ACL Check 方式
- 关系图
- 对象 $obj$
- 关系 $rel$
- 用户 $U$
$$
CHECK(U, <obj, rel>) = \\
\exist{<obj\#rel@U>} \\
\lor 
\exist{
    <obj\#rel@R>
}, \\
where \ {CHECK(U, R)}
$$

## 一致性
### 外部一致性 (External Consistency)
每个 ACL / 内容变更都有时间戳 T 使得

$$
T_x < T_y \implies x \prec y
$$

### 有界陈旧快照读（Snapshot Read with Bounded Staleness）

当 ACL check 时，保证所读的快照时间戳 $T > T_{contentUpdate}$, 就是所谓的 “有界”。

### 机制

zookie 传递。

客户端创建资源时，获得 zookie，并通资源一起存储。

ACL check 时，携带 zookie。

如果不懈怠 zookie，服务端默认策略，例如最近 10s。