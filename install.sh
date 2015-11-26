
#!/bin/bash


sudo apt-get install tklib tcltls
if [ ! -d "$DIRECTORY" ]; then
  mkdir -p ~/pd-externals
fi
cp "pdpk-plugin.tcl" ~/pd-externals
