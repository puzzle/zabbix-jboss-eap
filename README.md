Configuring Zabbix for JBoss EAP monitoring
===========================================

Tested with Zabbix 3.2 and JBoss EAP 6.4.

1. Make sure you have a working Zabbix 3.2 and JBoss EAP 6.x installation
...

Access to each Java gateway is configured directly in Zabbix server or proxy configuration file, thus only one Java gateway may be configured per Zabbix server or Zabbix proxy.

2. Add JBoss EAP management user
   /opt/jboss-eap-6.4/bin/add-user.sh -u zabbix -p <password>

2. Install patched Zabbix Java Gateway matching the version of you Zabbix installation from the releases of this repository.

3. Configure Java Gateway in ``/etc/zabbix/zabbix_server.conf``:

/etc/zabbix/zabbix_server.conf:

    JavaGateway = localhost
    StartJavaPollers = 1

https://www.zabbix.com/documentation/3.2/manual/concepts/java

4. cp /opt/jboss-eap-6.4/bin/client/jboss-client.jar /usr/share/zabbix-java-gateway/lib

5. Enable ``zabbix-java-gateway`` service

6. Add a JMX interface to JBoss EAP host you want to monitor.the host who is running the Zabbix Java Gateway and monitoring your JBoss EAP servers via JMX, e.g.

* DNS: _service._jmx._remoting-jmx.localhost 
* Port: 9999

7. Add item with:
interface, username, password, key: jmx["java.lang:type=Memory","HeapMemoryUsage.used"]

## Troubleshooting

com.zabbix.gateway.ZabbixException: javax.security.sasl.SaslException: Authentication failed: the server presented no authentication mechanisms
 => User cannot log in, e.g. because of missing or incorrent login data in Zabbix or missing user in EAP

## Build Patched Java Gateway RPM

The following steps describe how to build the patched Java Gateway RPM:

* Download the Source RPM (SRPM) of Zabbix in the same version as your Server
```
curl -L -O http://repo.zabbix.com/zabbix/3.2/rhel/7/SRPMS/zabbix-3.2.3-1.el7.src.rpm
```
* Install the SRPM (this installs the files to `~/rpmbuild/`)
```
rpm -ihv zabbix-3.2.7-1.el7.src.rpm
```
* Add the patch to the files
```
cd ~/rpmbuild/SOURCES
curl -O https://raw.githubusercontent.com/puzzle/zabbix-jboss-eap/master/zabbix-3.2.3-jmx-remoting.patch
```
* Add the patch to the specfile
  * Open `~/rpmbuild/SPECS/zabbix
  * Look for `Patch` and add your patch
  * Look for `%patch` and apply your patch
```
...
Patch3:         zabbix-3.2.3-jmx-remoting.patch
...
%patch3 -p1
...
```
* Install build dependencies
```
yum install rpm-build gcc
yum-builddep ~/rpmbuild/SPECS/zabbix.spec
```
* Build the RPM
```
rpmbuild -bb ~/rpmbuild/SPECS/zabbix.spec
```

## Resources

* https://www.zabbix.org/wiki/ConfigureJMX
* https://www.zabbix.org/wiki/Docs/howto/jmx_discovery
* https://github.com/jmxtrans/jmxtrans/wiki/MoreExamples
