#!/bin/bash

# Copyright 2025 Christoph Willing,  Sydney Australia
# All rights reserved
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# If an NVIDIA module has been installed for a previous kernel version,
# update the nvidia kernel module for the new kernel.
#
# Requires: dkms


[ -z $KERNEL_VERSION ] && {
  echo "  No KERNEL_VERSION provided. Exiting now."
  exit
}
echo "Checking status of NVIDIA kernel module..."

if [ -x /usr/sbin/dkms ]; then
  # Find existing NVIDIA module
  NVIDIA_MODULE=$(dkms status |grep nvidia |tail -1|cut -d',' -f1|cut -d: -f1)

  # If there is a previously installed NVIDIA module
  if [ x"$NVIDIA_MODULE" = "x" ]; then
    echo "  No DKMS installed NVIDIA kernel module found."
  else
    echo "  Found NVIDIA_MODULE = $NVIDIA_MODULE"
    # Is it already installed for this kernel version?
    if [ "$(dkms status -m nvidia -k $KERNEL_VERSION |cut -d' ' -f 4)" = "installed" ]; then
      # Nothing to do
      echo "  Module $NVIDIA_MODULE is already installed for kernel $KERNEL_VERSION."
    else
      # Update NVIDIA kernel module for new kernel version
      echo "  Installing NVIDIA kernel module $NVIDIA_MODULE for kernel version $KERNEL_VERSION:"
      dkms install $NVIDIA_MODULE -k $KERNEL_VERSION
    fi
  fi
fi

