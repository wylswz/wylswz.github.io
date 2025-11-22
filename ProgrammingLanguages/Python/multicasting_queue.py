

from multiprocessing import Lock
from queue import Queue


class MulticastingQueue:

    def __init__(self, size=4096) -> None:
        self._s0 = Queue(size)
        self._s1 = Queue(size)
        self._status = 0
        self._lock = Lock()

    def subscribe(self, sink: 'function'):
        self._lock.acquire()
        try:
            if self._status == 1:
                self._s1.put(sink)
            else:
                self._s0.put(sink)
        finally:
            pass
        self._lock.release()

    def put(self, *msg):
        src_q, tgt_q = None, None
        if self._status == 1:
            src_q, tgt_q = self._s1, self._s0
        else:
            src_q, tgt_q = self._s0, self._s1
        while not src_q.empty():
            sink = src_q.get()
            for m in msg:
                sink(m)
            tgt_q.put(sink)  

        self._flip()
            
    def _flip(self):
        self._lock.acquire()
        self._status = 1 - self._status
        self._lock.release()

