#!/bin/bash

##################################################################################################################
#### EDIT THIS LINE TO INCLUDE ANY SUBDIRECTORIES OF THE zoo/cage/ DIRECTORY TO SYMLINK INTO YOUR PROJECT     ####
zoo_cages_to_symlink=( base ui video ) # available cages: base video guru guru_channel_tools guru_video_tools
#### (As you define more cages, please make a note of them above to be sure new projects know they're there.) ####
##################################################################################################################

project_dir=.
project_cage_dir=$project_dir/cage

zoo_items_to_copy=( config.preprocess.rb setup_only/package.json Gruntfile.coffee coffee index.html .gitignore )
zoo_dirs_to_symlink=( cage_template )

# echo "Please enter the path to the Zoo project directory: (would typically be ../zoo) "
# read zoo_dir
zoo_dir=../../zoo

for zoo_item_to_copy in "${zoo_items_to_copy[@]}"
do
	echo $"Copying $zoo_dir/$zoo_item_to_copy to $project_dir/$zoo_item_to_copy"
	cp -rn $zoo_dir/$zoo_item_to_copy $project_dir
done

for zoo_dir_to_symlink in "${zoo_dirs_to_symlink[@]}"
do
	echo $"Linking $zoo_dir/$zoo_dir_to_symlink to $project_dir/$zoo_dir_to_symlink"
	ln -s $zoo_dir/$zoo_dir_to_symlink $project_dir
done

mkdir -p $project_cage_dir

zoo_dir=../$zoo_dir
zoo_cage_dir=$zoo_dir/cage
for cage_to_symlink in "${zoo_cages_to_symlink[@]}"
do
	echo $"Linking $zoo_cage_dir/$cage_to_symlink to $project_cage_dir/$cage_to_symlink"
	ln -s $zoo_cage_dir/$cage_to_symlink $project_cage_dir
done

echo
echo $"Make sure you have node and npm installed by downloading and installing the Node installer from Node here: http://nodejs.org/download/"
read -p $"If/When that's installed, press any key..." -n 1 -s

echo
read -p $"Do you have Coffeescript for Node (y/n)?" -n 1 hasCoffee

if  [ "$hasCoffee" == 'n' ]; then
	echo
	echo $"Installing Coffee for Node"
	npm install -g coffee-script

	if [ $? -ne 0 ]; then
		echo
		echo $"That didn't work, so trying with sudo..."
		sudo npm install -g coffee-script
	fi
fi

echo
read -p $"Do you have SASS, Compass and the Animation Library for Ruby (y/n)?" -n 1 isSassy

if [ "$isSassy" == 'n' ]; then
	echo
	echo $"Installing Compass for Ruby (and therefore also SASS)"
	gem install compass

	if [ $? -ne 0 ]; then
		echo
		echo $"That didn't work, so trying with sudo..."
		sudo gem install compass
	fi

	echo
	echo $"Installing Animation for Ruby (or for Compass really - it's a library for Compass/SASS)"
	gem install animation --pre

	if [ $? -ne 0 ]; then
		echo
		echo $"That didn't work, so trying with sudo..."
		sudo gem install animation --pre
	fi
fi

echo
read -p $"Do you have Grunt for Node (y/n)?" -n 1 canGrunt

if [ "$canGrunt" == 'n' ]; then
	echo
	echo $"Installing Grunt"
	npm install -g grunt-cli

	if [ $? -ne 0 ]; then
		echo
		echo $"That didn't work, so trying with sudo..."
		sudo npm install -g grunt-cli
	fi
fi

echo $"Installing the Node modules necessary for Grunt to run (given in package.json) by running 'npm install'"
npm install

echo $"Running grunt"
grunt

echo $"Running grunt watch"
grunt watch