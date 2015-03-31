Basic Usage: For an initial build
sudo <make> prepare; <make> build

Basic Usage: For a completely clean build
sudo <make> uninstall prepare; <make> build

Intermediate Usage:
sudo	<make> prepare
	The above command ensures that system paths are created with correct permissions for current user

<make> [arch] [getcompilers={make,fetch}] build
	This command accomplishes a build including compilers and depends

<make> [arch] depends
	The above command installs dependencies for facter

<make> [arch] facter-<version>
	The above command compiles facter

<make> clean
	Recursively cleans (* Only on full builds *)
<make> clobber
	Removes source/ build/ install/
sudo	<make> uninstall
	Removes the installation
