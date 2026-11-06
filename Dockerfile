FROM php:8.2-apache

# Seguridad: ocultar versiones y enviar cabeceras de seguridad
RUN a2enmod headers \
 && echo "expose_php = Off" > /usr/local/etc/php/conf.d/zz-seguridad.ini \
 && { \
      echo 'ServerTokens Prod'; \
      echo 'ServerSignature Off'; \
      echo 'TraceEnable Off'; \
      echo '<Directory /var/www/html>'; \
      echo '    Options -Indexes'; \
      echo '</Directory>'; \
      echo 'Header always set Strict-Transport-Security "max-age=31536000"'; \
      echo 'Header always set X-Content-Type-Options "nosniff"'; \
      echo 'Header always set X-Frame-Options "SAMEORIGIN"'; \
      echo 'Header always set Referrer-Policy "strict-origin-when-cross-origin"'; \
      echo 'Header always set Permissions-Policy "camera=(), microphone=(), geolocation=()"'; \
      echo "Header always set Content-Security-Policy \"frame-ancestors 'self'; base-uri 'self'; object-src 'none'; upgrade-insecure-requests\""; \
      echo 'Header always unset X-Powered-By'; \
    } > /etc/apache2/conf-available/seguridad.conf \
 && a2enconf seguridad

COPY . /var/www/html/
RUN rm -f /var/www/html/Dockerfile && chown -R www-data:www-data /var/www/html
EXPOSE 80
