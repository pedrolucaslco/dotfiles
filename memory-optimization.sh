#!/bin/bash

# linux optimization

# instalar zram
sudo apt install systemd-zram-generator

# editar configurações
sudo nano /etc/systemd/zram-generator.conf

#substituir conteúdo do arquivo por isso
[zram0]
zram-size = ram * 1.25
compression-algorithm = zstd
swap-priority = 100
# --------

#!/bin/bash

RAM_GB=$(free -g | awk '/Mem:/ {print $2}')
SWAP_GB=$((RAM_GB + RAM_GB / 4))

echo "Criando swap de ${SWAP_GB}GB"

sudo swapoff -a

sudo rm -f /swapfile
sudo rm -f /swap.img
sudo fallocate -l ${SWAP_GB}G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

grep -q "/swapfile" /etc/fstab || \
echo "/swapfile none swap sw,pri=10 0 0" | sudo tee -a /etc/fstab

swapon --show

sudo systemctl restart systemd-zram-setup@zram0

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0


#pedir pra criar um scrit pra configurar swap como 1.25 da ram

# configuar swap (pendente)

4️⃣ KERNEL VM TUNING (onde o Linux ganha cérebro)

Crie:

sudo nano /etc/sysctl.d/99-memory-tuning.conf


Cole exatamente isso:

vm.swappiness=180
vm.vfs_cache_pressure=50
vm.page-cluster=0
vm.watermark_boost_factor=0
vm.watermark_scale_factor=125
vm.dirty_background_ratio=5
vm.dirty_ratio=10
vm.compaction_proactiveness=0

Aplique:

sudo sysctl --system


# system-oomd
sudo systemctl enable --now systemd-oomd

Configure:

sudo nano /etc/systemd/oomd.conf


Use:

[OOM]
SwapUsedLimit=95%
DefaultMemoryPressureLimit=80%

# ----------------------------------

7️⃣ CPU GOVERNOR — BATERIA ANTIGA, SEM LENTIDÃO

Instale:

sudo apt install power-profiles-daemon


Use:

powerprofilesctl set balanced


E force boost inteligente:

sudo nano /etc/sysctl.d/99-cpu.conf

kernel.sched_autogroup_enabled=1
kernel.sched_migration_cost_ns=5000000


📌 Ryzen responde rápido sem sugar bateria.

# disable unused services 

sudo systemctl disable --now cups cups-browsed
sudo systemctl disable --now unattended-upgrades packagekit
sudo systemctl disable --now snapd
sudo systemctl disable --now ModemManager

sudo systemctl disable --now update-notifier-download.timer

sudo systemctl disable --now snapd.snap-repair.timer
sudo systemctl disable --now ua-timer.timer
sudo systemctl disable --now apt-daily.timer apt-daily-upgrade.timer

sudo systemctl disable --now cloud-config cloud-final cloud-init-local cloud-init cloud-init-network

sudo systemctl disable sysstat.service
sudo systemctl stop sysstat.service

sudo apt purge sysstat
sudo systemctl disable --now sysstat

sudo systemctl disable --now apport

sudo systemctl disable --now snapd.service snapd.apparmor snapd.autoimport snapd.core-fixup snapd.recovery-chooser-trigger snapd.seeded snapd.system-shutdown


# -----

3️⃣ O PULO DO GATO: CONGELAMENTO AUTOMÁTICO DE APPS INATIVOS

Isso é o que você quer.
E é 100% kernel + systemd, não gambiarra.

Crie overrides de usuário:
    sudo mkdir -p /etc/systemd/system/user@.service.d
    sudo nano /etc/systemd/system/user@.service.d/memory.conf
    
    
    Cole:
        
        [Service]
        MemoryPressureWatch=yes
        MemoryPressureThreshold=70%
        MemoryHigh=76%
        MemoryMax=80%
        
        
        O que isso faz:
            
            Quando a pressão sobe
            
sudo systemctl daemon-reexec
