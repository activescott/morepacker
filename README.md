# Packer templates
Templates for packer (http://packer.io).

##Misc References & Notes
Last working with packer v0.3.9.

### Packer Notes
	- General example with vmware+ubuntu automatic install: http://www.packer.io/docs/builders/vmware.html
	- Walkthrough of Ubuntu setup: http://kappataumu.com/articles/creating-an-Ubuntu-VM-with-packer.html
	- NOTE: When using vmware builder, packer spins up a HTTP server and seeds a ubuntu cfg preseed file. Explained under the http_directory setting at http://www.packer.io/docs/builders/vmware.html

### Ubuntu-Specific notes
	- https://help.ubuntu.com/12.04/installation-guide/amd64/index.html
	- https://help.ubuntu.com/12.04/installation-guide/amd64/preseed-contents.html
	- https://help.ubuntu.com/lts/installation-guide/amd64/preseed-intro.html
