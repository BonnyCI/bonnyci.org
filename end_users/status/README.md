---
name: status
layout: default
---

# Status

## Table of Contents

* [BonnyCI Status ScreenBoard](#bonnyci-status-screenboard)
  * [System Load](#system-load)
  * [Disk Free](#disk-free)
  * [Zuul Event Queue Length](#zuul-event-queue-length)
  * [Zuul Pipelines](#zuul-pipelines)
  * [Service Status](#service-status)

## BonnyCI Status ScreenBoard

This section explains the components of the [BonnyCI Status ScreenBoard](https://p.datadoghq.com/sb/cbf19e221-1b77fb05f2)

### System Load

The system load graph takes the average CPU load percentage over one minute intervals and uses each reading as a data point. The entire graph is the plotting of these data points over the span of one hour, and is updated in real time. Currently, only the nodepool, zuul, logs, and bastion hosts are represented on this graph.

The system load host map provides an on-the-fly view of all systems in the cluster. Each system in the cluster is displayed as a hexagon and filled in with a color. Hovering over the hexagon will show the hostname of the system. A white hexagon indicates the system is powered off. A green hexagon indicates the system is idle (average system load of 0.00), while a red hexagon indicates the system's CPU is 100% utilized. The hexagon's color will change from green to red over a gradient in which its shade corresponds to its CPU load reading.

### Disk Free

The disk free graph displays the amount of free space (in gigabytes) a host has over a period of one hour. Currently, only the nodepool, zuul, logs, and bastion hosts are represented on this graph.

### Zuul Event Queue Length

The Zuul Event Queue Length graph displays the number of items (pull requests) that are waiting to be tested by BonnyCI. As more projects consume a single BonnyCI and more pull requests are opened concurrently to these projects, this queue will grow accordingly. The graph displays these queue lengths over a period of one hour, and is updated in real time.

### Zuul Pipelines

The Zuul Pipelines counter provides an easy look at how many pipelines exist in a BonnyCI. Pipelines are usually configured on a per-project basis, so the number of pipelines can be a rough indicator of how many projects are consuming a particular BonnyCI.

### Service Status

Nodepool, Zookeeper, and Zuul are three core services that are essential to the stability of a BonnyCI cluster. If anything except the green "OK" message is displayed for these service statuses, then BonnyCI could be experiencing a full service outage.
