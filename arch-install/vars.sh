HOSTNAME=MSI
NETWORK_SSID=ATT-phanas
NETWORK_PASSWD=6080700101
SYSTEMD_UNITS=(bluetooth chronyd cups.socket NetworkManager thermald tlp udevmon)

DISK=/dev/nvme0n1
BOOT=${DISK}p1
HOME=${DISK}p2
ROOT=${DISK}p3

SWAP_SIZE=10G
FDISK_CMD="g
n


+256MiB
y
n


+64GiB
y
n



y

t
1
1

t
2
20

t
3
20

w
"
