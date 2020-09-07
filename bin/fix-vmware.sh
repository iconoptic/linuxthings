#!/bin/bash

if [ "$EUID" -ne 0 ]; then
		echo "Script must be run as root."
		exit 1
fi

cd /usr/lib/vmware/lib
/bin/cp -afv /usr/lib64/libgio-2.0.so.0.5200.3 libgio-2.0.so.0/libgio-2.0.so.0
/bin/cp -afv /usr/lib64/libglib-2.0.so.0.5200.3 libglib-2.0.so.0/libglib-2.0.so.0
/bin/cp -afv /usr/lib64/libgmodule-2.0.so.0.5200.3 libgmodule-2.0.so.0/libgmodule-2.0.so.0
/bin/cp -afv /usr/lib64/libgobject-2.0.so.0.5200.3 libgobject-2.0.so.0/libgobject-2.0.so.0
/bin/cp -afv /usr/lib64/libgthread-2.0.so.0.5200.3 libgthread-2.0.so.0/libgthread-2.0.so.0

echo "VMWARE_USE_SHIPPED_LIBS=force" >> /etc/vmware/bootstrap

cd /usr/lib/vmware/modules/source
tar -xvf vmnet.tar
tar -xvf vmmon.tar

vmware-modconfig --console --install-all
