# Packer templates
Templates for packer (http://packer.io, [mitchellh/packer](https://github.com/mitchellh/packer)).

## Packer Images
- ubuntu-server-simple: Simplest ubuntu server image. My "hello world" for packer.
- win2008r2-standard: My basic windows server 2008R2 + SP1 image.
- win2008r2-standard-chef-solo: Chef-solo provisioner working via ssh on windows. 
	- Note: It uses cmd.exe to launch chef-solo since some cookbooks get confused and break if run directly from cygwin.
	- Note: The ssh > cmd.exe hacks may not be necessary if/when [packer adds winrm support](https://github.com/mitchellh/packer/issues/451).

## Misc References & Notes
Last working with packer v0.3.9.
Thanks to [misheska/basebox-packer](https://github.com/misheska/basebox-packer) for the windows Autounattend.xml and related .bat files.

### Packer Notes
- Google group (search it!): https://groups.google.com/forum/#!forum/packer-tool
- General example with vmware+ubuntu automatic install: http://www.packer.io/docs/builders/vmware.html
- Walkthrough of Ubuntu setup: http://kappataumu.com/articles/creating-an-Ubuntu-VM-with-packer.html
- NOTE: When using vmware builder, packer spins up a HTTP server and seeds a ubuntu cfg preseed file. Explained under the http_directory setting at http://www.packer.io/docs/builders/vmware.html

### Ubuntu-Specific Notes
- Details on how to setup and actually use a preseed: https://help.ubuntu.com/12.04/installation-guide/amd64/preseed-using.html
- Details on the content of a preseed file: https://help.ubuntu.com/12.04/installation-guide/amd64/preseed-contents.html
- Preseed introduction: https://help.ubuntu.com/lts/installation-guide/amd64/preseed-intro.html
