# NixOS version
NIXOS_VERSION ?= 24.05
NIXOS_URL ?= https://channels.nixos.org/nixos-$(NIXOS_VERSION)/latest-nixos-minimal-aarch64-linux.iso

# Connectivity info for NixOS VM
NIXOS_ADDR ?= unset
NIXOS_PORT ?= 22
NIXOS_USER ?= plumps

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# The name of the nixosConfiguration in the flake
NIXOS_NAME ?= shit-de-blk-ew4-srv-01

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS=-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

# We need to do some OS switching below.
UNAME := $(shell uname)

switch:
ifeq ($(UNAME), Darwin)
	nix build --extra-experimental-features nix-command --extra-experimental-features flakes ".#darwinConfigurations.${NIXOS_NAME}.system"
	./result/sw/bin/darwin-rebuild switch --flake "$$(pwd)#${NIXOS_NAME}"
else
	sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --flake ".#${NIXOS_NAME}"
endif

test:
ifeq ($(UNAME), Darwin)
	nix build ".#darwinConfigurations.${NIXOS_NAME}.system"
	./result/sw/bin/darwin-rebuild test --flake "$$(pwd)#${NIXOS_NAME}"
else
	sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild test --flake ".#$(NIXOS_NAME)"
endif

# Gets the needed ISO
vm/iso:
		@echo "Downloading ISO from $(NIXOS_URL)..."
		curl -L -o $(notdir $(NIXOS_URL)) $(NIXOS_URL)

# bootstrap a brand new VM. The VM should have NixOS ISO on the CD drive
# and just set the password of the root user to "root". This will install
# NixOS. After installing NixOS, you must reboot and set the root password
# for the next step.
#
# NOTE(mitchellh): I'm sure there is a way to do this and bootstrap all
# in one step but when I tried to merge them I got errors. One day.
vm/bootstrap0:
	ssh $(SSH_OPTIONS) -p$(NIXOS_PORT) root@$(NIXOS_ADDR) " \
		parted /dev/vda -- mklabel gpt; \
		parted /dev/vda -- mkpart primary 512MB -8GB; \
		parted /dev/vda -- mkpart primary linux-swap -8GB 100\%; \
		parted /dev/vda -- mkpart ESP fat32 1MB 512MB; \
		parted /dev/vda -- set 3 esp on; \
		sleep 1; \
		mkfs.ext4 -L nixos /dev/vda1; \
		mkswap -L swap /dev/vda2; \
		mkfs.fat -F 32 -n boot /dev/vda3; \
		sleep 1; \
		mount /dev/disk/by-label/nixos /mnt; \
		mkdir -p /mnt/boot; \
		mount /dev/disk/by-label/boot /mnt/boot; \
		nixos-generate-config --root /mnt; \
		sed --in-place '/system\.stateVersion = .*/a \
			nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
			services.openssh.enable = true;\n \
			services.openssh.settings.PasswordAuthentication = true;\n \
			services.openssh.settings.PermitRootLogin = \"yes\";\n \
			users.users.root.initialPassword = \"root\";\n \
		' /mnt/etc/nixos/configuration.nix; \
		nixos-install --no-root-passwd && reboot; \
	"

# after bootstrap0, run this to finalize. After this, do everything else
# in the VM unless secrets change.
vm/bootstrap:
	NIXOS_USER=root $(MAKE) vm/copy
	NIXOS_USER=root $(MAKE) vm/switch
	$(MAKE) vm/secrets
	ssh $(SSH_OPTIONS) -p$(NIXOS_PORT) $(NIXOS_USER)@$(NIXOS_ADDR)

# copy our secrets into the VM
vm/secrets:
	# GPG keyring
	rsync -av -e 'ssh $(SSH_OPTIONS)' \
		--exclude='.#*' \
		--exclude='S.*' \
		--exclude='*.conf' \
		$(HOME)/.gnupg/ $(NIXOS_USER)@$(NIXOS_ADDR):~/.gnupg
	# SSH keys
	rsync -av -e 'ssh $(SSH_OPTIONS)' \
		--exclude='environment' \
		$(HOME)/.ssh/ $(NIXOS_USER)@$(NIXOS_ADDR):~/.ssh

# copy the Nix configurations into the VM.
vm/copy:
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXOS_PORT)' \
		--exclude='vendor/' \
		--exclude='.git/' \
		--exclude='.git-crypt/' \
		--exclude='iso/' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ $(NIXOS_USER)@$(NIXOS_ADDR):/nixos-config

# run the nixos-rebuild switch command. This does NOT copy files so you
# have to run vm/copy before.
vm/switch:
	ssh $(SSH_OPTIONS) -p$(NIXOS_PORT) $(NIXOS_USER)@$(NIXOS_ADDR) " \
		sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --show-trace --flake \"/nixos-config#${NIXOS_NAME}\" \
	"