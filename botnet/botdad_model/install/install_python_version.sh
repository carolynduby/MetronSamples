PYTHON_PKGS_COUNT="$(rpm -qa | grep -c python36)"
if (( PYTHON_PKGS_COUNT == 0 )); then
   sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
   sudo yum update
   sudo yum install -y python36u python36u-libs python36u-devel python36u-pip
fi
PYTHON_PATH="$(which python3.6)"
echo "python 3.6 installed at " ${PYTHON_PATH}
