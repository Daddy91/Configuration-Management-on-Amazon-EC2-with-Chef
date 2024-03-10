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


### Built With

* [![AWS EC2][AWS]][AWS-url]
* [![MariaDB][MariaDB]][MariaDB-url]
* [![NGINX][NGINX]][NGINX-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

Make sure that you have a valide AWS account 

### Prerequisites

1. AWS account with permissions to create EC2 instances and security groups.
2. Basic knowledge of Linux, AWS EC2, MariaDB, and Nginx.
3. Two EC2 instances running Ubuntu 20.04 (or any other Linux distribution of your choice) for MariaDB servers.
4. One EC2 instance for Nginx load balancer.


### Step 1: Launch EC2 Instances

Launch three EC2 instances with Ubuntu 20.04:

* 2 instances for MariaDB servers
* 1 instance for Nginx load balancer

Ensure proper security groups and inbound/outbound rules are configured to allow necessary traffic.

[![Instances Screen Shot][ec2-instances]]

### Step 2: Install MariaDB on MariaDB Instances

1. SSH into each MariaDB instance using your prefered tool. I used MobaXterm to SSH into my instances.

2. Install MariaDB server using the link below from AWS

[https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-lamp-amazon-linux-2.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-lamp-amazon-linux-2.html)


### Step 3: Configure MariaDB Master-Master Replication

* Edit the MariaDB configuration 'my.cnf' file on both instances (Master1 and Master2) to enable replication. You'll need to configure server-id, binlog settings, and define a replication user.
```sh
sudo nano /etc/my.cnf
```

[![Mariadb conf Screen Shot][mariadb-conf]]

* Then, restart MariaDB to apply the changes:
```sh
sudo systemctl restart mariadb
```

### Step 4: Create Replication User

connect to your database and create a user on both servers that will be used for replication. Replace <user> and <password> with your desired username and password.
```sh
mysql -u root -p
```

```sql
CREATE USER '<user>'@'%' IDENTIFIED BY '<password>';
GRANT REPLICATION SLAVE ON *.* TO '<user>'@'%';
FLUSH PRIVILEGES;
```

### Step 5: Backup

Take a consistent backup of one of the databases and restore it on the other. You can use 'mysqldump' or any other backup method you prefer.

### Step 6: Replication

On each server, configure replication to the other server. First, get the binary log file and position from the backup taken earlier.

```sql
SHOW MASTER STATUS;
```
[![Mariadb master status Screen Shot][mariadb-master-status]]

Then, on the other server, use this information to configure replication

```sql
CHANGE MASTER TO MASTER_HOST='<IP of the other server>', MASTER_USER='<user>', MASTER_PASSWORD='<password>', MASTER_LOG_FILE='<log file>', MASTER_LOG_POS=<log position>;
```

Start replication

```sql
START SLAVE;
```

And repeat the same process on the other server but with the opposite configuration and check if everything is ok.

```sql
SHOW SLAVE STATUS\G
```
[![Mariadb master status Screen Shot][mariadb-slaves-status]]

### Step 7: Test Replication

Verify that replication is working by creating/modifying data on both servers and checking if changes are propagated to the other server. I created a database called 'daddydb' and it propagated to other server.

[![database Screen Shot][database]]


### Step 8: Configure Nginx for load balancing

NGINX is open-source web server software used for reverse proxy, load balancing, and caching. It provides HTTPS server capabilities and is mainly designed for maximum performance and stability. Keep in mind that Nginx does not have specific fonctionalities for database management, using MaxScale would be a better choice but I wanted to try out with Nginx.

1. Connect to the Nginx server usind SSH

2. Make sure the system packages are up to date. Run the following commands in your terminal or SSH into your instance

```sh
sudo yum update -y
```
This will update all the installed packages to their latest versions.

3. Install Nginx


```sh
sudo amazon-linux-extras install nginx1.12
```
By using amazon-linux-extras, we can easily install the latest stable version of Nginx available for Amazon Linux 2.

4. We can now start the Nginx service and have it run automatically when the system boots

```sh
sudo systemctl start nginx sudo systemctl enable nginx
```

Verify its status by executing

```sh
sudo systemctl status nginx
```

5. Configure Nginx as a TCP load balancer to distribute database connections evenly between the two MariaDB instances by modifying the '/etc/nginx/nginx.con/' file.

Make sure to put it on the top, after the events module.

```sh
stream {
    upstream mariadb_cluster {
        server <IP_of_master1>:3306;
        server <IP_of_master2>:3306;
    }

    server {
        listen 3306;
        proxy_pass mariadb_cluster;
    }
}
```
And restart Nginx to apply the configuration

### Step 9: Testing

Test the load balancing by connecting to the Nginx load balancer and ensuring that database connections are distributed between the MariaDB instances.

You can try to connect to your MySQL (or MariaDB) database server through Nginx using MySQL Workbench.

[![mysqlwb Screen Shot][mysqlbw]]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Conclusion

Congratulations! You have successfully configured MariaDB Master-Master replication on AWS EC2 instances with Nginx load balancing. You can now scale your database infrastructure horizontally and handle increased traffic efficiently.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Nginx installation](https://www.nginx.com/resources/wiki/start/topics/tutorials/install/)
* [Mariadb Installation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-lamp-amazon-linux-2.html)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[ec2-instances]: images/instances.png
[mariadb-conf]: images/mariadbconf.png
[mariadb-master-status]: images/masterstatus.png
[mariadb-slaves-status]: images/slavestatus.png
[mysqlbw]: images/mysqlwb.png
[database]: images/showdatabases.png
[AWS-url]: https://aws.amazon.com/?nc2=h_lg
[AWS]: https://img.shields.io/badge/aws-white?style=for-the-badge&logo=amazon&logoColor=yellow
[MariaDB-url]: https://mariadb.org/
[MariaDB]: https://img.shields.io/badge/MariaDb-white?style=for-the-badge&logo=mariadb&logoColor=yellow
[React-url]: https://reactjs.org/
[NGINX-url]: https://www.nginx.com/
[NGINX]: https://img.shields.io/badge/nginx-white?style=for-the-badge&logo=nginx&logoColor=green

