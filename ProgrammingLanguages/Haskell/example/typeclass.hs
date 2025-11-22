class PriorityAware a where
    getPriority :: a -> Int


data  Plugin = Plugin {
        context :: String,
        priority :: Int
    }

instance PriorityAware Plugin where
    getPriority (Plugin ctx p) = p

