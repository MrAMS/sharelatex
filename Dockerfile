FROM sharelatex/sharelatex:latest

# ref: https://www.tug.org/texlive/upgrade.html
RUN cd /usr/local/texlive/ && \
    mv $(latex --version | head -n 1 | awk '{gsub(/\)/, "", $NF); print $NF}') 2024 && \
    sed -i 's/texlive\/2021/texlive\/2024/g' ~/.bashrc && \
    source ~/.bashrc && wget https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet/update-tlmgr-latest.sh && \
    sh update-tlmgr-latest.sh -- --upgrade
RUN tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet && tlmgr update --self --all && tlmgr install scheme-full

# 使用minted包
RUN apt update && apt install -y \
    python3 \
    python3-pip
RUN pip config set global.index-url http://mirrors.aliyun.com/pypi/simple && pip config set install.trusted-host mirrors.aliyun.com && pip install pygments
RUN echo 'shell_escape = t' | tee -a /usr/local/texlive/2023/texmf.cnf
