# openssh-rpm


# Build using docker

#### Check if the 'openssh-rpm' image is available. If available, delete it:

```
# Delete the image container (if any):
docker stop openssh_rpm && docker rm openssh_rpm 

docker rmi openssh-rpm --force
```

#### Run the build:

```
docker-compose up -d --build
```

#### The created rpm's are in the 'rpms' folder after the build is done:

```
ls ./rpms/x86_64
```

#### On the server:
1) Remove the previous openssh packages:

```
 dnf remove $(dnf list | grep openssh)
```

2) Install the created rpms (run in the folder with the new rpms):

```
dnf install -y * 
```

3) Check sshd version:

```
ssh -V
```

4) Set hostkeys permissions in /etc/ssh/:

```
sudo chmod 600 /etc/ssh/ssh*
```

5) Check sshd_config settings:

```
nano /etc//ssh/sshd_config

PermitRootLogin yes
PasswordAuthentication yes
X11Forwarding yes

```

6) Check if ssh is running correctly:

```
sshd -t
```

7) In case of errors, you can see the logs:

```
tail -f /var/log/secure
```

---

# Manual build example

#### Install build packages (may not be available in some operating systems):
```
sudo dnf install git wget
sudo dnf module install go-toolset
sudo dnf groupinstall "RPM Development Tools"
```

#### Create directories for the build:

```
mkdir ~/rpmbuild
mkdir ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
```

#### Get additional files:

```
cd ~/rpmbuild/SOURCES/
sudo wget https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz
```

#### Get the openssh sources by selecting the current version and patch:

The example below will download the openssh archive version 9.6 with patch version 1
```
cd ~/rpmbuild/SOURCES/
sudo wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.6p1.tar.gz
```

#### Get dependencies for a build. The library versions or requirements for a build may vary depending on the specific version of openssh:

```
sudo dnf repolist
sudo dnf install -y epel-release

sudo dnf install -y libXt-devel krb5-devel gtk2-devel perl pam-devel

# for RL9 
sudo dnf --enablerepo=crb install imake

# for CentOS8
sudo dnf --enablerepo=powertools install imake

```

#### Run the build (it is recommended not to run as root):

```
sudo rpmbuild -ba openssh.spec
```

---

If it takes a long time to build, you can find one ready-made on rpmfind:

```
http://www.rpmfind.net/linux/rpm2html/search.php?query=openssh&submit=Search+...
```
