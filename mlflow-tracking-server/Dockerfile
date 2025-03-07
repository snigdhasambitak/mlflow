FROM python:3.10-slim-bullseye

RUN apt update && \
    apt install -y gcc build-essential && \
    apt-get autoremove -yqq && \
    apt-get clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base

ADD requirements.txt /tmp/requirements.txt

RUN pip install --no-cache -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT [ "/bin/entrypoint.sh" ]
