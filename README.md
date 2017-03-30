Demonstrates a bug that an exit code in a windows-shell provisioner doesn't cancel the build.

**Specifics:**

 * Guest OS: Windows (Server 2012 R2)
 * Communicator: SSH ([mls-software SSH server](https://chocolatey.org/packages/mls-software-openssh))
 * Provisioner: windows-shell

**Details:**

We'll first build a base image (`vbox-2012r2.json`) to make analysis of the bug less time consuming.

The bug itself can be reproduced with the template `vbox-2012r2-bugged.json`. It builds on top of the base image.

In this template, just to show the bug, there is a provisioner like this:

	{
		"type": "windows-shell",
		"inline": "exit 1"
	}

This should fail the build (because of the exit code `1`) but it doesn't.

**How to reproduce:**

*Note:* I've only tested this behavior on Windows. `ssh` is provided by "Git for Windows".

1. Build base image: `packer build -force vbox-2012r2.json`

   On the first run, it will take some time to download the .iso image.

1. Build bugged image: `packer build -force vbox-2012r2-bugged.json`

You'll notice that this build won't error out. Packer will consider it successful.

**Versions:**

 * Windows: 8.1 or 10
 * packer: 0.12.3
 * VirtualBox: 5.0.36 (5.1 has bug with floppy disk on shutdown)
 * ssh: OpenSSH_7.3p1, OpenSSL 1.0.2j  26 Sep 2016
