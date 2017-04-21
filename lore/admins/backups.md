---
name: backups
layout: default
permalink: /lore/admins/backups/
---

# Backups

## Table of Contents

* [Risks](#risks)
* [Backup Sources](#backup-sources)
* [Backup Destinations](#backup-destinations)
* [Frequency and Retention](#frequency-and-retention)
* [Implementation Details](#implementation-details)

## Risks

Since all of our state is stored by github.com, and since all of our secrets
can be regenerated or rediscovered after complete loss of the bastion host,
we have no backup requirements critical to recovery from disaster.  However,
to reduce disaster recovery time, and to facilitate potential root-cause
analyses, there are several nice-to-have backup items.

## Backup Sources

* Git Repos
  * Github
    * `master` branch
    * Any active feature branches
  * Zuul mergers
    * All branches
    * `refs/zuul/\*`
* System logs
  * All hosts on the control plane
* Service logs
  * Apache
  * ELK
  * Nodepool
  * Zuul
* Test Output

## Backup Destination

* Dedicated VM (`backups.internal.opentechsjc.bonnyci.org`)

## Frequency and Retention

| Source | Frequency | Retention |
| ------ | --------- | --------- |
| Github Repos | Daily | 1 Month |
| Zuul Merger git repos | Daily | 2 weeks |
| System logs | Hourly | 1 Month |
| Service logs | Hourly | 1 Month |
| Test output | Daily | 2 weeks |

## Implementation Details

We use [borg backup](https://borgbackup.readthedocs.io/en/stable/index.html) to
implement our backup strategy. For more information, read
[this quickstart](https://borgbackup.readthedocs.io/en/stable/quickstart.html).

In order to use a pull model rather than a push model for better trust
management, we augment borg backup with sshfs to mount the client filesystem
on the backup host over ssh.

Each client host has a dedicated borg repo which contains two types of
snapshots: `hourly` and `daily`. The snapshot name is prefixed with the type,
followed by an ISO-8601 date. *Daily and hourly snapshots do NOT contain the
same file sets*.

### Creating Backups

The backup-server role in hoist configures the bulk of the setup, including
two cron jobs: an hourly job and a daily job. Each job loops through the
configured hosts and performs the following steps:

1. Mounts the entire client host filesystem using sshfs and the root user.
2. Creates a new snapshot of the configured paths for the type of frequency.
3. Deletes expired snapshots, if any.
4. Unmounts the client filesystem.

The job then moves on to the next host and repeats the process.

### Restoring from a Backup

In order to restore from a backup, first become the backup user:

```text
cideploy@bastion $ ssh ubuntu@backups.internal.opentechsjc.bonnyci.org
ubuntu@backups $ sudo -i -u backup
backup@backups $
```

Next, list available snapshots for the given host:

```text
backup@backups $ borg list -v /var/lib/backups/${HOST}
```

This will display the snapshot names on the left and their creation date on the
right.

To examine the contents of a snapshot:

```text
backup@backups $ borg list -v /var/lib/backups/${HOST}::${SNAPSHOT}
```

Once a snapshot to restore has been chosen, mount the client filesystem on the
backup server:

```text
backup@backups $ sshfs root@${CLIENT}:/ /mnt/sshfs/${CLIENT}
```

To restore specific files or directories from the snapshot:

```text
backup@backups $ borg extract -v /var/lib/backups/${HOST}::${SNAPSHOT} ${FILES}
```

#### OR

To restore the entire snapshot:

```text
backup@backups $ borg extract -v /var/lib/backups/${HOST}::${SNAPSHOT}
```

Finally, make sure to unmount the client filesystem:

```text
backup@backups $ fusermount -u /mnt/sshfs/${CLIENT}
```
