FROM registry.redhat.io/ubi8-minimal

RUN microdnf install --assumeyes haproxy-1.8.15-5.el8.x86_64

RUN microdnf install --assumeyes python3-urllib3-1.24.2-2.el8.noarch
