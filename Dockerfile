FROM registry.redhat.io/ubi8-minimal

RUN microdnf install --assumeyes haproxy-1.8.15-5.el8.x86_64
