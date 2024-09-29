FROM sharelatex/sharelatex:latest

# ref: https://www.tug.org/texlive/upgrade.html
ENV PATH=/usr/local/texlive/2024/bin/x86_64-linux:$PATH
RUN cd /usr/local/texlive/ && \
    mv $(latex --version | head -n 1 | awk '{gsub(/\)/, "", $NF); print $NF}') 2024 && \
    wget https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet/update-tlmgr-latest.sh && \
    sh update-tlmgr-latest.sh -- --upgrade && \
    tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet && \
    tlmgr update --self --all && \
    tlmgr install scheme-full

# 使用minted包
RUN apt update && \
    set -xe && apt install -y \
    python3 \
    python3-pip && \
    python3 -m pip install pygments -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    echo 'shell_escape = t' | tee -a /usr/local/texlive/2024/texmf.cnf