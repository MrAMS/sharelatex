FROM sharelatex/sharelatex:latest

COPY check_tex.sh check_tex.sh
RUN chmod +x check_tex.sh && ./check_tex.sh
RUN tlmgr update --self && tlmgr install scheme-full

# 使用minted包
RUN apt update && apt install -y \
    python3 \
    python3-pip
RUN pip config set global.index-url http://mirrors.aliyun.com/pypi/simple && pip config set install.trusted-host mirrors.aliyun.com && pip install pygments
RUN echo 'shell_escape = t' | tee -a /usr/local/texlive/2023/texmf.cnf
