#!/bin/bash
# copy right by zetaxbyte
# you can rich me on telegram t.me/@zetaxbyte

DATE=$(date '+%y%m%d')
cyan="\033[96m"
green="\033[92m"
red="\033[91m"
blue="\033[94m"
yellow="\033[93m"
normal="\033[0m"

zipname="Zakar-kernel-78hz-gpu-clk-400mhz.zip"

if [ -d $(pwd)/../clang-r498229b ] ; then
echo -e "\n lets's go \n"
else
echo -e "\n $red clang-r498229b dir not found!!! $normal \n"
sleep 1
echo -e "$yellow wait.. Dwonloading clang-r498229b... $normal \n"
sleep 1
mkdir -p $(pwd)/../clang-r498229b ; wget -P $(pwd)/../clang-r498229b/ https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main/clang-r498229b.tar.gz ; sleep 2 ; tar -xf $(pwd)/../clang-r498229b/clang-r498229b.tar.gz -C $(pwd)/../clang-r498229b/ && rm -rf $(pwd)/../clang-r498229b.tar.gz && ls $(pwd)/../clang-r498229b
sleep 1
echo
echo -e "\n $green okay Downloading done... $normal \n"
sleep 1
fi

echo -e "$cyan=========================== $normal"
echo -e "$cyan= START COMPILING KERNEL  = $normal"
echo -e "$cyan=========================== $normal"

echo -e "$blue...LOADING... $normal"

echo -e -ne "$green## (10%\r"
sleep 0.7
echo -e -ne "$green#####                     (33%)\r"
sleep 0.7
echo -e -ne "$green#############             (66%)\r"
sleep 0.7
echo -e -ne "$green#######################   (100%)\r"
echo -ne "\n"

echo -e -n "$yellow\033[104mPRESS ENTER TO CONTINUE\033[0m"
read P
echo  $P

# change DEFCONFIG to you are defconfig name or device codename

DEFCONFIG="vendor/R5X_defconfig"

# you can set you name or host name(optional)

export KBUILD_BUILD_USER=t.me@zetaxbyte
export KBUILD_BUILD_HOST=Dark-Anggle

# change TC_DIR(directory) on where you clone proton-clang toolchain

TC_DIR=$(pwd)../clang-r498229b

# do not modify export PATCH it's been including with TC_DIR

export PATH="$TC_DIR/bin:$PATH"

COMPILE_START=$(date +"%s")

mkdir -p out
make O=out ARCH=arm64 $DEFCONFIG

make -j$(nproc --all) O=out ARCH=arm64 CC=clang LD=ld.lld AR=llvm-ar AS=llvm-as NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- 2>&1 | tee log.txt

if [[ -f out/arch/arm64/boot/Image.gz ]] ; then
COMPILE_END=$(date +"%s")
COMPILE_TIME=$((COMPILE_END - COMPILE_START))
echo -e "\n $yellow BUILD COMPLITE  $((COMPILE_TIME / 60)) minute(s) and $((COMPILE_TIME % 60)) second(s) \n"
    echo -e "$cyan===========================\033[0m"
    echo -e "$cyan=  SUCCESS COMPILE KERNEL =\033[0m"
    echo -e "$cyan===========================\033[0m"
sleep 0.5
rm -rf $zipname
sleep 1
else
COMPILE_END=$(date +"%s")
COMPILE_TIME=$((COMPILE_END - COMPILE_START))
echo -e "\n $red BUILD FAILED  $((COMPILE_TIME / 60)) minute(s) and $((COMPILE_TIME % 60)) second(s) \n"
echo -e "$red!ups...something wrong!?\033[0m"
fi

any_kernel_setup() {
if [ -d $(pwd)/../anykernel_r5x/ ] ; then
echo "setup"
else
git clone https://github.com/zetaxbyte/anykernel_r5x.git $(pwd)/../anykernel_r5x/
fi
}

any_kernel_setup

sleep 0.5

zip_function() {
if [[ -f out/arch/arm64/boot/Image.gz-dtb || out/arch/arm64/boot/dtbo.img ]] ; then
echo -e "$yellow zipping Kernel to flashabel zip ! $normal"
rm -rf $(pwd)/../anykernel_r5x/Image.gz-dtb
rm -rf $(pwd)/../anykernel_r5x/dtbo.img
sleep 0.5
cp out/arch/arm64/boot/Image.gz-dtb $(pwd)/../anykernel_r5x/
cp out/arch/arm64/boot/dtbo.img $(pwd)/../anykernel_r5x/
cd $(pwd)/../anykernel_r5x/ && zip -r $zipname *
mv $zipname "$OLDPWD"
cd -
sleep 1
echo
echo -e "\033[93msize \n"
du -sh $zipname
sleep 1
echo -e "\n$green ====== $normal"
echo -e "$green done √ $normal"
echo -e "$green ====== $normal\n"
else
echo -e "$red failed to zip"
fi
}

zip_function
