version=$1

. /etc/os-release
sys=$ID  # FIXME unused

# automatically set to true if the system depends on EPEL
epel=false

if type apt > /dev/null 2>&1; then
  # On Debian, Ubuntu, and other apt based systems
  apt update
  # Python requires
  apt install -y \
    libbz2-dev \
    libdb5.3-dev \
    libffi-dev \
    libgdbm-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline6-dev \
    libsqlite3-dev \
    libssl-dev \
    tk-dev \
    zlib1g-dev
  # Build tools
  apt install -y build-essential curl gzip tar
elif type yum > /dev/null 2>&1; then
  # On Fedora, Red Hat Enterprise Linux and other yum based systems
  # for openssl11-devel in CentOS 7 or other
  if yum install epel-release -y 2> /dev/null; then
    epel=true
  fi

  # Python requires
  yum install -y \
    gdbm-devel \
    bzip2-devel \
    libffi-devel \
    openssl11-devel \
    readline-devel \
    sqlite-devel \
    tk-devel \
    xz-devel \
    zlib-devel

  # Build tools
  yum install -y curl gcc gzip make pkgconfig tar
else
  exit 1
fi

curl -O https://www.python.org/ftp/python/$version/Python-$version.tgz
rm -rf Python-$version
tar xvf Python-$version.tgz
cd Python-$version

if $epel; then
  # ref: https://bugs.python.org/issue44319#msg406112
  sed -i 's/PKG_CONFIG openssl /PKG_CONFIG openssl11 /g' configure
fi

./configure --enable-optimizations
# make -j 4
make altinstall

# # venv (optional)
# python_ver=`echo $version | sed -e "s/\([^\.]*\.[^\.]*\).*/\1/"`
# python$python_ver -m venv $HOME/.venv/$python_ver
# python_latest=$HOME/.venv/latest
# ln -sf $HOME/.venv/$python_ver $python_latest
# python_default=$HOME/.venv/default
# ln -sf $python_latest $python_default
