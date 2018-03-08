#!/bin/bash
set -e
cd `dirname $0`
. .env

# Iterate over all folders
echo
for box_dir in ./html/vagrant/*/
do
  echo "Generating manifest for $box_dir"
  pushd $box_dir/boxes >/dev/null

  # Folder name should be the box name
  name="`basename $box_dir`"

  # Write manifest to the tmp dir until we succeed and then we'll move it into place
  tmp_manifest_file="/tmp/$name.json"

  # Write the beginning of the manifest file
  echo -n "{\"name\":\"$name\",\"description\":\"This box provides $name\",\"versions\":[" > $tmp_manifest_file

  # Iterate over all boxes for the name
  first="true"
  for box_file in *.box
  do
    echo "  Box file is $box_file"

    # Parse version out of the box file
    version="`echo $box_file | sed -re "s@^${name}_([.0-9]+).box@\1@g"`"
    if [ "$version" = "" ] || [ "$version" = "$box_file" ]
    then
      echo "Unable to parse version from [ $box_file ]. Please check the required format"
      exit 1
    fi
    echo "  Parsed name [ $name ] and version [ $version ]"

    # Generate sha256 checksum
    echo "  Generating sha256 checksum"
    checksum="`sha256sum $box_file | awk '{print $1}'`"

    # Fencepost problem
    if [ "$first" = "true" ]
    then
      first="false"
    else
      echo -n "," >> $tmp_manifest_file
    fi

    # Write the json for the current box
    echo -n "{\"version\":\"$version\",\"providers\":[{\"name\":\"virtualbox\",\"url\":\"http://$cfg_hostname:$cfg_port/vagrant/$name/boxes/$box_file\",\"checksum_type\":\"sha256\",\"checksum\":\"$checksum\"}]}" >> $tmp_manifest_file
    echo
  done
  echo "]}" >> $tmp_manifest_file

  popd > /dev/null

  # Move manifest file into the appropriate location
  mv $tmp_manifest_file `dirname $box_dir`
done
echo

# Bounce nginx
./restart.sh
