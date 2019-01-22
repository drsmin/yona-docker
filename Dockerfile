# 1. alpine (패키지 업데이트 + 만든사람 표시)
FROM alpine:3.8
MAINTAINER drs@drs.pe.kr
RUN apk update

# yona 버전 및 다운로드 경로 설정
ARG YONA_VERSION=1.11.1
ARG YONA_BIN=yona-v${YONA_VERSION}-bin.zip
ARG YONA_DOWNLOAD_URL=https://github.com/yona-projects/yona/releases/download/v${YONA_VERSION}/${YONA_BIN}

# 언어 설정
ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

# TimeZone 설정
ENV TZ Asia/Seoul

# 2. 패키지 설치
RUN apk add openjdk8-jre-base mariadb mariadb-client bash curl

# 3. 필요파일 복사
ADD ./conf/my.cnf /etc/mysql/
ADD ./sql/init.sql /data/ 
ADD ./docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh

# 4 yona download
RUN cd /data && \
    wget --no-check-certificate ${YONA_DOWNLOAD_URL} && \
    unzip -d /data ${YONA_BIN} && \
    mv /data/yona-${YONA_VERSION} /data/yona-dist && \
    cat /data/yona-dist/bin/yona > /dev/null && \
    rm -f ${YONA_BIN}

# 5. 초기실행
VOLUME ["/data/mysql", "/data/yona"]
ENV DB_DATA_PATH /data/mysql
EXPOSE 9000
ENTRYPOINT /docker-entrypoint.sh
