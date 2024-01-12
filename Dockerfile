FROM centos:centos8

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
RUN dnf update -y

RUN dnf install -y git wget
RUN dnf module -y install go-toolset
RUN dnf -y groupinstall "RPM Development Tools"

RUN mkdir ~/openssh-9.6p1

RUN mkdir ~/rpmbuild
RUN mkdir ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}

RUN cd ~/rpmbuild/SOURCES/ && \
    wget https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz

RUN cd ~/rpmbuild/SOURCES/ && \
    wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.6p1.tar.gz

RUN cd ~/rpmbuild/SOURCES/ && \
     git clone https://github.com/openssh/openssh-portable.git && ls



RUN dnf install -y epel-release

RUN dnf install -y libXt-devel krb5-devel gtk2-devel perl pam-devel
RUN dnf --enablerepo=powertools install -y imake

# RUN dnf --enablerepo=powertools install imake

### imake
#  for RL9 
# dnf --enablerepo=crb install imake

#  for CentOS8
# dnf --enablerepo=powertools install imake
###

RUN echo '################ START BUILD ################'
RUN cd ~/rpmbuild/SOURCES/openssh-portable/contrib/redhat && rpmbuild -ba openssh.spec

CMD ["cp", "-rf", "/root/rpmbuild/RPMS/*", "/root/rpms/"]

CMD ["tail", "-f", "/dev/null"]
