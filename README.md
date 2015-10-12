Recipe for Arch Linux x86_64 Vagrant box that serves as distcc client
for armv5 builds.  Used to build [Archphile](http://archphile.org/)
packages for [Pogoplug Series 4](http://archlinuxarm.org/platforms/armv5/pogoplug-series-4).
Probably useful for [DockStar](http://archlinuxarm.org/platforms/armv5/seagate-dockstar) as well.

### Prerequisites:

 * [Packer](https://packer.io/), e.g. from [packer-io](https://aur.archlinux.org/packages/packer-io/) or [packer-io-git](https://aur.archlinux.org/packages/packer-io-git/) in AUR on Arch Linux
 * [Vagrant](https://vagrantup.com/), e.g. `sudo pacman -S vagrant`
 * [VirtualBox](https://virtualbox.org/), e.g. `sudo pacman -S virtualbox`

### How I use it:

* Make sure the VirtualBox modules are loaded:
  ```sh
  for m in vboxdrv vboxnetflt vboxnetadp; do
      sudo modprobe $m
  done
  ```

* Build a Vagrant base box named "arch" for Arch Linux using Packer:
  ```sh
  # Clone somewhere with 1-2gb of free disk; will download
  # Arch Linux ISO and build VirtualBox disk image.
  git clone https://github.com/elasticdog/packer-arch.git
  cd packer-arch
  packer-io build -only=virtualbox-iso arch-template.json
  vagrant box add arch packer_arch_virtualbox.box
  ```

* Build a Vagrant virtual machine to run distcc with the armv5
[toolchain used by the Arch Linux ARM project](http://archlinuxarm.org/developers/distcc-cross-compiling):
  ```sh
  git clone https://github.com/bfritz/archlinux-distcc-for-armv5
  cd archlinux-distcc-for-armv5
  vagrant up
  ```

* Verify the armv5 distcc client is running:
  ```sh
  $ nc -v -w3 172.64.1.2 3632
  Connection to 172.64.1.2 3632 port [tcp/distcc] succeeded!
  ```

* Arrange for the Pogoplug or DockStar to have access to `172.64.1.2:3632`
and appear to be on the `172.64.1.0/24` network.  E.g. with Shorewall and
[masquerading](http://www.shorewall.net/manpages/shorewall-masq.html).

* Install and configure distcc on the armv5 device:
  ```sh
  $ sudo pacman -S distcc
  $ grep -e ^BUILDENV -e ^DISTCC -e ^MAKEFLAGS /etc/makepkg.conf
  MAKEFLAGS="-j2"                              # 1 for master + 1 for Vagrant distcc client
  BUILDENV=(distcc color !ccache check !sign)  # `distcc` enabled
  DISTCC_HOSTS="172.12.3.45"                   # host masquerading packets to Vagrant distcc client
  ```
