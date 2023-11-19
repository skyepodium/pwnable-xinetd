from pwn import *

r = remote('127.0.0.1', 60001)

r.interactive()