+++
title = "Setup Private Container Registry"
date = "2024-09-29T12:17:57+08:00"
draft = true
+++

- How to download and verify the pre-compiled binary
- How to generate a self-signed certificate
- How to write a systemd config
- How to start the service
- How to tag and push an image
- How to pull the image

# Summary

This guide explains how to setup a private container registry in CentOS Stream 9
server within a private network without public Internet access.

## Prerequesties

- A PC with Internet connection and with OpenSSH installed.
- An account with root/sudo access to the remote CentOS Stream 9 server.

## Download pre-compiled binary from GitHub

Download the latest stable release of the registry binary from GitHub in your PC,
as of now the latest one is [v2.8.3][1], then compute the sha256 hash to if it match
the corresponding [hash][2]. Navigate to the directory containing the downloaded file,
then run the following corresponding command based on the OS of your machine.

Windows: `CertUtil -hashfile registry_2.8.3_linux_amd64.tar.gz SHA256`
Linux: `sha256sum registry_2.8.3_linux_amd64.tar.gz`
MacOS: `shasum -a 256 registry_2.8.3_linux_amd64.tar.gz`

## Upload the tar.gz file to remote server.

Supposed the remote server's domain is centos9.example.com

```Shell
# copy the file to user tinyScrat's home directory
scp registry_2.8.3_linux_amd64.tar.gz tinyScrat@centos9.example.com:~/
```

## Install the binary file and add configuration

```Shell
# login to remote server
ssh tinyScrat@centos9.example.com
```

1. Copy the executable to /usr/loal/bin

```Shell
# extract the tar file
tar -xzf registry_2.8.3_linux_amd64.tar.gz --one-top-level

# copy the file
sudo cp registry_2.8.3_linux_amd64/registry /usr/local/bin
```

2. To server https traffic, a certificate is needed. Generate or get a certificate from
your IT department.

For demo purpose, I am going to use self-sign certificate certificate.

```Shell
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
    -keyout centos9.example.com.key -out centos9.example.com.crt \
    -subj "/CN=centos9.example.com" \
    -addext "subjectAltName=DNS:centos9.example.com,DNS:*.centos9.example.com"

# -nodes, means no DES encryption for the private key

sudo cp centos9.example.com.key /etc/pki/tls/private/
sudo cp centos9.example.com.crt /etc/pki/tls/certs/
```

[1]: <https://github.com/distribution/distribution/releases/download/v2.8.3/registry_2.8.3_linux_amd64.tar.gz> "registry tar.gz"
[2]: <https://github.com/distribution/distribution/releases/download/v2.8.3/registry_2.8.3_linux_amd64.tar.gz.sha256> "sha256"
