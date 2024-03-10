<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Daddy91/Configuration-Management-on-Amazon-EC2-with-Chef">
    <img src="images/aws-logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Amazon EC2 configuration Management with Chef</h3>

  <p align="center">
    Step by step tutorial to set up Chef Configuration Management 
    <br />
    <a href="https://github.com/Daddy91/Configuration-Management-on-Amazon-EC2-with-Chef"><strong>Explore the docs »</strong></a>
    <br />
    <br />
  </p>
</div>

<!-- ABOUT THE PROJECT -->
## What is Chef ?

A chef is an automated tool that provides a way to define infrastructure as a code. Code-like infrastructure (IAC) simply means coding infrastructure (default infrastructure) rather than using manual processes.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

Make sure that you have a valide AWS account 


### Step 1: Launch EC2 Instances and install Chef

Before We start to create The cookbook we need to install chef in our ec2 instance for so let’s first install chef-DK.

* Launch an Amazon Linux 2023 server

![Instances Screen Shot][ec2-instances]

* Login to your ec2 instance & update your server package with:

```sh
sudo yum -y update
```

* We need to go chef official website by using the below link & download chef-workstation

[https://docs.chef.io/workstation/install_workstation/#supported-platforms](https://docs.chef.io/workstation/install_workstation/#supported-platforms)

* Go to your ec2 terminal and type

```sh
sudo wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/el/8/chef-workstation-21.10.640-1.el8.x86_64.rpm

```

* Start the Check-workstation installation using the below command.

```sh
sudo yum localinstall chef-workstation-21.10.640-1.el8.x86_64.rpm

```
* After successfully installing chef in our Ec2 Instance you can check using.

```sh
chef -v
```
![Chef Version][chef_version]


### Step 2: Create a cookbook

* From your workstation, create /home/ec2-user/chef-repo/cookbooksdirectory to store your recipes and move to the cookbooksdirectory.

![cookbooksdirectory][cookbooksdirectory]

 * Create a Cookbook, here I am creating a cookbook called firstcookbook using the below command .

 ```sh
chef generate cookbook firstcookbook
```
![create cookbook][create_cookbook]

![create cookbook][create_cookbook2]


### Step 3: Configure the chef's cookbook

We created our cookbook now we have to write our recipe inside that cookbook.

* Open the default.rb on:

```sh
sudo nano firstcookbook/recipes/default.rb
```
* And paste this:

```sh
file '/hpath/to/config.txt' do
  content 'This is a test config template by Daddy on EC2'
  action :create_if_missing
end

# Install cron package
package 'cronie' do
  action :install
end

# Ensure cron service is started and enabled
service 'crond' do
  action [:start, :enable]
end

# Install httpd package
package 'httpd' do
  action :install
end

# Install git package
package 'git' do
  action :install
end

# Clone Node.js app repository
git '/path/to/app_dir' do
  repository 'your repository url'
  action :sync
end

# Start httpd service
service 'httpd' do
  action [:enable, :start]
end

# Start Node.js app
execute 'start_node_app' do
  command 'node /path/to/your/app.js &'
  action :run
end

# Pull cron script from GitHub and run every minute
cron 'run_script' do
  minute '*'
  command 'bash /path/to/your/script.sh'
  action :create
end

```

What we want here is that we want to maintain a config.text file or create it if it does not exist, keep a nodejs app running, install htttpd and git, pull a cron script from github.


### Step 4: Running the cookbook recipe

Now we have almost done with our setup we just need to run the chef-client command.

Сhef Сlient: is аn аgent thаt runs lосаlly оn every nоde thаt is under mаnаgement by Сhef Infrа Server.

Now run the chef­client command that runs our cookbook

```sh
sudo chef-client -zr "recipe[firstcookbook::default]"
```

If all went well this is how it should look.


### Step 5: Set up the client node 


<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Nginx installation](https://www.nginx.com/resources/wiki/start/topics/tutorials/install/)
* [Mariadb Installation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-lamp-amazon-linux-2.html)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[ec2-instances]: images/instance.png
[chef_version]: images/chef_version.png
[cookbooksdirectory]: images/cd_cookbook.png
[create_cookbook]: images/generate_cookbook.png
[create_cookbook2]: images/generate2.png
[run_recipe]: images/run_recipe.png
[AWS-url]: https://aws.amazon.com/?nc2=h_lg
[AWS]: https://img.shields.io/badge/aws-white?style=for-the-badge&logo=amazon&logoColor=yellow
[MariaDB-url]: https://mariadb.org/
[MariaDB]: https://img.shields.io/badge/MariaDb-white?style=for-the-badge&logo=mariadb&logoColor=yellow
[React-url]: https://reactjs.org/
[NGINX-url]: https://www.nginx.com/
[NGINX]: https://img.shields.io/badge/nginx-white?style=for-the-badge&logo=nginx&logoColor=green

