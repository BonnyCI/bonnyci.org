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

* Dedicated VM (on-site)

## Frequency and Retention

Github repos are to be backed-up once per week, with one-month retention.

Zuul merger repos are to be backed up once per day and retained for 2 weeks.

System and service logs are to be backed up fully once per day, and
incrementally once per hour; with a retention of one month.

Test output is to be backed up fully once per week, and incrementally once per
day; with a retention of one week.
