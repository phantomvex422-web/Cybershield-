# Cybershield-Cloud Server Project
  
**Assignment  | Individual

> A WordPress site deployed on AWS EC2 (Ubuntu), served via Apache, secured with SSL/TLS, and linked to a custom domain via AWS Route 53.

---

## 🌐 Site Details

| Field | Value |
|-------|-------|
| Domain | `cybershieldme.info` |
| IP Address | `113.50.212.235` (Elastic IP) |
| Hosting | AWS EC2 — Ubuntu 20.04 |
| Status | Offline (AWS free tier expired) |

> 📸 Screenshots of the live site are included in the documentation folder and in this README below.

---

## 🧰 Tech Stack

| Layer | Technology |
|-------|-----------|
| Cloud Provider | AWS EC2 |
| OS | Ubuntu 20.04 LTS |
| Web Server | Apache2 |
| CMS | WordPress |
| Database | MySQL |
| Language | PHP |
| SSL Certificate | Let's Encrypt (via Certbot) |
| DNS | AWS Route 53 + GoDaddy |

---

## 📋 Setup Steps

### 1. Launch EC2 & Associate Elastic IP
- Launched an Ubuntu 20.04 EC2 instance on AWS
- Associated an Elastic IP (`113.50.212.235`) for a stable, fixed public address

### 2. Connect via SSH
```bash
ssh -i "your-key.pem" ubuntu@113.50.212.235
```
Switched from the default public IP to the Elastic IP in the SSH config.

### 3. Update & Upgrade the System
```bash
sudo apt update
sudo apt upgrade
```

### 4. Install Apache Web Server
```bash
sudo apt install apache2
```

### 5. Install PHP & MySQL
```bash
sudo apt install php php-mysql
sudo apt install mysql-server
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc
```

### 6. Configure MySQL for WordPress
```sql
-- Login to MySQL
sudo mysql -u root

-- Change authentication plugin
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_strong_password';

-- Create a WordPress database user
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'your_strong_password';

-- Create the WordPress database
CREATE DATABASE wp;

-- Grant all privileges
GRANT ALL PRIVILEGES ON wp.* TO 'wp_user'@'localhost';

FLUSH PRIVILEGES;
EXIT;
```

### 7. Install WordPress
```bash
cd /var/www/html
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz
sudo mv wordpress/* /var/www/html/
sudo systemctl restart apache2
```

### 8. Configure Apache Virtual Host
```bash
sudo nano /etc/apache2/sites-available/wordpress.conf
```
Set `DocumentRoot` to `/var/www/html/wordpress`, then:
```bash
sudo a2ensite wordpress.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
```

### 9. Link Custom Domain via Route 53
- Created a Hosted Zone in AWS Route 53 for `cybershieldme.info`
- Added an **A record** pointing to Elastic IP `113.50.212.235`
- Updated GoDaddy nameservers to the 4 Route 53 nameservers provided

### 10. Enable SSL/TLS with Certbot
```bash
# Install Certbot + Apache plugin
sudo apt install certbot python3-certbot-apache

# Run Certbot (auto-configures Apache for HTTPS)
sudo certbot --apache -d cybershieldme.info

# Check UFW firewall allows HTTPS
sudo ufw allow 'Apache Full'
```
Certbot connects to Let's Encrypt, verifies the domain, and writes SSL certificates to `/etc/letsencrypt/live/cybershieldme.info/`.

---

## 📁 Repository Structure

```
cybershieldme-aws-wordpress-site/
├── README.md
├── website/
│   └── index.html          ← Project showcase page
└── documentation/
    └── ASSIGMENT2.docx     ← Full step-by-step documentation with screenshots
```

---

## 📚 Documentation

Full step-by-step documentation including terminal screenshots is available in:
- [`documentation/ASSIGMENT2.docx`](./documentation/ASSIGMENT2.docx)

---

## ⚠️ Why the Site is Offline

The live site at `cybershieldme.info` is no longer accessible because the AWS EC2 instance was shut down after the free tier period ended. All implementation steps, commands, and screenshots are preserved in the documentation above.

---

## 📖 References

- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [WordPress Installation Guide](https://wordpress.org/support/article/how-to-install-wordpress/)
- [Certbot + Apache on Ubuntu](https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal)
- [AWS Route 53 DNS Setup](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)
