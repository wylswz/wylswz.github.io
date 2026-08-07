struct key_t {
  u64 pid;
  char comm[16];
};


BPF_HASH(counter_table, struct key_t, u64);


int hello(void *ctx) {
  u64 *cnt = 0;

  struct key_t key = {};
  key.pid = bpf_get_current_pid_tgid();
  bpf_get_current_comm(&key.comm, sizeof(key.comm));

  cnt = counter_table.lookup(&key);
  if (cnt) {
    (*cnt)++;
    counter_table.update(&key, cnt);
  } else {
    u64 one = 1;
    counter_table.update(&key, &one);
  }
  return 0;
}
