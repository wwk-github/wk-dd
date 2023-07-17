# wk-dd
dd, lz4/zstd, dump and check

1-st terminal
```
export WK_DISK_DEV=nvme0n1; \
date; \
dd if=/dev/$WK_DISK_DEV bs=100M | tee >(openssl md5 > create.md5) | pv --name before-compress --cursor | zstd --fast --threads=0 | pv --name after-compress --cursor > $WK_DISK_DEV.dd.zst; \
date; \
zstdcat --threads=0 $WK_DISK_DEV.dd.zst | pv --name verifying --cursor | md5sum > verify.md5; \
cat create.md5; \
cat verify.md5; \
date
```

2-nd terminal
```
export WK_DISK_DEV=nvme0n1; \
date; \
cat /dev/$WK_DISK_DEV | pv --name simple --cursor | md5sum > simple.md5; \
cat simple.md5; \
date
```
