# Deep Dive into Clair Image Vulnerability Scanning

## Clair Documentation

* [What is ClairCore](https://quay.github.io/claircore/what_is.html)
* [Updaters and Defaults](https://quay.github.io/claircore/concepts/updater_defaults.html)

## Vulnerability Databases

* Alpine security database
  https://secdb.alpinelinux.org/
* Amazon Linux security database repodata/updateinfo.xml.gz
  https://cdn.amazonlinux.com/2/core/2.0/x86_64/3c5ff503186aefc295ca296adf15aa0884f998fff0c78d5fc6448735eb664d26/repodata/updateinfo.xml.gz
* Debian security database
  https://www.debian.org/security/oval/
* Oracle Linux security database
  https://linux.oracle.com/security/oval/
* Python security database
  https://github.com/pyupio/safety-db
* RHEL security database
  https://www.redhat.com/security/data/oval/v2/PULP_MANIFEST
* SUSE
  https://support.novell.com/security/oval/
* Ubuntu
  https://ubuntu.com/security/oval
* VMware Photon security database
  https://packages.vmware.com/photon/photon_oval_definitions/
* CVSS enrichment
  https://nvd.nist.gov/vuln/data-feeds

## Using cctool to Scan an Image

Clone ClairCore git repository:

```
$ git clone https://github.com/quay/claircore.git
```

Build and install cctool:

```
$ cd claircore
$ go install ./cmd/cctool
```

Start Clair core:

```
$ make podman-dev-up
```

Connect to Clair PostgreSQL database:

```
$ psql --host localhost --port 5434 --dbname claircore --user claircore
```

Create a vulnerability report:

```
$ cctool report -dump=true quay.io/noseka1/deep-dive-into-clair
2021/08/23 18:14:14 wrote "deep-dive-into-clair.manifest.json"
2021/08/23 18:14:44 wrote "deep-dive-into-clair.index.json"
2021/08/23 18:14:44 wrote "deep-dive-into-clair.report.json"
deep-dive-into-clair found urllib3         1.24.2       pyup.io-38834 (CVE-2020-26137)
deep-dive-into-clair found python3-urllib3 1.24.2-2.el8 RHSA-2021:1631: python-urllib3 security update (Moderate) (fixed: 0:1.24.2-5.el8)
deep-dive-into-clair found python3-urllib3 1.24.2-2.el8 RHSA-2021:1631: python-urllib3 security update (Moderate) (fixed: 0:1.24.2-5.el8)
deep-dive-into-clair found pip             9.0.3        pyup.io-38765 (CVE-2019-20916)
deep-dive-into-clair found pip             9.0.3        pyup.io-40291 (CVE-2021-28363)
deep-dive-into-clair found haproxy         1.8.15-5.el8 RHSA-2020:1725: haproxy security, bug fix, and enhancement update (Moderate) (fixed: 0:1.8.23-3.el8)
deep-dive-into-clair found haproxy         1.8.15-5.el8 RHSA-2020:1288: haproxy security update (Critical)                           (fixed: 0:1.8.15-6.el8_1.1)
deep-dive-into-clair found haproxy         1.8.15-5.el8 RHSA-2020:1725: haproxy security, bug fix, and enhancement update (Moderate) (fixed: 0:1.8.23-3.el8)
deep-dive-into-clair found haproxy         1.8.15-5.el8 RHSA-2020:1288: haproxy security update (Critical)                           (fixed: 0:1.8.15-6.el8_1.1)
```

## Inspecting Image Layers

```
$ podman save quay.io/noseka1/deep-dive-into-clair > deep-dive-into-clair.tar
$ mkdir deep-dive-into-clair.tar.extract
$ tar -C deep-dive-into-clair.tar.extract -xvf deep-dive-into-clair.tar
```

## Using ClairCore APIs

Create image manifest:

```
$ cctool manifest quay.io/noseka1/deep-dive-into-clair > manifest.json
```

Create image index:

```
$ curl --data-binary @manifest.json -X POST http://localhost:8080/index_report > index.json
```

Create vulnerability report:

```
$ curl --data-binary @index.json -X POST http://localhost:8081/vulnerability_report > report.json
```
