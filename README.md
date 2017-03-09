Configuring Zabbix for JBoss EAP monitoring
===========================================

Tested with Zabbix 3.2 and JBoss EAP 6.4.

1. Make sure you have a working Zabbix 3.2 and JBoss EAP 6.x installation
...

Access to each Java gateway is configured directly in Zabbix server or proxy configuration file, thus only one Java gateway may be configured per Zabbix server or Zabbix proxy.

2. Add JBoss EAP management user
   /opt/jboss-eap-6.4/bin/add-user.sh -u zabbix -p Zabbix42_

2. Install patched Zabbix Java Gateway https://devzone.ch/~tschan/zabbix-java-gateway-3.2.3-1.el7.centos.x86_64.rpm

3. Configure Java Gateway in ``/etc/zabbix/zabbix_server.conf``:

/etc/zabbix/zabbix_server.conf:

    JavaGateway = localhost
    StartJavaPollers = 1

https://www.zabbix.com/documentation/3.2/manual/concepts/java

4. cp /opt/jboss-eap-6.4/bin/client/jboss-client.jar /usr/share/zabbix-java-gateway/lib

5. Enable ``zabbix-java-gateway`` service

6. Add a JMX interface to JBoss EAP host you want to monitor.the host who is running the Zabbix Java Gateway and monitoring your JBoss EAP servers via JMX, e.g.
127.0.0.1:10052
DNS, _service._jmx._remoting-jmx.localhost, 9999

7. Add item with:
interface, username, password, key: jmx["java.lang:type=Memory","HeapMemoryUsage.used"]


https://github.com/marcanpilami/Zabbix-JBoss-Agent


## Troubleshooting

com.zabbix.gateway.ZabbixException: javax.security.sasl.SaslException: Authentication failed: the server presented no authentication mechanisms
 => User cannot log in, e.g. because of missing or incorrent login data in Zabbix or missing user in EAP
