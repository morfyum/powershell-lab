# Basics 

## Windows 11 developement environment:
https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/

## Red Hat Inc (SPICE) QEMU/KVM VGA driver for VM
URL: https://spice-space.org/
GUEST TOOLS: https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe


# LINUX KVM, AND QEMU SUPPORT ONLY .qcow2, AND .raw FORMATS.
> Virtual Box exdition is `.ova` file. First of all, we need to convert into `.qcow2` format.

## Extract downloaded file:

```sh
# Extract VirtualBoxImage (.ova) file
tar xvf VirtualBoxImage.ova

# After done, we get 2 files. One of this is a `.vmdk` -> Convert to `qcow2` 
qemu-img convert -O qcow2 VirtualBoxImage.vmdk myVMImage.qcow2
```

