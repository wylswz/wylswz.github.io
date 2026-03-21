# Zanzibar 的一致性模型

## 背景

Zanzibar ACL Check 方式
- 关系图
- 对象 $obj$
- 关系 $rel$
- 用户 $U$

递归检查

$$
CHECK(U, <obj, rel>) = \\
\exists{<obj\#rel@U>} \\
\lor 
\exists{
    <obj\#rel@R>
}, \\
where \ {CHECK(U, R)}
$$

## 一致性
### 外部一致性 (External Consistency)
每个 ACL / 内容变更有 zookie（时间戳）$T$；因果序与之一致：

$$
x \prec y \implies T_x < T_y
$$

### 有界陈旧快照读（Snapshot Read with Bounded Staleness）

当 ACL check 时，快照 $T$ 不早于内容读时的 zookie，即 $T \ge T_{\mathrm{content}}$，就是所谓的 “有界”。

### 机制

zookie 传递。

客户端创建资源时，获得 zookie，并与资源一起存储。

ACL check 时，携带 zookie。
如果不携带 zookie，由服务端默认策略决定新鲜度。
