{ inputs, config, lib, pkgs, pkgs-stable, pkgs-old, modulesPath, ... }:

{
	# musnix = {
	# 	enable = true;
	# 	# kernel.realtime = true;
	# 	# kernel.packages = pkgs.linuxPackages_latest_rt;
	# 	# soundcardPciId = "2f:00.4";
	# };

	boot = {
		# kernelParams = [ "kvm.enable_virt_at_load=0" ];
		initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
		initrd.kernelModules = [ "amdgpu" ];
		extraModulePackages = [ ];

		# kernelPackages = pkgs.linuxPackages_latest;
		kernelPackages = pkgs.pkgs.linuxPackages_6_12; # required to match w/ virtualbox
		supportedFilesystems = [ "ntfs" ];
		loader = {
			efi = {
				efiSysMountPoint = "/boot/efi";
			};
			grub = {
				efiSupport = true;
				efiInstallAsRemovable = true;
				device = "nodev";
			};
		};
	};


	fileSystems."/".device = "/dev/disk/by-label/nixos";
	fileSystems."/boot/efi".device = "/dev/disk/by-label/NIXOS_EFI";

	fileSystems."/mnt/hdd-data".device = "/dev/disk/by-label/hdd-data";

	fileSystems."/mnt/nero-priv-data".device = "/dev/disk/by-label/nero-priv-data";
	fileSystems."/mnt/nero-pub-data" =
	{
		device = "/dev/disk/by-label/nero-pub-data";
		fsType = "ntfs";
		options = [
			"ntfs-3g"
			"uid=1000"
			"gid=100"
			"umask=002"
			"0"
			"2"
		];
	};

	swapDevices = [{ device = "/dev/disk/by-uuid/fa2d35b2-c349-42bd-b735-a5c71417f950"; }];

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.enableRedistributableFirmware = true;
	hardware.cpu.amd.updateMicrocode = true;

    environment.variables = {
        RUSTICL_ENABLE = "radeonsi";
    };

	hardware = {
        # amdgpu.opencl.enable = true;
        graphics = {
            enable = true;
            enable32Bit = true;

            extraPackages = [
                pkgs.rocmPackages.clr.icd
                pkgs.mesa.opencl # Enables Rusticl (OpenCL) support
            ];
        };
    };
}
