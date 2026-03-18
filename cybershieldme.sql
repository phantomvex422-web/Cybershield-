-- ============================================================
--  CyberShieldMe — WordPress Database Setup
--  Student: Uthara Manojkumar | ID: 35354777
--  Domain:  cybershieldme.info
-- ============================================================

CREATE DATABASE IF NOT EXISTS wp;

CREATE USER IF NOT EXISTS 'wp_user'@'localhost'
  IDENTIFIED WITH mysql_native_password BY 'StrongPassword123!';

GRANT ALL PRIVILEGES ON wp.* TO 'wp_user'@'localhost';
FLUSH PRIVILEGES;
USE wp;

-- Table: users
CREATE TABLE IF NOT EXISTS users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(100) NOT NULL UNIQUE,
  email         VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role          ENUM('admin', 'editor', 'subscriber') DEFAULT 'subscriber',
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: posts
CREATE TABLE IF NOT EXISTS posts (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  user_id    INT NOT NULL,
  title      VARCHAR(255) NOT NULL,
  content    TEXT,
  status     ENUM('published', 'draft', 'private') DEFAULT 'draft',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table: comments
CREATE TABLE IF NOT EXISTS comments (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  post_id    INT NOT NULL,
  user_id    INT NOT NULL,
  comment    TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table: server_config
CREATE TABLE IF NOT EXISTS server_config (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  config_key   VARCHAR(100) NOT NULL UNIQUE,
  config_value VARCHAR(255) NOT NULL,
  description  TEXT
);

-- Sample data: users
INSERT INTO users (username, email, password_hash, role) VALUES
('uthara_admin', 'uthara@cybershieldme.info', SHA2('adminpass123', 256), 'admin'),
('editor_mk',    'editor@cybershieldme.info', SHA2('editorpass', 256),  'editor'),
('subscriber1',  'user1@example.com',         SHA2('userpass123', 256),  'subscriber');

-- Sample data: posts
INSERT INTO posts (user_id, title, content, status) VALUES
(1, 'Welcome to CyberShieldMe', 'Hosted on AWS EC2 with Apache and WordPress.', 'published'),
(1, 'How I Set Up My Cloud Server', 'Ubuntu EC2, Elastic IP, Apache, MySQL, WordPress.', 'published'),
(2, 'SSL Configuration Notes', 'Certbot + Apache plugin for HTTPS on cybershieldme.info.', 'published'),
(1, 'Draft: Future Plans', 'Contact form, blog section, managed RDS migration.', 'draft');

-- Sample data: comments
INSERT INTO comments (post_id, user_id, comment) VALUES
(1, 3, 'Great site! Love the clean design.'),
(2, 2, 'Very detailed setup guide.'),
(1, 1, 'Thanks! Built this for my cloud computing assignment.');

-- Sample data: server config
INSERT INTO server_config (config_key, config_value, description) VALUES
('elastic_ip',   '113.50.212.235',    'Fixed public IP on EC2'),
('domain',       'cybershieldme.info', 'Custom domain via GoDaddy'),
('dns_provider', 'AWS Route 53',      'Hosted zone with A record'),
('web_server',   'Apache 2.4',        'Installed on Ubuntu 20.04'),
('ssl_provider', 'Let\'s Encrypt',     'Via Certbot + Apache plugin'),
('os',           'Ubuntu 20.04 LTS',  'EC2 instance OS'),
('instance_type','t2.micro',          'AWS free tier instance');

-- Useful queries
-- SELECT p.title, u.username FROM posts p JOIN users u ON p.user_id = u.id WHERE p.status = 'published';
-- SELECT * FROM server_config;