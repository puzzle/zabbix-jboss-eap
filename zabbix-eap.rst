Configuring Zabbix for JBoss EAP monitoring
===========================================

Tested with Zabbix 3.2 and JBoss EAP 6.4.

1. Make sure you have a working Zabbix 3.2 and JBoss EAP 6.x installation
...


reword
 # Access to each Java gateway is configured directly in Zabbix server or proxy configuration file, thus only one Java gateway may be configured per Zabbix server or Zabbix proxy.


2. Add a JMX interface to JBoss EAP host you want to monitor.the host who is running the Zabbix Java Gateway and monitoring your JBoss EAP servers via JMX, e.g.
127.0.0.1:10052
DNS, _service._jmx._remoting-jmx.localhost, 9999

Add item with:
interface, username, password, key: jmx["java.lang:type=Memory","HeapMemoryUsage.used"]