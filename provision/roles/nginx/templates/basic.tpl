server {
    listen  80;

    root {{ nginx.docroot }};
    index index.php index.html index.htm;

    server_name {{ nginx.servername }};
    sendfile  off;

    location / {
        try_files $uri /index.php?$query_string;
    }

    location ~ \.php$ {
       fastcgi_split_path_info ^(.+\.php)(/.+)$;
       fastcgi_pass unix:/var/run/php5-fpm.sock;
       fastcgi_index index.php;
       include fastcgi_params;
    }

    {% if nginx.expiration == true %}
    location ~* \.(?:ico|css|js|gif|jpe?g|png|svg)$ {
      expires {{ nginx.expire }};
      add_header Pragma public;
      add_header Cache-Control "public, must-revalidate, proxy-revalidate";
    }
    {% endif %}
}
