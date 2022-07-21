#!/bin/bash
set -e
err() {
    echo "Error occurred:"
    awk 'NR>L-4 && NR<L+4 { printf "%-5d%3s%s\n",NR,(NR==L?">>>":""),$0 }' L=$1 $0
	echo "Press Enter to continue"
	read
	exit 1
}
trap 'err $LINENO' ERR
cd ${0%/*}
docker rm -f wsl2-linux-kernel-docker-build || true
rm -f vmlinux || true

docker run -it --rm --name wsl2-linux-kernel-docker-build \
	-v $(pwd):/tmp/build \
	wsl2-linux-kernel-docker-build bash -c " \
        cat Microsoft/config-wsl /tmp/build/config >> .config \
		&& make -j$(nproc) \
		&& cp -f arch/x86_64/boot/bzImage /tmp/build \
	"
mkdir -p $(wslpath "$(wslvar USERPROFILE)")/.wslkernel
cp bzImage $(wslpath "$(wslvar USERPROFILE)")/.wslkernel/bzImage-new
echo "Finish, press 'Enter' key to exit"
read