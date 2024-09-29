# ShareLatex

[sharelatex/sharelatex](https://hub.docker.com/r/sharelatex/sharelatex)不是完整的texlive，缺少很多必要的包。本项目基于该镜像并自动更新texlive至2024，并安装完整的约4600+个宏包。

可供参考的一个`docker-compose.yml`

```yml
# ...
  sharelatex:
    restart: always
    build: ./sharelatex/
    depends_on:
        mongo:
            condition: service_healthy
        redis:
            condition: service_started
    ports:
        - "5123:80"
    links:
        - mongo
        - redis
    stop_grace_period: 60s
    volumes:
        - ./data/sharelatex:/var/lib/overleaf
    environment:

        SHARELATEX_APP_NAME: Overleaf Community Edition

        SHARELATEX_MONGO_URL: mongodb://mongo/sharelatex

        # Same property, unfortunately with different names in
        # different locations
        SHARELATEX_REDIS_HOST: redis
        REDIS_HOST: redis

        ENABLED_LINKED_FILE_TYPES: 'url,project_file,project_output_file'

        # Enables Thumbnail generation using ImageMagick
        ENABLE_CONVERSIONS: 'true'

        # Disables email confirmation requirement
        EMAIL_CONFIRMATION_DISABLED: 'true'

        # temporary fix for LuaLaTex compiles
        # see https://github.com/overleaf/overleaf/issues/695
        TEXMFVAR: /var/lib/overleaf/tmp/texmf-var

        ## Set for SSL via nginx-proxy
        #VIRTUAL_HOST: 103.112.212.22

        # SHARELATEX_SITE_URL: http://overleaf.example.com
        SHARELATEX_NAV_TITLE: XXX's Overleaf
        # SHARELATEX_HEADER_IMAGE_URL: http://example.com/mylogo.png
        # SHARELATEX_ADMIN_EMAIL: support@it.com

        # SHARELATEX_LEFT_FOOTER: '[{"text": "Another page I want to link to can be found <a href=\"here\">here</a>"} ]'
        SHARELATEX_RIGHT_FOOTER: '[{"text": "自建Overleaf"} ]'

        # SHARELATEX_EMAIL_FROM_ADDRESS: "hello@example.com"

        # SHARELATEX_EMAIL_AWS_SES_ACCESS_KEY_ID:
        # SHARELATEX_EMAIL_AWS_SES_SECRET_KEY:

        # SHARELATEX_EMAIL_SMTP_HOST: smtp.example.com
        # SHARELATEX_EMAIL_SMTP_PORT: 587
        # SHARELATEX_EMAIL_SMTP_SECURE: false
        # SHARELATEX_EMAIL_SMTP_USER:
        # SHARELATEX_EMAIL_SMTP_PASS:
        # SHARELATEX_EMAIL_SMTP_TLS_REJECT_UNAUTH: true
        # SHARELATEX_EMAIL_SMTP_IGNORE_TLS: false
        # SHARELATEX_EMAIL_SMTP_NAME: '127.0.0.1'
        # SHARELATEX_EMAIL_SMTP_LOGGER: true
        # SHARELATEX_CUSTOM_EMAIL_FOOTER: "This system is run by department x"

        # ENABLE_CRON_RESOURCE_DELETION: true
    networks:
      - web_network
  mongo:
    restart: always
    image: mongo:5.0
    container_name: mongo
    expose:
        - 27017
    volumes:
        - ./data/mongo:/data/db
    healthcheck:
        test: echo 'db.stats().ok' | mongo localhost:27017/test --quiet
        interval: 10s
        timeout: 10s
        retries: 5
    networks:
      - web_network

  redis:
    restart: always
    image: redis:5.0
    container_name: redis
    expose:
        - 6379
    volumes:
        - ./data/redis:/data
    networks:
      - web_network
```
