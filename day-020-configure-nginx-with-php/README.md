# PHP Application Deployment with Nginx and PHP-FPM

## 1. What is the Challenge?

Configure App Server 3 to host a PHP-based application using Nginx and PHP-FPM.

Requirements:

- Install Nginx
- Install PHP-FPM 8.1
- Configure Nginx to listen on port **8094**
- Use `/var/www/html` as the document root
- Configure PHP-FPM to communicate over the Unix socket:
  `/var/run/php-fpm/default.sock`
- Verify the application is accessible from the jump host

## 2. Required Technologies

- Linux
- Nginx
- PHP 8.3
- PHP-FPM
- Systemd
- Networking

## 3. How to Solve It

1. Install Nginx and PHP-FPM
2. Configure PHP-FPM to use the required Unix socket
3. Configure Nginx to:
   - Listen on port **8094**
   - Serve files from `/var/www/html`
   - Forward PHP requests to PHP-FPM
4. Validate both configurations
5. Enable and restart both services
6. Test locally and from the jump host

## 4. Main Takeaways

- Learned how Nginx communicates with PHP-FPM using Unix sockets
- Configured a custom HTTP port
- Deployed a PHP application without modifying application files
- Verified service functionality using curl
- Validated configuration before restarting services

## 5. Conclusion

This task demonstrates how to deploy a PHP application using Nginx and PHP-FPM with a Unix socket for efficient communication. It also highlights the importance of proper service configuration, validation, and testing to ensure the application is accessible and functioning correctly.
