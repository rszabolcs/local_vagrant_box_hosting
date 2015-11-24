# Hosting vagrant boxes
#### Sets up a nginx server which hosts vagrant boxes

## Requirements
* *nix (tested with Ubuntu 14.04)
* Docker (http://docs.docker.com/engine/installation/)

## Usage
### First time
* Clone the repo.
* Put your box file(s) in the appropriate directories (See `changeme` example).
 * Boxes must be named `<box_name>`_`<version>`.box (e.g. `foo_1.0.box`)
* Run `init.sh`

### Box changes
* Put your box file(s) in the appropriate directories (See `changeme` example).
* Run `generate_manifests.sh`

### Vagrant box url
* The vm box should be named the same as the folder you put the box file into
* The vm box url should be set to the url of the folder

`config.vm.box = "changeme"`

`config.vm.box_url = "http://example.com:1234/vagrant/changeme"`

## Configuration
* You may specify an alternate hostname/port in the .env file in the project root.
 * Host defaults to `hostname --fqdn`
 * Port defaults to `1234`
