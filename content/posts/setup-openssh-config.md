+++
title = "Setup OpenSSH Client Config in Windows behind a Proxy"
date = "2024-10-17T12:17:57+08:00"
draft = false
+++

This guide is for people who is behind a corporate proxy with a Windows PC. 

## Fake accounts and servers used in the example

- An account `loki123` in remote server `example.com`.
- A proxy server `10.10.0.1`, listening on port `3128`.
- An account for logging to the proxy server which is usually your Windows domain account `loki.odinson`.

## Prerequisites

- Windows 10/11 which comes with OpenSSH already, otherwise install [OpenSSH](https://www.openssh.com/).
- Have Git install, which provides `connect.exe` we need.
- Setup public key authentication for your account `loki123` in server `example.com`
- And account to login to proxy which is usually your Windows domain account `loki.odinson`

Normally, you should have your account `loki.odinson` logined to proxy server and have the credential saved
in Windows Credential Manager already, otherwise you need to provide account and password in below
config.

With the following setup in `.ssh/config` under your user home directory, you can simply run `ssh myserver` to connect.

```text
Host myserver
    HostName example.com
    User loki123
    Port 3302
    IdentityFile ~/.ssh/id_ed25519
    ProxyCommand C:\Program Files\Git\mingw64\bin\connect.exe -H 10.10.0.1:3128 %h %p
```

Highlights:
1. **myserver** is the alias for **example.com**, can be the domain name instead, which makes the 2nd line optional.
2. The default port of ssh server is 22, specify non default port otherwise.
3. The OpenSSH version comes with Windows would report error if not providing the full path of the **connect.exe**, won't work
   even if you add it to `PATH`.


Config for connecting to GitHub, note that **git** client can handle the **connect** without specifying full path.

```text
Host github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    ProxyCommand connect -H 10.10.0.1:3128 %h %p
```
