Fiddlevent
==========
This is a [Ruby on Rails](http://rubyonrails.org/) project for my [ASU](http://asu.edu/) (Arizona State University
[Honors Thesis / Creative Project](http://barretthonors.asu.edu/academics/thesis-and-creative-project/) in the 
ASU [Computer Science Department](http://cidse.engineering.asu.edu/).

This README file assumes unfamiliarity with Ruby on Rails development.

## About Fiddlevent
*Fiddlevent* is an event searching Web site developed from scratch. Fiddlevent contains two different types of users:

* **Merchant** — a merchant is a user who can create events on the Web site for normal users to see.
* **Guest** — an anonymous user who can search for events and "like" events.
* **Customer** — same as a guest, but has login abilities.

Fiddlevent also provides *Filters*, which allows users to narrow down their search results.

## Prerequisites
This application requires the following:
* [MySQL](http://www.mysql.com/), tested with version 5.6
* [Ruby 1.9.3](http://www.ruby-lang.org/en/)

In addition, **it is strongly recommended you use a Mac or Linux environment for this project**!

All other prerequisites / dependencies are installed automatically as part of [Ruby Gems](http://rubygems.org), included with Ruby 1.9.3

## Setup (Mac)
### Setup a Ruby / Rails Environment
You will only need to do these steps once to set up a Ruby / Rails environment.
You should do the following at the same time:
* Download and install [Xcode](https://developer.apple.com/xcode/) from the 
  [Mac App Store](http://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12). Afterwards, Open Xcode and 
  install the developer (command line) tools.

* Download and install the latest [MySQL](http://dev.mysql.com/downloads/mysql/) (I *strongly* suggest you download
  the DMG file)
  
* Download, but **do not install** [MacPorts](http://www.macports.org/).

After you have installed Xcode and installed the developer tools, you will need to install MacPorts and the ImageMagick gem.  **This may take over an hour to complete and you can install other programs at the same time.** 

* Install [MacPorts](http://www.macports.org/).
* Once MacPorts has been installed, you need to install [ImageMagick](http://www.imagemagick.org/). Open the
  Terminal app and type `sudo port install ImageMagick`

Mac comes with Ruby 1.8 installed and we want Ruby 1.9.3. To do this, I suggest you install [RVM](https://rvm.io/) (Ruby Version Manager). In the Terminal, type:

	$ \curl -L https://get.rvm.io | bash -s stable --ruby

### Suggested Software
Some software that you may find useful:

* [MySQL Workbench](http://dev.mysql.com/downloads/workbench/) for viewing data in the MySQL database
* [GitHub for Mac](http://mac.github.com/), if you're only using GitHub
* [SourceTree](https://itunes.apple.com/us/app/sourcetree-git-hg/id411678673?mt=12) for more advanced Git features
* [Komodo Edit](http://www.activestate.com/komodo-edit), a free editor for Mac, Linux and Windows.
* [TextWrangler](https://itunes.apple.com/us/app/textwrangler/id404010395?mt=12), a free all-purpose text editor
  for mac
  
### Project Setup
Once you've set up your environment, setting up the application, and any other Rails applications, is much easier.
Open up the terminal and follow these instructions:

1. Check out a read-only working copy of the git repository:

		git clone git://github.com/cgthornt/Fiddlevent.git fiddlevent

2. Install project-specific dependencies:

		cd fiddlevent
		bundle

3. Set up the local database:

		rake db:setup
		rake db:migrate

4. Run the rails app:

		rails s
		
5. You're done! Visit the application at `http://localhost:3000`

## Setup (Linux)
This assumes you're using Ubuntu.
### The Ruby / Rails Environment
The linux environment is much easier to setup than the Mac environment. You only need to set up your environment once.

1. Install some packages:
		
		sudo apt-get install git build-essential libmagickwand-dev imagemagick libmysqlclient-dev mysql-server \
			libxml2-dev libxslt1-dev
   
   Also, you will need [node.js](http://nodejs.org/). If you're using a newer version of ubuntu, you can install
   it using the package manager. Otherwise, you will need to download and install it manually.
   
   		sudo apt-get install nodejs
		
2. Install [RVM](https://rvm.io) (suggested):

		$ \curl -L https://get.rvm.io | bash -s stable --ruby


### Project Setup
The setup is exactly the same as the Mac version. 

Just note that you will need to change the MySQL socket path in the `config/database.yml` file. Alternatively, you
can configure MySQL's socket path to `/tmp/mysql.sock`, or you can symlink it **(UNTESTED)**:

	ln -s /var/run/mysqld/mysqld.sock /tmp/mysql.sock
	
You may consider making a startup script to symlink on startup.

## Setup (Windows)
Best of luck! (You'll need it)

## Copyright / License (Creative Commons)
This is released under the [Creative Commons Attribution 3.0 Unported license](http://creativecommons.org/licenses/by/3.0/). This means that:

* You can use this software freely, for for-profit or non-profit
* You can modify this software as much as you want
* You **must** attribute your use of this project to me, Christopher Thornton. See below for details.

### Attribution
If you use this project for your own use, you must attribute the use of this project to me, Christopher Thornton. You must link to my Web site, [http://cgthornt.com](http://cgthornt.com). This must be done in such a way that *does not* suggest that I endorse your use of the work.

### License Details
You are free:
* **to share** — to copy, distribute and transmit this work
* **to remix** — to adapt the work
* to make commercial use of the work

Under the following conditions:
* **Attribution** - You must attribute the work in the manner specified by the author or licensor 
  (but not in any way that suggests that they endorse you or your use of the work). See Below.

With the understanding that:
* **Waiver** - Any of the above conditions can be <u><b>waived</b></u> if you get permission from the 
  copyright holder.

* **Public Domain** - Where the work or any of its elements is in the <u><b>public domain</b></u> under 
  applicable law, that status is in no way affected by the license.

* **Other Rights** — In no way are any of the following rights affected by the license:
	* Your fair dealing or <u><b>fair use</b></u> rights, or other applicable copyright exceptions and limitations;
	* The author's <u><b>moral</b></u> rights
	* Rights other persons may have either in the work itself or in how the work is used, 
	  such as <u><b>publicity</b></u> or privacy rights.
	  
* **Notice** — For any reuse or distribution, you must make clear to others the license terms of this work. 
  The best way to do this is with a link to this web page.
	

Please read the [Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/) for more information.
