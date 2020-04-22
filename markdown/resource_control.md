# Resource Control in Kubernetes

Kubernetes exposes resource control through pod requests and limits on CPU and
memory. While the scheduler understands things like extended resources, the core
Kubernetes APIs integrate most deeply with CPU and memory. Linux uses cgroups
for management of both resources.

## cgroups

cgroups form the basis for resource control in the Linux kernel, from allowing
device access to placing limits on amount of memory usage. cgroups are most
effective when used in a proper hierarchy: children of a parent cgroup divide
all of the parents resources sensibly. For each supported subsystem, there is a
cgroup controller for the corresponding resource: CPU, memory, cpuset
(controlling which CPUs or memory nodes a process runs on), and an ongoing
attempt to integrate a GPU controller.

TODO(ace): introspecting cgroups 

```bash
systemd-cgls # view hierarchy, can look at subtrees from a given directory
cd /sys/fs/cgroup/{cpu/memory}
cat /sys/fs/cgroup/cpu/cpu.{shares,cfs_quota,cfs_period_us,cfs_quota_us}
cat /sys/fs/cgroup/memory/memory.limit_in_bytes
```

### Memory

The memory controller is one of the older and more stable controllers. It can
enforce a hard cap on memory usage in a cgroup. In Kubernetes, the memory
controller enforces pod memory limits. We'll go into more detail on how this is
configured later.

### CPU

CPU scheduling is more complex. The main scheduler in use is the Completely Fair
Scheduler (CFS). CFS exposes two interfaces, one to establish relative shares of
CPU time and another to enforce hard caps. CFS uses the value of cpu.shares to
indicate the relative amount of CPU time to allocate to a node compared to its
siblings in the hierarchy. These values are best understood through examples.

#### cpu.shares

TODO(ace): explain hierarchical behavior

TODO(ace): explain work conserving nature

Assume a 12 CPU machine. There exists a root cgroup containing 6000 shares with
no resource consumption on the machine. This root cgroup has two children. The left child has 2 shares
and the right child has 4. If both processes attempt to use as much CPU as
possible, the scheduler will allocate 8 cores to the right child and 4 cores to
the left child: there are no other processes on the machine sharing the root
cgroup, and the ratio of right:left resources is 2:1, reflected in the scheduler
decision.

Read more in the [Linux kernel documentation][0].

#### cpu.cfs_period_us, cpu.cfs_quota_us

CFS enforces bandwidth control through these settings. 

## Kubernetes Pods

TODO(ace): Pod QoS -> oomkiller scores
TODO(ace): Pod priority -> kubelet eviction order
TODO(ace): eviction by amount exceeding requests

[0]: https://www.kernel.org/doc/html/latest/scheduler/sched-design-CFS.html
