Story
==========
[Teamcity should produce Packer (http://www.packer.io/) machine images.](https://trello.com/c/wytrQijk)

TODO
==========
+ Setup basic JeOS box with packer.
- Manually install chef
     + Using (from http://www.packer.io/docs/provisioners/chef-solo.html):   curl -L https://www.opscode.com/chef/install.sh | {{if .Sudo}}sudo{{end}} bash 
          + NOPE: Doesn't work on windows.
          + Note: http://docs.opscode.com/plugin_knife_windows.html
          + NOTE: http://technet.microsoft.com/en-us/library/cc759262(v=ws.10).aspx
          + try https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/x86_64/chef-client-11.4.4-2.windows.msi
               MSIFNAME=chef-client-11.4.4-2.windows.msi
               MSINOUI=/qn
               MSILOG=/L* $MSIFNAME.log
               msiexec /i $MSIFNAME $MSINOUI $MSILOG
               ==
               + curl -L https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/x86_64/chef-client-11.4.4-2.windows.msi > /tmp/chef-client-11.4.4-2.windows.msi
               NOPE: cmd.exe /C msiexec /qn /I c:\cygwin\tmp\chef-client-11.4.4-2.windows.msi /L* c:\cygwin\tmp\chef-client-11.4.4-2.windows.msi.log
               WORKS: cd /tmp && msiexec /qn /I chef-client-11.4.4-2.windows.msi /Lime chef-client-11.4.4-2.windows.msi.log
               WORKS: cd /tmp && curl -L https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/x86_64/chef-client-11.4.4-2.windows.msi > /tmp/chef-client-11.4.4-2.windows.msi && msiexec /qn /I chef-client-11.4.4-2.windows.msi /Lime chef-client-11.4.4-2.windows.msi.log
          + requires curl
+ install curl in initial setup
+ setup a chef bootstrap: 
     cd /tmp && curl -L https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/x86_64/chef-client-11.4.4-2.windows.msi > /tmp/chef-client-11.4.4-2.windows.msi && msiexec /qn /I chef-client-11.4.4-2.windows.msi /Lime chef-client-11.4.4-2.windows.msi.log
- Get the most basic chef recipe working on the machine:
     - google-chrome
     - 7-zip
     - Git?
     - daptiv_visualstudio?
     - resharper 
- Ensure network adapter is "private to my mac"
     - vmware vmx setting?

- Role cookbook for test-workstation?
     - 
- fork morepacker to daptiv-specific repo.





-
NOTE: 
"_comment":
"cookbook_paths won't work for us since we're using cmd.exe via ssh (MichaelM explained cookbooks don't like being run directly from cygwin/ssh, so i'm using cmd.exe) and the solo.rb has a posix path in it (since packer is using SSH) and chef can't find the cookbook dir. So we use a file provioner above to uplaod cookbooks and a config_template below to templetize solo.rb (whichseems useful in it's own right)",


"_comment": "upload cookbooks to /tmp/cookbooks (which is going to be c:\\cygwin\\tmp\\cookbooks) - we'll use this path in our config_template below",